#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for running llvm-cov code coverage analysis.
# 
# @file 	LLVMCov.cmake
# @author 	Ahmet İbrahim AKSOY <aaksoy@nettsi.com>
# @date 	16.11.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV "Use llvm-cov in project" OFF)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV 
        LLVM_COV
        DEFAULT_NAME llvm-cov
        NAMES llvm-cov-13 llvm-cov-12 llvm-cov-11 llvm-cov-10
        REQUIRED
    )
if(HDK_TOOL_LLVM_COV)
    set(HDK_TOOLPATH_COVERAGE_EXECUTABLE "${HDK_TOOL_LLVM_COV} gcov")
endif()
