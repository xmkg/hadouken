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

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_TEST)

    set(HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME "gtest")
    set(HADOUKEN_CONAN_GOOGLE_TEST_VERSION "1.10.0")

    message(STATUS "[*] Configuring `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}` (${HADOUKEN_CONAN_GOOGLE_TEST_VERSION})")

    # Determine installed "benchmark" package version
    execute_process(COMMAND /usr/bin/env conan search ${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME} OUTPUT_VARIABLE CONAN_SEARCH_RESULT)

    string(REGEX MATCH "gtest/(([0-9]+)\\.([0-9]+)\\.([0-9]+))" CONAN_SEARCH_RESULT_VERSION ${CONAN_SEARCH_RESULT})

    if(NOT ${CMAKE_MATCH_COUNT} LESS 4)
        if(${CMAKE_MATCH_1} STREQUAL ${HADOUKEN_CONAN_GOOGLE_TEST_VERSION})
            message(STATUS "\t[+] Conan package  `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}` present in environment")
        else()
            message(STATUS "\t[?] Conan package is present with name `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}` but version does not match with required version `${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}` != `${CMAKE_MATCH_1}`, it will be fetched from remote")
        endif()
    else()
        message(STATUS "\t[-] Conan package  `${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}` is not present in environment, it will be fetched from remote")
    endif()

    include(GoogleTest)

    conan_cmake_run(
        REQUIRES ${HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_TEST_VERSION}
        BASIC_SETUP CMAKE_TARGETS
        BUILD missing
        OUTPUT_QUIET
    )

    make_target(
        NAME ${PB_PARENT_PROJECT_NAME}.hadouken_autotargets.test 
        TYPE STATIC SOURCES ${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/toolconf/GoogleTest.cpp 
        LINK PUBLIC CONAN_PKG::gtest
    )

endif()