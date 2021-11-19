#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for runnin CppCheck static analysis on project.
# 
# @file 	CppCheck.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CPPCHECK "Use cppcheck in project" OFF)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CPPCHECK  
        CPPCHECK
        DEFAULT_NAME cppcheck
        REQUIRED
    )
hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CPPCHECK CPPCHECK "cppcheck" REQUIRED)
if(HDK_TOOL_CPPCHECK)
    set(CMAKE_CXX_CPPCHECK ${CPPCHECK})
    list(APPEND CMAKE_CXX_CPPCHECK 
        "--enable=warning"
        "--inconclusive"
        "--force" 
        "--inline-suppr"
        "--suppressions-list=${HDK_ROOT_PROJECT_SOURCE_DIR}/.cppcheck-suppress"
    )
endif()
