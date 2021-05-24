#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for locating and linking google benchmark.
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


option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_BENCH "Use google benchmark in project" OFF)

hdk_log_set_context("benchmark")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_BENCH)

    # Required conan package and package version
    option(HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME "Hadouken google benchmark conan package name" "benchmark")
    option(HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION "Hadouken conan package google benchmark version"  "1.5.3")

    hdk_log_status("Configuring tool `${HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME}` (${HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION})")

    # Determine installed "benchmark" package version
    execute_process(COMMAND /usr/bin/env conan search ${HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME} OUTPUT_VARIABLE CONAN_SEARCH_RESULT)

    string(REGEX MATCH "benchmark/(([0-9]+)\\.([0-9]+)\\.([0-9]+))" CONAN_SEARCH_RESULT_VERSION ${CONAN_SEARCH_RESULT})

    if(NOT ${CMAKE_MATCH_COUNT} LESS 4)
        if(${CMAKE_MATCH_1} STREQUAL ${HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION})
            hdk_log_status("Conan package  `${HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION}` present in environment")
        else()
            hdk_log_status("Conan package is present with name `${HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME}` but version does not match with required version `${HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION}` != `${CMAKE_MATCH_1}`, it will be fetched from remote")
        endif()
    else()
       hdk_log_status("Conan package  `${HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION}` is not present in environment, it will be fetched from remote")
    endif()

    hdk_log_status("Executing conan... (please be patient)")
    conan_cmake_run(
        REQUIRES ${HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME}/${HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION}
        GENERATORS cmake_find_package
        BUILD missing
        OUTPUT_QUIET
    )
    hdk_log_status("Conan execution done")

    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${HDK_ROOT_PROJECT_BINARY_DIR})
    find_package(${HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME} REQUIRED)

    make_target(
        NAME ${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.benchmark    
        TYPE STATIC SOURCES ${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/toolconf/GoogleBenchmark.cpp 
        LINK PUBLIC benchmark::benchmark
    )
    hdk_log_status("Auto-created `${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.benchmark` target")

else()
    hdk_log_verbose("Skipping tool configuration for `google benchmark` (disabled)")
endif()

hdk_log_unset_context()