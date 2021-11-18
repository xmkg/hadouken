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

# TODO (aaksoy): find_package implementation will be added.
# TODO (aaksoy): Forwarding arguments into cmake_language function calls.

function(hdk_find variable_name)
    set(oneValueArgs TYPE CONFIG_NAME DEFAULT_NAME)
    set(multiValueArgs NAMES)
    set(options REQUIRED)
    cmake_parse_arguments(ARGUMENTS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    if(NOT DEFINED ARGUMENTS_CONFIG_NAME)
        set(ARGUMENTS_CONFIG_NAME ${variable_name})
    endif()
    if(NOT DEFINED ARGUMENTS_DEFAULT_NAME)
        hdk_log_err("You must specify default name! Aborting...")
    endif()
    if(NOT DEFINED ARGUMENTS_TYPE)
        hdk_log_err("TYPE argument must be specified! Aborting...")
    endif()
    set(function_name "find_program")
    if(ARGUMENTS_TYPE STREQUAL "PROGRAM")
        set(function_name "find_program")
    elseif(ARGUMENTS_TYPE STREQUAL "PACKAGE")
        # set(function_name "find_package")
    endif()

    hdk_log_set_context("${ARGUMENTS_DEFAULT_NAME}")
    hdk_log_status("Configuring tool `${ARGUMENTS_DEFAULT_NAME}`")

    if(DEFINED ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${ARGUMENTS_CONFIG_NAME}_NAMES)
        if(DEFINED ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${ARGUMENTS_CONFIG_NAME}_PATHS)
            cmake_language(CALL ${function_name} HDK_TOOL_${variable_name} NAMES ${${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${ARGUMENTS_CONFIG_NAME}_NAMES} PATHS ${${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${ARGUMENTS_CONFIG_NAME}_PATHS})
        else()
            cmake_language(CALL ${function_name} HDK_TOOL_${variable_name} NAMES ${${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${ARGUMENTS_CONFIG_NAME}_NAMES})
        endif()
    else()
        if(DEFINED ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${variable_name}_PATHS)
            cmake_language(CALL ${function_name} HDK_TOOL_${variable_name} NAMES ${ARGUMENTS_DEFAULT_NAME} ${ARGUMENTS_NAMES} PATHS ${${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_${ARGUMENTS_CONFIG_NAME}_PATHS})
        else()
            cmake_language(CALL ${function_name} HDK_TOOL_${variable_name} NAMES ${ARGUMENTS_DEFAULT_NAME} ${ARGUMENTS_NAMES})
        endif()
    endif()
    if(HDK_TOOL_${variable_name})
        hdk_log_status("Found `${ARGUMENTS_DEFAULT_NAME}` executable: ${HDK_TOOL_${variable_name}}`")
    else()
        hdk_log_err("`${ARGUMENTS_DEFAULT_NAME}` not found in environment")
    endif()
    hdk_log_unset_context()
endfunction()

macro(hdk_find_if flag)
    set(oneValueArgs TYPE CONFIG_NAME DEFAULT_NAME)
    set(multiValueArgs PATHS NAMES)
    set(options REQUIRED)
    cmake_parse_arguments(ARGUMENTS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(${flag})
        hdk_find(${ARGN})
    else()
        hdk_log_verbose("Skipping tool configuration for `${ARGUMENTS_DEFAULT_NAME}` (disabled)")
    endif()
endmacro()

macro(hdk_find_program)
    hdk_find(${ARGN} TYPE PROGRAM)
endmacro()

# function(hdk_find_package package_name default_name)
#     hdk_find()
# endfunction()

macro(hdk_find_program_if flag)
    set(oneValueArgs TYPE CONFIG_NAME DEFAULT_NAME)
    set(multiValueArgs PATHS NAMES)
    set(options REQUIRED)
    cmake_parse_arguments(ARGUMENTS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(${flag})
        hdk_find_program(${ARGN})
    else()
        hdk_log_verbose("Skipping tool configuration for `${ARGUMENTS_DEFAULT_NAME}` (disabled)")
    endif()
endmacro()