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

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_DOXYGEN)
    message(STATUS "[*] Configuring `Doxygen`")
    find_package(Doxygen QUIET)
    if(DOXYGEN_FOUND)
        message(STATUS "\t[+] Found doxygen: ${DOXYGEN_EXECUTABLE}")

        list(APPEND INJECTED_PARAMETERS "echo PROJECT_NAME=${PB_PARENT_PROJECT_NAME}")
        list(APPEND INJECTED_PARAMETERS "echo PROJECT_NUMBER=${PB_PARENT_PROJECT_VERSION}")
        list(APPEND INJECTED_PARAMETERS "echo PROJECT_BRIEF=${PB_PARENT_PROJECT_DESCRIPTION}")
        list(APPEND INJECTED_PARAMETERS "echo OUTPUT_DIRECTORY=${PB_PARENT_PROJECT_BINARY_DIR}/docs")
        list(APPEND INJECTED_PARAMETERS "echo WARN_LOGFILE=${PB_PARENT_PROJECT_BINARY_DIR}/doxygen.warn.log")
        # list(APPEND INJECTED_PARAMETERS "echo WARN_AS_ERROR=YES")

        list(JOIN INJECTED_PARAMETERS " ; " INJECTED_PARAMETERS_STRINGIZED)


        if (NOT TARGET ${PB_PARENT_PROJECT_NAME}.documentation)
            message(STATUS "\t[>] Auto-created `${PB_PARENT_PROJECT_NAME}.documentation` target")
            add_custom_target(${PB_PARENT_PROJECT_NAME}.documentation
                WORKING_DIRECTORY ${PB_PARENT_PROJECT_SOURCE_DIR}
                COMMAND bash -c "( cat .doxyfile ; ${INJECTED_PARAMETERS_STRINGIZED} ) | doxygen - "
                COMMENT "Generating API documentation for ${PB_PARENT_PROJECT_NAME} with Doxygen"
                VERBATIM
            )
        endif()

    else()
        message(FATAL_ERROR "\t[+] `doxygen` not found in environment")
    endif()   
endif()
