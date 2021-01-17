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

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LCOV "Use lcov in project" OFF)

hdk_log_set_context("lcov")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LCOV)
    hdk_log_status("Configuring tool `lcov`")

    find_program(LCOV NAMES lcov lcov.bat lcov.exe lcov.perl)
    if(LCOV)
        hdk_log_status("Found `lcov` executable: ${LCOV}`")
    else()
        hdk_log_err("`lcov` not found in environment")
    endif()
else()
    hdk_log_verbose("Skipping tool configuration for `lcov` (disabled)")
endif()

hdk_log_unset_context()