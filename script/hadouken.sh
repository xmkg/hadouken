#!/usr/bin/env bash

# ______________________________________________________
# Hadouken main script
#
# @file 	hadouken.sh
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
source $SCRIPT_ROOT/common.sh && hadouken.define_relative_paths $SCRIPT_ROOT RP

readonly CURRENT_HADOUKEN_VERSION=$(git -C ${RP["BOILERPLATE"]} tag --points-at)

case $1 in
    -nb|--no-banner)
      shift
    ;;
    *)
      echo -e "################################################################################"
      echo -e "                     _===__                                  "    
      echo -e "                   //-==;=_~                                 "  
      echo -e "                  ||('   ~)      ___      __ __ __------_    "    
      echo -e "             __----\|    _-_____////     --__---         -_  "    
      echo -e "            / _----_---_==__   |_|     __=-                \ "    
      echo -e "           / |  _______     ----_    -=__                  | "    
      echo -e "           |  \_/      -----___| |       =-_              _/ "    
      echo -e "           |           \ \     \\\\      __ ---__       _ -  "    
      echo -e "           |            \ /     ^^^         ---  -------     "    
      echo -e "            \_         _|-                                   "
      echo -e "             \_________/                                     "
      echo -e "           _/   -----  -_.                                   "
      echo -e "          /_/|  || ||   _/--__                               "
      echo -e "          /  |_      _-       --_                            "
      echo -e "         /     ------            |                           "
      echo -e "        /      __------____/     |                           "
      echo -e "       |      /           /     /                            "
      echo -e "     /      /            |     |                             "
      echo -e "    (     /              |____|                              "
      echo -e "    /\__/                 |  |                               "
      echo -e "   (  /                  |  /-__                             "
      echo -e "   \  |                  (______)                            "
      echo -e "    \\\)                                                     "
      echo -e "################################################################################"
      echo -e "# hadouken - c++ project development environment            version ${CURRENT_HADOUKEN_VERSION} "  
      echo -e ""
    ;;
esac


# Bash completion function for hadouken
__hadouken_bash_completions()
{
  local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--build --clean --configure --install --pack --upgrade --all"

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F __hadouken_bash_completions hadouken
complete -F __hadouken_bash_completions hadouken.sh
complete -F __hadouken_bash_completions ./hadouken

if [ "$#" -lt 1 ]; then
    echo "[¬º-°]¬ Hadouken requires (at least) an argument."
    exit 1
fi

case $1 in
    -b|--build)
      ${RP["SCRIPT"]}/project-build.sh ${@:2}
    ;;
    -x|--clean)
      ${RP["SCRIPT"]}/project-clean.sh ${@:2}
    ;;
    -c|--configure)
      ${RP["SCRIPT"]}/project-configure.sh ${@:2}
    ;;
    -i|--install)
      ${RP["SCRIPT"]}/project-install.sh ${@:2}
    ;;
    -p|--pack)
      ${RP["SCRIPT"]}/project-pack.sh ${@:2}
    ;;
    -t|--test)
      ${RP["SCRIPT"]}/project-test.sh ${@:2}
    ;;
    -cv|--coverage)
      ${RP["SCRIPT"]}/project-coverage.sh ${@:2}
    ;;
    -d|--documentation)
      ${RP["SCRIPT"]}/project-generate-documentation.sh ${@:2}
    ;;
    -f|--format)
      ${RP["SCRIPT"]}/project-format.sh ${@:2}
    ;;
    -ti|--tidy)
      ${RP["SCRIPT"]}/project-tidy.sh ${@:2}
    ;;
    -u|--upgrade)
      ${RP["SCRIPT"]}/update-hadouken.sh ${@:2}
    ;;
    -a|--all)
      ${RP["SCRIPT"]}/project-clean.sh 
      ${RP["SCRIPT"]}/project-configure.sh ${@:2}
      ${RP["SCRIPT"]}/project-build.sh ${@:2}
      ${RP["SCRIPT"]}/project-test.sh ${@:2}
    ;;
    *)
      echo "¯\_(ツ)_/¯ ... i can't hadouken with that. "
      echo -e ""
      echo "Use one of the following combos:"
      echo -e "Project:"
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-b|--build\tbuild project"
      echo -e "\t\t| build previously configured project. Any extra arguments will be forwarded to CMake."
      echo -e "\t\t| example: \`hadouken --build\`\t\t# build via CMake."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-x|--clean\tclean project"
      echo -e "\t\t| remove PROJECT_ROOT/build directory."
      echo -e "\t\t| example: \`hadouken --clean\`\t\t# removes PROJECT_ROOT/build directory."
      echo -e "\t\t| example: \`hadouken --clean --deep\`\t# runs git clean -fxd on project root."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-c|--configure"
      echo -e "\t\t| configure project located in PROJECT_ROOT to PROJECT_ROOT/build directory with cmake"
      echo -e "\t\t| any following arguments will be forwarded to CMake."
      echo -e "\t\t| example: \`hadouken --configure --target=Debug\`"
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-i|--install\tinstall project"
      echo -e "\t\t| install previosuly built project. Any extra arguments will be forwarded to CMake."
      echo -e "\t\t| example: \`hadouken --install\`\t\t# install via CMake."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-p|--pack\tpack project (using cpack)"
      echo -e "\t\t| package previously build project. Any extra arguments will be forwarded to CMake."
      echo -e "\t\t| example: \`hadouken --pack\`\t\t# pack via CMake."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-t|--test\trun unit tests for project (using ctest)"
      echo -e "\t\t| run unit tests of previously build project. Any extra arguments will be forwarded to CTest."
      echo -e "\t\t| example: \`hadouken --test\`\t\t# test via CTest."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-cv|--coverage\trun code coverage for project"
      echo -e "\t\t| run code coverage targets of previously build project."
      echo -e "\t\t| example: \`hadouken --coverage --html\`\t\t# run all code coverage targets, generate HTML reports"
      echo -e "\t\t| example: \`hadouken --coverage --xml\`\t# run all code coverage targets, generate XML reports in cobertura format."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-f|--format\trun all clang-format targets for the project."
      echo -e "\t\t| run all format targets defined for the project. Any extra arguments will be forwarded to CMake."
      echo -e "\t\t| example: \`hadouken --format\`\t\t# call project.format target via CMake."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-ti|--tidy\trun all clang-tidy targets for the project."
      echo -e "\t\t| run all tidy targets defined for the project. Any extra arguments will be forwarded to CMake."
      echo -e "\t\t| example: \`hadouken --tidy\`\t\t# call project.tidy target via CMake."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-a|--all\tclean->configure->build->pack project"
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "Hadouken:"
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      echo -e "\t-u|--upgrade\tupgrade hadouken to latest release"
      echo -e "\t\t| this basically runs submodule update, reduced to a command for ease of use."
      echo -e "\t\t| example: \`hadouken --upgrade\`\t\t# upgrade hadouken to latest master release."
      echo -e "\t- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
      exit 1
    ;;
esac








