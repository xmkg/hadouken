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

include(core/FetchConanPackage)

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_BENCH)
    # Required conan package and package version, set if not specified
    set(${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME "benchmark" CACHE STRING "Hadouken google benchmark conan package name")
    set(${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION  "1.5.3" CACHE STRING "Hadouken google benchmark conan package version")

    hdk_log_status("Starting tool configuration for Google Benchmark (`${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME}/${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION}`)")
    hdk_log_indent(1)
    # PACKAGE_NAME PACKAGE_VERSION PROFILE_FILE
    hdk_fetch_conan_package(
        ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_BENCHMARK_PKG_NAME} 
        ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_GOOGLE_BENCHMARK_VERSION}
        ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_PROFILE_FILE}
    )

    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${HDK_ROOT_PROJECT_BINARY_DIR})
    find_package(benchmark REQUIRED)

    make_target(
        NAME ${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.benchmark    
        TYPE STATIC SOURCES ${HDK_ROOT_PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/toolconf/GoogleBenchmark.cpp 
        LINK PUBLIC benchmark::benchmark
    )
    hdk_log_status("Auto-created `${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.benchmark` target")

    hdk_log_unindent(1)

else()
    hdk_log_verbose("Skipping tool configuration for `Google Benchmark` (disabled)")
endif()

hdk_log_unset_context()