#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for locating and linking google test & google mock.
# 
# @file 	GoogleTest.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	28.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________


option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_TEST "Use google test in project" OFF)

hdk_log_set_context("gtest")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_TEST)

    set(HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME "gtest")
    set(HADOUKEN_CONAN_GOOGLE_TEST_VERSION "1.10.0")

    hdk_log_status("Configuring tool `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}` (${HADOUKEN_CONAN_GOOGLE_TEST_VERSION})")

    # Determine installed "benchmark" package version
    execute_process(COMMAND /usr/bin/env conan search ${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME} OUTPUT_VARIABLE CONAN_SEARCH_RESULT)

    string(REGEX MATCH "gtest/(([0-9]+)\\.([0-9]+)\\.([0-9]+))" CONAN_SEARCH_RESULT_VERSION ${CONAN_SEARCH_RESULT})

    if(NOT ${CMAKE_MATCH_COUNT} LESS 4)
        if(${CMAKE_MATCH_1} STREQUAL ${HADOUKEN_CONAN_GOOGLE_TEST_VERSION})
            hdk_log_status("Conan package  `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}` present in environment")
        else()
            hdk_log_status("Conan package is present with name `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}` but version does not match with required version `${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}` != `${CMAKE_MATCH_1}`, it will be fetched from remote")
        endif()
    else()
        hdk_log_status("Conan package  `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}` is not present in environment, it will be fetched from remote")
    endif()

    include(GoogleTest)

    hdk_log_status("Executing conan... (please be patient)")
    conan_cmake_run(
        REQUIRES ${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}
        BASIC_SETUP CMAKE_TARGETS
        BUILD missing
        OUTPUT_QUIET
    )
    hdk_log_status("Conan execution done")

    make_target(
        NAME ${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.test 
        TYPE STATIC SOURCES ${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/toolconf/GoogleTest.cpp 
        LINK PUBLIC CONAN_PKG::gtest
    )
    hdk_log_status("Auto-created `${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.test` target")
   
else()
    hdk_log_verbose("Skipping tool configuration for `gtest` (disabled)")
endif()

hdk_log_unset_context()