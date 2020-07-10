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


function(project_metadata_exposure)
    cmake_parse_arguments(ARGS "" "" "TARGET_NAME;PREFIX;" ${ARGN})

    if(NOT ARGS_TARGET_NAME)
        message(FATAL_ERROR "project_metadata_exposure requires TARGET_NAME argument.")
    endif()

    string(TOUPPER ${ARGS_PREFIX} TARGET_NAME_UPPER)

    # Maket it C preprocessor macro friently
    string(REGEX REPLACE "[^a-zA-Z0-9]" "_" ARGS_PREFIX ${ARGS_PREFIX})

    target_compile_definitions(${ARGS_TARGET_NAME} PRIVATE ${ARGS_PREFIX}MODULE_NAME="${PROJECT_NAME}")
    target_compile_definitions(${ARGS_TARGET_NAME} PRIVATE ${ARGS_PREFIX}MODULE_DESC="${PROJECT_DESCRIPTION}")
    target_compile_definitions(${ARGS_TARGET_NAME} PRIVATE ${ARGS_PREFIX}MODULE_VERSION_MAJOR=${PROJECT_VERSION_MAJOR})
    target_compile_definitions(${ARGS_TARGET_NAME} PRIVATE ${ARGS_PREFIX}MODULE_VERSION_MINOR=${PROJECT_VERSION_MINOR})
    target_compile_definitions(${ARGS_TARGET_NAME} PRIVATE ${ARGS_PREFIX}MODULE_VERSION_PATCH=${PROJECT_VERSION_PATCH})
    target_compile_definitions(${ARGS_TARGET_NAME} PRIVATE ${ARGS_PREFIX}MODULE_VERSION_TWEAK=${PROJECT_VERSION_TWEAK})
endfunction()
