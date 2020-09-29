#!/usr/bin/env bash

# ______________________________________________________
# Hadouken project test script.
#
# @file 	project-test.sh
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	10.05.2020
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
  if [ "$#" -ge 1 ]; then
    case $1 in
      -gx|--gcov-xml)
        shift
        cmake --build ${RP["BUILD"]} ${@:1} --target $hadouken_top_level_project_name.gcovr.xml -- -j $(nproc)
      ;;
      -gh|--gcov-html)
        shift
        cmake --build ${RP["BUILD"]} ${@:1} --target $hadouken_top_level_project_name.gcovr.html -- -j $(nproc)
      ;;
      -l|--lcov)
        shift
        cmake --build ${RP["BUILD"]} ${@:1} --target $hadouken_top_level_project_name.lcov -- -j $(nproc)
      ;;
      *)
        echo "Unrecognized argument. Valid arguments are: "
        echo "-gx | --gcov-xml"
        echo "-gh | --gcov-html"
        echo "-l | --lcov"
        exit 1
      ;;
    esac
  else
      echo "You need to provide desired report output format (xml or html)."
  fi
else
    echo "Could not determine top level project name."
fi