#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for enabling/disabling integrated link-what-you-use (uses ld/ldd).
#
# @file 	LinkWhatYouUse.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LWYU "Use lwyu in project" OFF)

hdk_log_set_context("lwyu")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LWYU)
    
    # LinkWhatYouUse requires at least 3.7.0 version of CMake.
    if(${CMAKE_VERSION} VERSION_LESS "3.7.0") 
        message(WARNING "Include what you use support requires at least version 3.7 of CMake.")
    else()
        hdk_log_status("Configuring tool `link-what-you-use`")
        # Enable link-what-you-use feature.
        SET(CMAKE_LINK_WHAT_YOU_USE ON)
        hdk_log_status("link-what-you-use` enabled")
    endif()
else()
    hdk_log_verbose("Skipping tool configuration for `link-what-you-use` (disabled)")
endif()


hdk_log_unset_context()

