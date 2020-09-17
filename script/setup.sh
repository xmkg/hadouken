#!/usr/bin/env bash

# ______________________________________________________
# Hadouken setup code
#
# @file     setup.sh
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date     14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

SCRIPT_ROOT="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

# Relative paths
declare -A RP
# Common headers
source $SCRIPT_ROOT/common.sh && hadouken.define_relative_paths $SCRIPT_ROOT RP

echo -e "Script root: ${RP["SCRIPT"]}"
echo -e "Hadouken root: ${RP["BOILERPLATE"]}"
echo -e "Project folder: ${RP["PROJECT"]}"
echo -e "Project build folder: ${RP["BUILD"]}"
echo 

# Check if current folder has the proper name
if ! [[ ".hadouken" == "$(basename ${RP["BOILERPLATE"]})" ]] ; then
    echo "Hadouken root folder name is invalid. It should be named as .hadouken!"
    exit 1
fi

# Check if our parent directory is a git repository or not.
if ! git -C ${RP["PROJECT"]} rev-parse --is-inside-work-tree > /dev/null 2>&1 ; then
    echo "Hadouken's parent directory ${RP["PROJECT"]} is not a git directory!"
    exit 1
fi

if ! hadouken.has_cmakelist "${RP["PROJECT"]}"; then
    echo -e "Hadouken parent directory ${RP["PROJECT"]} does not contain a CMakeLists.txt"
    read -p "Do you want to quick-start a new cmake project to parent folder [Yy/Nn]? " -n 1 -r
    echo  
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        hadouken.bootstrap_cmake_project "${RP["PROJECT"]}"
    else
        exit 1
    fi
fi

# Create symlinks to parent
echo -e "Creating symlinks to parent repository"

declare -A symlinks=( 
    [".hadouken/dotfiles/.gitconfig"]="${RP["PROJECT"]}/.gitconfig" 
    [".hadouken/dotfiles/.gitignore"]="${RP["PROJECT"]}/.gitignore" 
    [".hadouken/dotfiles/.clang-format"]="${RP["PROJECT"]}/.clang-format" 
    [".hadouken/dotfiles/.clang-tidy"]="${RP["PROJECT"]}/.clang-tidy" 
    [".hadouken/dotfiles/.lcovrc"]="${RP["PROJECT"]}/.lcovrc" 
    [".hadouken/dotfiles/.cppcheck-suppress"]="${RP["PROJECT"]}/.cppcheck-suppress" 
    [".hadouken/dotfiles/.doxyfile"]="${RP["PROJECT"]}/.doxyfile" 
    ["../.hadouken/dotfiles/.vscode/settings.json"]="${RP["PROJECT"]}/.vscode/settings.json" 
    [".hadouken/.devcontainer"]="${RP["PROJECT"]}/.devcontainer" 
    [".hadouken/script/hadouken.sh"]="${RP["PROJECT"]}/hadouken"    
    ["build/compile_commands.json"]="${RP["PROJECT"]}/compile_commands.json"    
)

# docker-compose extension file
( touch ${RP["PROJECT"]}/.hadouken.docker-compose.extend.yml && echo "version: '3'" | tee ${RP["PROJECT"]}/.hadouken.docker-compose.extend.yml ) || true

# devenv container post-install script
touch ${RP["PROJECT"]}/.hadouken.bootstrap.sh || true

for key in "${!symlinks[@]}"
do
    value=${symlinks[$key]}
    if ! test -e "$value"; then
        echo -e "Creating symlink of $key to $value"
        # (mgilor) Create non-existing directories
        mkdir -p $(dirname ${value}) || true
        ln -s $key $value
    else
        echo -e "A symbol already exist on path $value, skipping symlink creation for $key"
    fi
done



# Check & prompt docker installation
. $SCRIPT_ROOT/install-docker.sh

# Check & prompt vscode installation
. $SCRIPT_ROOT/install-vscode.sh

# Check vscode extensions
. $SCRIPT_ROOT/install-vscode-extensions.sh

echo -e "Done! You're all set up."
