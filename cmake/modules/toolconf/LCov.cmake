#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for running lcov code coverage analysis.
# 
# @file 	LCov.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	13.03.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

option(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LCOV "Use lcov in project" OFF)

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LCOV)
    message(STATUS "[*] Configuring `lcov`")

    find_program(LCOV NAMES lcov lcov.bat lcov.exe lcov.perl)
    if(LCOV)
        message(STATUS "\t[+] Found lcov: ${LCOV}")
    else()
        message(FATAL_ERROR "\t[-] `lcov` not found in environment")
    endif()   
endif()