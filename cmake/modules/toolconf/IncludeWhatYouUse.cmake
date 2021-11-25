#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for include-what-you-use tool integration.
#
# @file 	IncludeWhatYouUse.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include_guard(DIRECTORY)

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_IWYU "Use include-what-you-use in project" OFF)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_IWYU 
        IWYU
        DEFAULT_NAME iwyu
        NAMES include-what-you-use
        REQUIRED
    )

get_property(HADOUKEN_COMPILER GLOBAL PROPERTY HADOUKEN_COMPILER)
if(${CMAKE_VERSION} VERSION_LESS "3.3.0") 
    hdk_log_warn("Include what you use support requires at least version 3.3 of CMake.")
elseif (NOT ${HADOUKEN_COMPILER} STREQUAL "CLANG")
    hdk_log_warn("Include what you use currently only works with clang compiler.")
endif()

if(HDK_TOOL_IWYU)
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${HDK_TOOL_IWYU})

    include(CMakeDetermineCCompiler)
    include(CMakeDetermineCXXCompiler)
    
    if(${HADOUKEN_COMPILER} STREQUAL "GCC")
        list(APPEND CMAKE_CXX_INCLUDE_WHAT_YOU_USE 
            "--driver-mode=gcc" # add options here
        )
    else()
        list(APPEND CMAKE_CXX_INCLUDE_WHAT_YOU_USE 
            "--driver-mode=clang" # add options here
        )
    endif()
endif()