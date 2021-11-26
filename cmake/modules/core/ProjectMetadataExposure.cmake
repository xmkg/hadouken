#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for exposing project metadata as C/C++ macro definitions.  
# 
# @file 	ProjectMetadataExposure.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	03.05.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include_guard(DIRECTORY)

#[=======================================================================[.rst:
    hdk_project_metadata_as_compile_defn
    ------------------- 
    Visibility level: Public (API)

    Export current project's metadata as C macros to specified target via
    `target_compile_definitions`. Exported metadata is as follows:
    PROJECT_NAME (as <prefix>PROJECT_NAME<suffix>)
    PROJECT_DESCRIPTION (as <prefix>PROJECT_DESC<suffix>)
    PROJECT_VERSION_MAJOR (as <prefix>PROJECT_VERSION_MAJOR<suffix>)
    PROJECT_VERSION_MINOR (as <prefix>PROJECT_VERSION_MINOR<suffix>)
    PROJECT_VERSION_PATCH (as <prefix>PROJECT_VERSION_PATCH<suffix>)
    PROJECT_VERSION_TWEAK (as <prefix>PROJECT_VERSION_TWEAK<suffix>)


    .. code-block:: cmake
        hdk_pass_project_metadata_as_cdef(
            TARGET_NAME <name> 
            TYPE <type> 
            PREFIX <prefix>
            SUFFIX <suffix>
        )

    Arguments:
        TARGET_NAME        <name>               `Name of the designated CMake target`
        TYPE               <type>               `Type of the designated CMake target`
        PREFIX             <prefix>             `Prefix to be appended to macro definition names (optional)`
        SUFFIX             <suffix>             `Suffix to be appended to macro definition names (optional)`
]]
#]=======================================================================]
function(hdk_project_metadata_as_compile_defn)
    hdk_log_set_context("hdk.pme")
    cmake_parse_arguments(ARGS "" "" "TARGET_NAME;TYPE;PREFIX;SUFFIX;" ${ARGN})

    if(NOT ARGS_TARGET_NAME)
        hdk_log_err("hdk_project_metadata_as_compile_defn(): function requires TARGET_NAME argument")
    endif()

    if(NOT ARGS_TYPE)
        hdk_log_err("hdk_project_metadata_as_compile_defn(): function requires TYPE argument")
    endif()

    if(ARGS_PREFIX)
        string(TOUPPER ${ARGS_PREFIX} ARGS_PREFIX)
        # Make it C preprocessor macro friendly
        string(REGEX REPLACE "[^a-zA-Z0-9]" "_" ARGS_PREFIX ${ARGS_PREFIX})
    endif()
    if(ARGS_SUFFIX)
        string(TOUPPER ${ARGS_SUFFIX} ARGS_SUFFIX)
        # Make it C preprocessor macro friendly
        string(REGEX REPLACE "[^a-zA-Z0-9]" "_" ARGS_SUFFIX ${ARGS_SUFFIX})
    endif()
    
    
    if(NOT ${ARGS_TYPE} STREQUAL "INTERFACE")
        set(CDEF_VISIBILITY PRIVATE)
    else()
        set(CDEF_VISIBILITY INTERFACE)
    endif()

    target_compile_definitions(${ARGS_TARGET_NAME} ${CDEF_VISIBILITY} ${ARGS_PREFIX}PROJECT_NAME${ARGS_SUFFIX}="${PROJECT_NAME}")
    target_compile_definitions(${ARGS_TARGET_NAME} ${CDEF_VISIBILITY} ${ARGS_PREFIX}PROJECT_DESC${ARGS_SUFFIX}="${PROJECT_DESCRIPTION}")
    target_compile_definitions(${ARGS_TARGET_NAME} ${CDEF_VISIBILITY} ${ARGS_PREFIX}PROJECT_VERSION_MAJOR${ARGS_SUFFIX}=${PROJECT_VERSION_MAJOR})
    target_compile_definitions(${ARGS_TARGET_NAME} ${CDEF_VISIBILITY} ${ARGS_PREFIX}PROJECT_VERSION_MINOR${ARGS_SUFFIX}=${PROJECT_VERSION_MINOR})
    target_compile_definitions(${ARGS_TARGET_NAME} ${CDEF_VISIBILITY} ${ARGS_PREFIX}PROJECT_VERSION_PATCH${ARGS_SUFFIX}=${PROJECT_VERSION_PATCH})
    target_compile_definitions(${ARGS_TARGET_NAME} ${CDEF_VISIBILITY} ${ARGS_PREFIX}PROJECT_VERSION_TWEAK${ARGS_SUFFIX}=${PROJECT_VERSION_TWEAK})

endfunction()
