#!/usr/bin/env bash

# ______________________________________________________
# Hadouken project-wide format script.
#
# @file 	project-format.sh
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	17.09.2020
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

if hadouken.get_top_level_project_name $SCRIPT_ROOT; then
    cmake --build ${RP["BUILD"]} ${@:1} --target $hadouken_top_level_project_name.format -- -j $(nproc)
else
    echo "Could not determine top level project name."
fi

