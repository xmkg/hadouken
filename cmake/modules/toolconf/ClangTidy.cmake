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

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_TIDY "Use clang-tidy in project" OFF)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_TIDY  
        CLANG_TIDY
        DEFAULT_NAME clang-tidy
        NAMES clang-tidy-14 clang-tidy-13 clang-tidy-12 clang-tidy-11 clang-tidy-10 clang-tidy-9 clang-tidy-8 clang-tidy-7 clang-tidy-6 clang-tidy-5 clang-tidy-4 clang-tidy-3 
        REQUIRED
    )

if(HDK_TOOL_CLANG_TIDY)
    set(CMAKE_CXX_CLANG_TIDY "${HDK_TOOL_CLANG_TIDY}")
endif()