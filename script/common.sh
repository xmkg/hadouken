#!/usr/bin/env bash

# ______________________________________________________
# Hadouken common functions
#
# @file 	common.sh
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________


# Declare an associative array which contains some common paths
hadouken.define_relative_paths(){
    if [[ -z "$1" ]]; then
        echo "hadokuen.define_relative_paths() requires a base path parameter."
        exit 1
    fi
    declare -A HADOUKEN_RELATIVE_PATHS
    HADOUKEN_RELATIVE_PATHS["SCRIPT"]=$1
    HADOUKEN_RELATIVE_PATHS["BOILERPLATE"]=$(realpath ${HADOUKEN_RELATIVE_PATHS["SCRIPT"]}/..)
    HADOUKEN_RELATIVE_PATHS["PROJECT"]=$(realpath ${HADOUKEN_RELATIVE_PATHS["BOILERPLATE"]}/..)
    HADOUKEN_RELATIVE_PATHS["BUILD"]=$(realpath ${HADOUKEN_RELATIVE_PATHS["PROJECT"]}/build)
    HADOUKEN_RELATIVE_PATHS["PACK"]=$(realpath ${HADOUKEN_RELATIVE_PATHS["BUILD"]}/pak)

    for key in "${!HADOUKEN_RELATIVE_PATHS[@]}"  # make sure you include the quotes there
    do
        eval ${2}["$key"]="${HADOUKEN_RELATIVE_PATHS["$key"]}"
    done
}

# Retrieve top level project name from
hadouken.get_top_level_project_name(){
    if [[ -z "$1" ]]; then
        echo "hadokuen.get_top_level_project_name() requires a base path parameter."
        exit 1
    fi
    
    declare -A LRP
    # Common headers
    hadouken.define_relative_paths $1 LRP

    if test -f "${LRP["BUILD"]}/CMakeCache.txt"; then
        hadouken_top_level_project_name=$(grep CMAKE_PROJECT_NAME ${LRP["BUILD"]}/CMakeCache.txt | cut -d'=' -f2)
    else
        return 1
    fi    
}

# Returns 0 when running in docker
hadouken.is_running_in_docker(){
    if grep docker /proc/1/cgroup -qa; then
        return 0
    fi
    return 1
}

hadouken.compare_versions(){
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

# Prints the cmake version.
hadouken.get_cmake_version(){
    OUTPUT="$(cmake --version)"
    version_v=(${OUTPUT// / })
    echo ${version_v[2]}
}

# Checks whether specified directory contains a 
# CMakeLists.txt file.  
hadouken.has_cmakelist(){
    if test -e "$1/CMakeLists.txt"; then
        return 0
    fi
    return 1
}

# Checks whether specified directory contains a 
# conanfile.txt file.
hadouken.has_conanfile(){     
    if test -e "$1/conanfile.txt"; then
        return 0
    fi
    return 1
}


# Bootstrap a cmake project to specified folder.
hadouken.bootstrap_cmake_project(){
    TARGET_FOLDER=$1
    CREATE_YEAR=$(date +"%Y")
    CREATE_DATE=$(date +"%d.%m.%Y")

    echo -e "Project name:"
    read PROJECT_NAME

    # Replace non-alphanumeric characters with an underscore
    PROJECT_NAME_SANITIZED="${PROJECT_NAME//[^[:alnum:]]/_}"
    # Convert to uppercase
    PROJECT_NAME_SANITIZED=""${PROJECT_NAME_SANITIZED^^}
    GIT_CFG_USER_NAME=$(git -C $TARGET_FOLDER config user.name)
    GIT_CFG_USER_EMAIL=$(git -C $TARGET_FOLDER config user.email)

    if [ ! -d "$TARGET_FOLDER" ]; then
        echo -e "Target folder $TARGET_FOLDER does not exist."
        exit 1
    fi

    if hadouken.has_cmakelist $TARGET_FOLDER ; then
        echo -e "Target folder $TARGET_FOLDER already has a CMakeLists.txt!"
        exit 1
    fi

    echo "$GIT_CFG_USER_NAME $GIT_CFG_USER_EMAIL"
    if [ -z "$GIT_CFG_USER_NAME" ] || [ -z "$GIT_CFG_USER_EMAIL" ]; then
        echo -e "Set git user name and e-mail before quick-starting a project."
        exit 1
    fi

    # Project top level CMakeLists.txt
    cat > $TARGET_FOLDER/CMakeLists.txt << EOF
# ______________________________________________________
# $PROJECT_NAME project top level CMakeLists.txt file
#
# @file        CMakeLists.txt
# @author      $GIT_CFG_USER_NAME <$GIT_CFG_USER_EMAIL>
# @date        $CREATE_DATE
#
# @copyright   $CREATE_YEAR NETTSI Informatics Technology Inc.
#
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

cmake_minimum_required(VERSION 3.00)

project($PROJECT_NAME VERSION 0.0.1 LANGUAGES CXX)

# Turn on any desired tool/feature below.
SET(${PROJECT_NAME_SANITIZED}_MISC_NO_HADOUKEN_BANNER        FALSE CACHE BOOL "Enable/disable hadouken banner printing" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_IWYU              FALSE CACHE BOOL "Enable/disable include what you use integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_GOOGLE_TEST       FALSE CACHE BOOL "Enable/disable gtest/gmock integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_GOOGLE_BENCH      FALSE CACHE BOOL "Enable/disable google benchmark integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_CLANG_FORMAT      FALSE CACHE BOOL "Enable/disable clang-format integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_CLANG_TIDY        FALSE CACHE BOOL "Enable/disable clang-tidy integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_CPPCHECK          FALSE CACHE BOOL "Enable/disable cppcheck integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_CCACHE            FALSE CACHE BOOL "Enable/disable ccache integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_GCOV              FALSE CACHE BOOL "Enable/disable gcov integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_LCOV              FALSE CACHE BOOL "Enable/disable lcov integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_GCOVR             FALSE CACHE BOOL "Enable/disable gcovr integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_TOOLCONF_USE_DOXYGEN           FALSE CACHE BOOL "Enable/disable doxygen integration" FORCE)
SET(${PROJECT_NAME_SANITIZED}_DISABLE_UNIT_TEST_TARGETS      FALSE CACHE BOOL "Enable/disable project-wide unit test target creation" FORCE)
SET(${PROJECT_NAME_SANITIZED}_DISABLE_BENCHMARK_TARGETS      FALSE CACHE BOOL "Enable/disable project-wide benchmark target creation" FORCE)
SET(${PROJECT_NAME_SANITIZED}_DISABLE_STATIC_TARGETS         FALSE CACHE BOOL "Enable/disable project-wide static library target creation" FORCE)
SET(${PROJECT_NAME_SANITIZED}_DISABLE_SHARED_TARGETS         FALSE CACHE BOOL "Enable/disable project-wide benchmark target creation" FORCE)
SET(${PROJECT_NAME_SANITIZED}_DISABLE_EXECUTABLE_TARGETS     FALSE CACHE BOOL "Enable/disable project-wide executable target creation" FORCE)
SET(${PROJECT_NAME_SANITIZED}_DISABLE_INTERFACE_TARGETS      FALSE CACHE BOOL "Enable/disable project-wide interface target creation" FORCE)

# Include hadouken
include(.hadouken/hadouken.cmake)

# Print VCS status to stdout
git_print_status()

# Components of the project
add_subdirectory(app)

EOF
    # Prompt for project name
    mkdir $TARGET_FOLDER/app
    mkdir $TARGET_FOLDER/app/include
    mkdir $TARGET_FOLDER/app/src

    cat > $TARGET_FOLDER/app/CMakeLists.txt << EOF
# ______________________________________________________
# Example application project CMakeLists file
#
# @file        CMakeLists.txt
# @author      $GIT_CFG_USER_NAME <$GIT_CFG_USER_EMAIL>
# @date        $CREATE_DATE
#
# @copyright   $CREATE_YEAR NETTSI Informatics Technology Inc.
#
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

project($PROJECT_NAME.app)

# Create an executagble target
make_target(TYPE EXECUTABLE)
EOF

    cat > $TARGET_FOLDER/app/src/main.cpp << EOF
/**
 * ______________________________________________________
 * Example application.
 *
 * @file         main.cpp
 * @author       $GIT_CFG_USER_NAME <$GIT_CFG_USER_EMAIL>
 * @date         $CREATE_DATE
 *
 * @copyright    $CREATE_YEAR NETTSI Informatics Technology Inc.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ______________________________________________________
 */

#include <iostream>

/**
 * @brief Main entry point of the application
 *
 * @return int exit code
 */
auto main() -> int{
    std::cout << "Hello, world!" << std::endl;
    return 0;
}
EOF

}

