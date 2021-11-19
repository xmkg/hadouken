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

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_FORMAT "Use clang-format in project" OFF)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_FORMAT  
        CLANG_FORMAT
        DEFAULT_NAME clang-format
        NAMES clang-format-13 clang-format-12 clang-format-11 clang-format-10 clang-format-9 clang-format-8 clang-format-7 clang-format-6 clang-format-5 clang-format-4 clang-format-3
        REQUIRED
    )