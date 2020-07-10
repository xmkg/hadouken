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

CURRENT_HADOUKEN_VERSION=$(git -C ${RP["BOILERPLATE"]} tag --points-at)

case $1 in
    -f|--force)
      git -C ${RP["BOILERPLATE"]} reset --hard origin/master
      shift
    ;;
    *)
    ;;
esac

echo "--------------------------------------------------"
echo "Phase 1: Initiating project update.."

readonly HADOUKEN_REPO_LAST_COMMIT_BEFORE_UPDATE=$(git -C ${RP["BOILERPLATE"]} rev-parse HEAD)

if git -C ${RP["PROJECT"]} submodule update --init --recursive --remote .hadouken/ ; then
  
  readonly HADOUKEN_REPO_LAST_COMMIT_AFTER_UPDATE=$(git -C ${RP["BOILERPLATE"]} rev-parse HEAD)
  NEW_HADOUKEN_VERSION=$(git -C ${RP["BOILERPLATE"]} tag --points-at)
  
  if [ -z "${NEW_HADOUKEN_VERSION}" ] ; then
    echo "!! Unable to determine new Hadouken version, probably you're following an"
    echo "!! non-official or experimental branch."
    NEW_HADOUKEN_VERSION="undefined"
  elif [ -z "${CURRENT_HADOUKEN_VERSION}" ] ; then
    echo "!! Unable to determine current Hadouken version, probably you're running on a"
    echo "!! modified, non-official or experimental version."
    CURRENT_HADOUKEN_VERSION="undefined"
  else
    if [ $CURRENT_HADOUKEN_VERSION == $NEW_HADOUKEN_VERSION ]; then
      echo "Hadouken is already up-to-date ($CURRENT_HADOUKEN_VERSION)"
    fi
  fi

  echo "Hadouken upgraded from version $CURRENT_HADOUKEN_VERSION to $NEW_HADOUKEN_VERSION"
  echo "Changelog:"
  echo "--------------------------------------------------"
  git -C ${RP["PROJECT"]} rev-list --ancestry-path $HADOUKEN_REPO_LAST_COMMIT_BEFORE_UPDATE..$HADOUKEN_REPO_LAST_COMMIT_AFTER_UPDATE --oneline --abbrev=1
  echo "--------------------------------------------------"
  # Execute post-upgrade fix-ups here
fi

echo "Phase 1 completed."
echo "--------------------------------------------------"

######################################
# Docker image update
######################################

echo "Phase 2: Initiating image update.."
# Check whether we're in docker or not
if hadouken.is_running_in_docker ; then
  echo "Docker image update skipped due the fact that --upgrade command is invoked in the container."
else
  echo "Pulling latest development environment docker image"
  if docker-compose -f ${RP["PROJECT"]}/.devcontainer/docker-compose.yml -f ${RP["PROJECT"]}/.hadouken.docker-compose.extend.yml pull ; then
    echo "Docker image is up-to-date."
  else
    echo "Docker image pull failed!"
  fi
fi
echo "Phase 2 completed."
echo "--------------------------------------------------"