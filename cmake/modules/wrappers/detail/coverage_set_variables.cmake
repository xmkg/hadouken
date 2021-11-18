# The module contains macros and functions that have common 
# interfaces on both of LCov and GCovr variables.
# 
# @file 	ClangTidy.cmake
# @author 	Ahmet İbrahim AKSOY <aaksoy@nettsi.com>
# @date 	18.11.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________


macro(set_common_variables)
    set(COVERAGE_COMPILER_FLAGS "-g --coverage -fprofile-arcs -ftest-coverage"
        CACHE INTERNAL "")

    set(CMAKE_CXX_FLAGS_COVERAGE
        ${COVERAGE_COMPILER_FLAGS}
        CACHE STRING "Flags used by the C++ compiler during coverage builds."
        FORCE )
    set(CMAKE_C_FLAGS_COVERAGE
        ${COVERAGE_COMPILER_FLAGS}
        CACHE STRING "Flags used by the C compiler during coverage builds."
        FORCE )
    set(CMAKE_EXE_LINKER_FLAGS_COVERAGE
        ""
        CACHE STRING "Flags used for linking binaries during coverage builds."
        FORCE )
    set(CMAKE_SHARED_LINKER_FLAGS_COVERAGE
        ""
        CACHE STRING "Flags used by the shared libraries linker during coverage builds."
        FORCE )
    mark_as_advanced(
        CMAKE_CXX_FLAGS_COVERAGE
        CMAKE_C_FLAGS_COVERAGE
        CMAKE_EXE_LINKER_FLAGS_COVERAGE
        CMAKE_SHARED_LINKER_FLAGS_COVERAGE )

    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(STATUS "Code coverage results with an optimised (non-Debug) build may be misleading")
    endif()

    if(${HADOUKEN_COMPILER} STREQUAL "GCC" OR ${HADOUKEN_COMPILER} STREQUAL "CLANG")
        link_libraries(gcov)
        if(${HADOUKEN_COMPILER} STREQUAL "CLANG")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
        endif()
    else()
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
    endif()
endmacro()