#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for finding clang-format in environment if installed. 
# The module creates targets named clang-format if relevant programs 
# are installed.
# 
# @file 	ClangFormat.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________


option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_FORMAT "Use clang-format in project" OFF)

hdk_log_set_context("clang-format")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_FORMAT)
    hdk_log_status("Configuring tool `clang-format`")

    # Adding clang-format target if executable is found
    find_program(CLANG_FORMAT NAMES "clang-format" "clang-format-10" "clang-format-9" "clang-format-8" "clang-format-7" "clang-format-6" "clang-format-5" "clang-format-4" "clang-format-3")
    if(CLANG_FORMAT)
        hdk_log_status("Found `clang-format` executable: ${CLANG_FORMAT}`")
    else()
        hdk_log_err("`clang-format` not found in environment")
    endif()

else()
    hdk_log_verbose("Skipping tool configuration for `clang-format` (disabled)")
endif()

hdk_log_unset_context()
