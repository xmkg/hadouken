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

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CPPCHECK)
    message(STATUS "[*] Configuring `cppcheck`")
    # Adding clang-format target if executable is found
    find_program(CPPCHECK "cppcheck")
    if(CPPCHECK)
        set(CMAKE_CXX_CPPCHECK ${CPPCHECK})
        list(APPEND CMAKE_CXX_CPPCHECK 
            "--enable=warning"
            "--inconclusive"
            "--force" 
            "--inline-suppr"
            "--suppressions-list=${CMAKE_SOURCE_DIR}/.cppcheck-suppress"
        )
        message(STATUS "\t[+] Found cppcheck: ${CPPCHECK}")
    else()
        message(FATAL_ERROR "\t[+] `cppcheck` not found in environment")
    endif()   
endif()
