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

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOVR "Use gcovr in project" OFF)

hdk_log_set_context("gcovr")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOVR)
    hdk_log_status("Configuring tool `gcovr`")

    find_program(GCOVR "gcovr")
    if(GCOVR)
        hdk_log_status("Found `gcovr` executable: ${GCOVR}`")
    else()
        hdk_log_err("`gcovr` not found in environment")
    endif() 
else()
    hdk_log_verbose("Skipping tool configuration for `gcovr` (disabled)")
endif()

hdk_log_unset_context()