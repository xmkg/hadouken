#!/usr/bin/env cmake

# ______________________________________________________
# Common utilities for hadouken.
# 
# @file 	Utility.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	10.04.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

function(hdk_list_transform_prepend INPUT_LIST OUTPUT_VARIABLE PREFIX)
    set(temp "")
    foreach(f ${${INPUT_LIST}})
        list(APPEND temp "${PREFIX}${f}")
    endforeach()
    set(${OUTPUT_VARIABLE} "${temp}" PARENT_SCOPE)
endfunction()

# capitalize and sanitize name
function(hdk_capsan_name NAME OUTPUT_VARIABLE)
    string(TOUPPER ${NAME} TEMP)
    string(REGEX REPLACE "[^a-zA-Z0-9]" "_" TEMP ${TEMP})
    set(${OUTPUT_VARIABLE} "${TEMP}" PARENT_SCOPE)
endfunction()

macro(hdk_function_required_arguments)
    cmake_parse_arguments(FRA "" "" "" ${ARGN})
    foreach(argname IN LISTS FRA_UNPARSED_ARGUMENTS)
        if(NOT ${argname})
            hdk_fnlog_err("argument ${argname} is required")
        endif()
    endforeach()
endmacro()

macro(hdk_parameter_default_value ARGUMENT_NAME DEFAULT_VALIE)
    if(NOT DEFINED ${ARGUMENT_NAME})
        set(${ARGUMENT_NAME} ${DEFAULT_VALUE})
    endif()
endmacro()


macro(hdk_unset_if_empty)
    cmake_parse_arguments(FRA "" "" "" ${ARGN})
    foreach(argname IN LISTS FRA_UNPARSED_ARGUMENTS)
        if("${${argname}}" STREQUAL "")
            unset(${argname})
        endif()
    endforeach()
endmacro()
