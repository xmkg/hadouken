#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for generating documentation via Doxygen on project.
# 
# @file 	Doxygen.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	17.09.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

# (mgilor): We will inject the variables below on doxygen invocation.
# PROJECT_NAME           = "ACU Classifier"
# PROJECT_NUMBER         =
# PROJECT_BRIEF          =
# PROJECT_LOGO           =
# OUTPUT_DIRECTORY       =

include_guard(DIRECTORY)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_DOXYGEN "Use doxygen in project" OFF)

hdk_log_set_context("doxygen")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_DOXYGEN)
    hdk_log_status("Configuring tool `doxygen`")

    find_package(Doxygen QUIET)
    if(DOXYGEN_FOUND)
        hdk_log_debug("Found `doxygen` executable: ${DOXYGEN_EXECUTABLE}`")

        list(APPEND INJECTED_PARAMETERS "echo PROJECT_NAME=${HDK_ROOT_PROJECT_NAME}")
        list(APPEND INJECTED_PARAMETERS "echo PROJECT_NUMBER=${HDK_ROOT_PROJECT_VERSION}")
        list(APPEND INJECTED_PARAMETERS "echo PROJECT_BRIEF=${HDK_ROOT_PROJECT_DESCRIPTION}")
        list(APPEND INJECTED_PARAMETERS "echo OUTPUT_DIRECTORY=${HDK_ROOT_PROJECT_BINARY_DIR}/docs")
        list(APPEND INJECTED_PARAMETERS "echo WARN_LOGFILE=${HDK_ROOT_PROJECT_BINARY_DIR}/doxygen.warn.log")
        # list(APPEND INJECTED_PARAMETERS "echo WARN_AS_ERROR=YES")

        list(JOIN INJECTED_PARAMETERS " ; " INJECTED_PARAMETERS_STRINGIZED)


        if (NOT TARGET ${HDK_ROOT_PROJECT_NAME}.documentation)
            hdk_log_debug("Auto-created `${HDK_ROOT_PROJECT_NAME}.documentation` target")
            add_custom_target(${HDK_ROOT_PROJECT_NAME}.documentation
                WORKING_DIRECTORY ${HDK_ROOT_PROJECT_SOURCE_DIR}
                COMMAND bash -c "( cat .doxyfile ; ${INJECTED_PARAMETERS_STRINGIZED} ) | doxygen - "
                COMMENT "Generating API documentation for ${HDK_ROOT_PROJECT_NAME} with Doxygen"
                VERBATIM
            )
        endif()

    else()
        hdk_log_err("`doxygen` not found in environment")
    endif() 
else()
    hdk_log_verbose("Skipping tool configuration for `doxygen` (disabled)")
endif()

hdk_log_unset_context()
