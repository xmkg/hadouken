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

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CCACHE "Use ccache in project" OFF)

hdk_log_set_context("ccache")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CCACHE)
    hdk_log_status("Configuring tool `ccache`")

    find_program(CCACHE_FOUND ccache)
    if(CCACHE_FOUND)
        hdk_log_status("Found `ccache` executable: ${CCACHE_FOUND}")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_FOUND})
        # set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache) # Less useful to do it for linking, see edit2
    else()
        hdk_log_err("`ccache` not found in environment")
    endif(CCACHE_FOUND)

else()
    hdk_log_verbose("Skipping tool configuration for `ccache` (disabled)")
endif()

hdk_log_unset_context()