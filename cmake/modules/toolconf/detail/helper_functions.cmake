#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for running gcov code coverage analysis.
# 
# @file 	helper_functions.cmake
# @author   Ahmet İbrahim AKSOY <aaksoy@nettsi.com>
# @date 	17.11.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

function(hdk_find_program program_name default_name)
    if(DEFINED ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${program_name}_NAMES)
        if(DEFINED ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${program_name}_PATHS)
            find_program(${program_name} ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${program_name}_NAMES PATHS ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${program_name}_PATHS)
        else()
            find_program(${program_name} ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${program_name}_NAMES)
        endif()
    else()
        if(DEFINED ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${program_name}_PATHS)
            find_program(${program_name} ${default_name} PATHS ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${program_name}_PATHS)
        else()
            find_program(${program_name} ${default_name})
        endif()
    endif()
endfunction()