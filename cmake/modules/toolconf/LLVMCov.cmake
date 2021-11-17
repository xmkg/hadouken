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

option(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV "Use llvm-cov in project" OFF)

hdk_log_set_context("llvm-cov")

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV)
    hdk_log_status("Configuring tool `llvm-cov`")

    find_program(LLVM_COV "llvm-cov")
    if(LLVM_COV)
        hdk_log_status("Found `llvm-cov` executable: ${LLVM_COV}`")
    else()
        hdk_log_err("`llvm-cov` not found in environment")
    endif()   
else()
    hdk_log_verbose("Skipping tool configuration for `llvm-cov` (disabled)")
endif()

hdk_log_unset_context()
