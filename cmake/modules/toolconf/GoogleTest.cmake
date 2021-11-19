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

include(core/FetchConanPackage)

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_TEST)

    set(${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME "gtest" CACHE STRING "Hadouken google test conan package name")
    set(${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_TEST_VERSION  "1.11.0" CACHE STRING "Hadouken google test conan package version")

    hdk_log_status("Starting tool configuration for Google Test (`${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME}/${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_TEST_VERSION}`)")
    hdk_log_indent(1)
    hdk_fetch_conan_package(
        ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_TEST_PKG_NAME} 
        ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_TEST_VERSION}
        ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_PROFILE_FILE}
    )

    include(GoogleTest)

    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${HDK_ROOT_PROJECT_BINARY_DIR})
    find_package(GTest REQUIRED)

    make_target(
        NAME ${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.test 
        TYPE STATIC SOURCES ${HDK_ROOT_PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/toolconf/GoogleTest.cpp 
        LINK PUBLIC GTest::GTest
    )
    hdk_log_status("Auto-created `${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.test` target")
    hdk_log_unindent(1)
else()
    hdk_log_verbose("Skipping tool configuration for `Google Test` (disabled)")
endif()

hdk_log_unset_context()