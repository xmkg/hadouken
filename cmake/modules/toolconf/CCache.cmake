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

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CCACHE "Use ccache in project" OFF)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CCACHE 
        CCACHE
        DEFAULT_NAME ccache
        REQUIRED
    )
if(HDK_TOOL_CCACHE)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_FOUND})
    # set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache) # Less useful to do it for linking, see edit2
endif()