#!/usr/bin/env bash

# ______________________________________________________
# Hadouken project configure script.
#
# @file 	project-configure.sh
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
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

if [ -d "${RP["BUILD"]}" ]; then
  # Take action if $DIR exists. #
  echo "Build root already exist"
else
    mkdir ${RP["BUILD"]}
fi

env_cmake_version=$(hadouken.get_cmake_version)
hadouken.compare_versions $env_cmake_version 3.13.5
result=$?

if [ $result -lt 2 ]; then
  cmake -S ${RP["PROJECT"]} -B ${RP["BUILD"]} ${@:1}
else
  cd ${RP["BUILD"]}
  cmake ${RP["PROJECT"]} ${@:1}
fi



