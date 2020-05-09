#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for finding ccache in environment if installed. 
# 
# @file 	CCache.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	12.03.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

option(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CCACHE "Use ccache in project" OFF)

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CCACHE)
    message(STATUS "[*] Configuring `ccache`")
    find_program(CCACHE_FOUND ccache)
    if(CCACHE_FOUND)
        message(STATUS "\t[+] Found `ccache`: ${CCACHE_FOUND}")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_FOUND})
        # set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache) # Less useful to do it for linking, see edit2
    else()
        message(FATAL_ERROR "\t[-] `ccache` not found in environment")
    endif(CCACHE_FOUND)
endif()