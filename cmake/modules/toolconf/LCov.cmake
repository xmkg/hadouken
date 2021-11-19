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

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LCOV "Use lcov in project" OFF)
set(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_GENHTML_NAMES genhtml genhtml.perl genhtml.bat)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LCOV 
        LCOV
        DEFAULT_NAME lcov
        REQUIRED
    )
hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LCOV 
    GENHTML
    DEFAULT_NAME genhtml
    CONFIG_NAME GENHTML
    NAMES genhtml.perl genhtml.bat
    REQUIRED
)
