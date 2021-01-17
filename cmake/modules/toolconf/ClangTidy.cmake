#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for finding clang-tidy in environment if installed. 
# The module creates targets named clang-tidy if relevant programs 
# are installed.
# 
# @file 	ClangTidy.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_TIDY "Use clang-tidy in project" OFF)

hdk_log_set_context("clang-tidy")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_TIDY)
    hdk_log_status("Configuring tool `clang-tidy`")

    # Adding clang-format target if executable is found
    find_program(CLANG_TIDY NAMES "clang-tidy" "clang-tidy-10" "clang-tidy-9" "clang-tidy-8" "clang-tidy-7" "clang-tidy-6" "clang-tidy-5" "clang-tidy-4" "clang-tidy-3")
    if(CLANG_TIDY)
        hdk_log_status("Found `clang-tidy` executable: ${CLANG_TIDY}`")
        #set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY}")
        set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY}")
    else()
        hdk_log_err("`clang-tidy` not found in environment")
    endif()
else()
    hdk_log_verbose("Skipping tool configuration for `clang-tidy` (disabled)")
endif()

hdk_log_unset_context()