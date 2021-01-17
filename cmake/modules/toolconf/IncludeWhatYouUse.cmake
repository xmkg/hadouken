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


option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_IWYU "Use include-what-you-use in project" OFF)

hdk_log_set_context("iwyu")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_IWYU)
    hdk_log_status("Configuring tool `cppcheck`")
    get_property(HADOUKEN_COMPILER GLOBAL PROPERTY HADOUKEN_COMPILER)
    if(${CMAKE_VERSION} VERSION_LESS "3.3.0") 
        hdk_log_warn("Include what you use support requires at least version 3.3 of CMake.")
    elseif (NOT ${HADOUKEN_COMPILER} STREQUAL "CLANG")
        hdk_log_warn("Include what you use currently only works with clang compiler.")
    else()
        hdk_log_status("Configuring tool `include-what-you-use`")

        find_program(iwyu_path NAMES include-what-you-use iwyu)
        if(iwyu_path)
            set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${iwyu_path})

            include(CMakeDetermineCCompiler)
            include(CMakeDetermineCXXCompiler)
            
            if(CMAKE_CXX_COMPILER_ID MATCHES "[gG][nN][uU]")
                list(APPEND CMAKE_CXX_INCLUDE_WHAT_YOU_USE 
                    "--driver-mode=gcc" # add options here
                )
            else()
                list(APPEND CMAKE_CXX_INCLUDE_WHAT_YOU_USE 
                    "--driver-mode=clang" # add options here
                )
            endif()

            # TODO: Check if clang version required for installed iwyu exist on the system
            # (so fucking needy)

            # ${CMAKE_CXX_COMPILER_VERSION} -> current kit
            # need to get version from other kits..
            hdk_log_status("Found `include-what-you-use` executable: ${iwyu_path}`")
        else()
            hdk_log_err("`include-what-you-use` not found in environment")
        endif()
    endif()
else()
    hdk_log_verbose("Skipping tool configuration for `include-what-you-use` (disabled)")
endif()

hdk_log_unset_context()




