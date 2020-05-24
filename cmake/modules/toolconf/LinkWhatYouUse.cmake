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

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LWYU)
    # LinkWhatYouUse requires at least 3.7.0 version of CMake.
    if(${CMAKE_VERSION} VERSION_LESS "3.7.0") 
        message(WARNING "Include what you use support requires at least version 3.7 of CMake.")
    else()
        message(STATUS "[*] Configuring `link-what-you-use`")
        # Enable link-what-you-use feature.
        SET(CMAKE_LINK_WHAT_YOU_USE ON)
        message(STATUS "\t`[+] link-what-you-use` enabled.")
    endif()
endif()

