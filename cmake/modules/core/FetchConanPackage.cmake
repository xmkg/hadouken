#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for locating and fetching conan packages
# 
# @file 	FetchConanPackage.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	15.10.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

function(hdk_fetch_conan_package PACKAGE_NAME PACKAGE_VERSION PROFILE_FILE)

    # Required conan package and package version, set if not specified
    set(PACKAGE_NAME_VERSION ${PACKAGE_NAME}/${PACKAGE_VERSION})
    
    hdk_log_status("Resolving conan dependency `${PACKAGE_NAME_VERSION}`")
    hdk_log_indent(1)

    # Determine installed "benchmark" package version
    execute_process(COMMAND /usr/bin/env conan search ${PACKAGE_NAME_VERSION} OUTPUT_VARIABLE CONAN_SEARCH_RESULT)

    string(REGEX MATCH "${PACKAGE_NAME}/(([0-9]+)\\.([0-9]+)\\.([0-9]+))" CONAN_SEARCH_RESULT_VERSION ${CONAN_SEARCH_RESULT})

    if(NOT ${CMAKE_MATCH_COUNT} LESS 4)
        if(${CMAKE_MATCH_1} STREQUAL ${PACKAGE_VERSION})
            hdk_log_status("Conan package `${PACKAGE_NAME_VERSION}` present in environment")
        else()
            hdk_log_status("Conan package is present with name `${PACKAGE_NAME}` but version does not match with required version `${PACKAGE_VERSION}` != `${CMAKE_MATCH_1}`, it will be fetched from remote")
        endif()
    else()
       hdk_log_status("Conan package  `${PACKAGE_NAME_VERSION}` is not present in environment, it will be fetched from remote")
    endif()

    hdk_log_status("Executing conan for `${PACKAGE_NAME_VERSION}`... (please be patient)")

    if(DEFINED PROFILE_FILE AND NOT ${PROFILE_FILE} STREQUAL "")
        hdk_log_status("Using user-defined conan profile file `${PROFILE_FILE}`")
        set(PROFILE_LINE PROFILE ${PROFILE_FILE})
    else()
        set(PROFILE_LINE "")
    endif()

    conan_cmake_run(
        REQUIRES ${PACKAGE_NAME_VERSION}
        ${PROFILE_LINE}
        GENERATORS cmake_find_package
        BUILD missing
        OUTPUT_QUIET
    )

    hdk_log_status("Conan execution done for `${PACKAGE_NAME_VERSION}`")
    hdk_log_unindent(1)

endfunction()