#!/usr/bin/env cmake

# ______________________________________________________
# Contains helper functions to gather header and source files from projects
# containing source files in `include/src` format.
# 
# @file 	MakeCompilationUnit.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

# Gather all files under `include` and `src` folders at current directory level 
# to `COMPILATION_UNIT` variable in invocation scope.
function(hdk_make_compilation_unit COMPILATION_UNIT)
    hdk_log_set_context("mcu")
    cmake_parse_arguments(ARGS,  "" "EXCLUDE_SOURCES;EXCLUDE_HEADERS;" "" ${ARGN})

    file(GLOB_RECURSE HEADERS "include/*")
    file(GLOB_RECURSE SOURCES "src/*")
    
    if(ARGS_EXCLUDE_SOURCES)
        list(FILTER SOURCES EXCLUDE REGEX "${ARGS_EXCLUDE_SOURCES}")
    endif()

    if(ARGS_EXCLUDE_HEADERS)
        list(FILTER HEADERS EXCLUDE REGEX "${ARGS_EXCLUDE_HEADERS}")
    endif()

    set(HEADERS ${HEADERS} PARENT_SCOPE)
    set(SOURCES ${SOURCES} PARENT_SCOPE)

    set(${COMPILATION_UNIT} ${HEADERS} ${SOURCES} PARENT_SCOPE)
endfunction()

