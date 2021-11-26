#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for running gcov code coverage analysis.
# 
# @file 	GCovR.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	13.03.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include_guard(DIRECTORY)

include(.hadouken/cmake/modules/toolconf/detail/helper_functions.cmake)

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOVR                "Use gcovr in project"                          OFF)

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOVR AND NOT (${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV OR ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV))
    hdk_log_err("gcov or llvm-cov must be activated to use gcovr for test coverage")
endif()

# Ensure these are included before the GCovR module, so ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} gets defined
include(toolconf/GCov)
include(toolconf/LLVMCov)

hdk_find_program_if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOVR 
    GCOVR
    DEFAULT_NAME gcovr
    REQUIRED
)

if(HDK_TOOL_GCOVR)
    add_custom_target(
        ${HDK_ROOT_PROJECT_NAME}.gcovr.summary
        COMMAND gcovr --gcov-executable ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} -r ${HDK_ROOT_PROJECT_SOURCE_DIR} -e '.*/test/.*' -e '.*/CompilerIdCXX/.*'
    )
endif()