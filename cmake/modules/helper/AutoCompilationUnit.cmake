#!/usr/bin/env cmake

# ______________________________________________________
# Contains helper functions to gather header and source files from projects
# containing source files in `include/src` format.
# 
# @file 	AutoCompilationUnit.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

# Gather all files under `include` and `src` folders at current directory level 
# to `COMPILATION_UNIT` variable in invocation scope.
function(file_gather_compilation_unit)
    file(GLOB_RECURSE HEADERS "include/*")
    file(GLOB_RECURSE SOURCES "src/*")

    set(HEADERS ${HEADERS} PARENT_SCOPE)
    set(SOURCES ${SOURCES} PARENT_SCOPE)
    set(COMPILATION_UNIT ${HEADERS} ${SOURCES} PARENT_SCOPE)
endfunction()

