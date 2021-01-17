#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for running gcov code coverage analysis.
# 
# @file 	GCov.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	13.03.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV "Use gcov in project" OFF)

hdk_log_set_context("gcov")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV)
    hdk_log_status("Configuring tool `gcov`")

    find_program(GCOV "gcov")
    if(GCOV)
        hdk_log_status("Found `gcov` executable: ${GCOV}`")
    else()
        hdk_log_err("`gcov` not found in environment")
    endif()   
else()
    hdk_log_verbose("Skipping tool configuration for `gcov` (disabled)")
endif()

hdk_log_unset_context()
