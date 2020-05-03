# ______________________________________________________
# CMake module for locating and linking google benchmark.
# 
# @file 		GoogleTest.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		28.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

if(${PB_PARENT_PROJECT_NAME}_TOOLCONF_USE_GOOGLE_BENCH)
    message(STATUS "[*] Configuring `googlebench`")

    project(${PB_PARENT_PROJECT_NAME}.benchmark VERSION 1.0.0 LANGUAGES CXX)

    find_package(benchmark QUIET REQUIRED)

    make_target(TYPE STATIC SOURCES ${PROJECT_SOURCE_DIR}/boilerplate/cmake/modules/toolconf/GoogleBenchmark.cpp LINK PUBLIC benchmark::benchmark benchmark::benchmark_main)
endif()