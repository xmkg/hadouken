#!/usr/bin/env bash

# ______________________________________________________
# Hadouken project update code
#
# @file     update-hadouken.sh
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date     14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier: Apache 2.0
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

readonly CURRENT_HADOUKEN_VERSION=$(git -C ${RP["BOILERPLATE"]} tag --points-at)

case $1 in
    -f|--force)
      git -C ${RP["BOILERPLATE"]} reset --hard origin/master
      shift
    ;;
    *)
    ;;
esac

if git -C ${RP["PROJECT"]} submodule update --init --recursive --remote .hadouken/ ; then
  
  readonly NEW_HADOUKEN_VERSION=$(git -C ${RP["BOILERPLATE"]} tag --points-at)
  
  if [ $CURRENT_HADOUKEN_VERSION == $NEW_HADOUKEN_VERSION ]; then
    echo "Hadouken upgraded from version $CURRENT_HADOUKEN_VERSION to $NEW_HADOUKEN_VERSION"
  else
    echo "Hadouken is already up-to-date."
  fi

  # Execute post-upgrade fix-ups here
fi
