#!/usr/bin/env cmake

# ______________________________________________________
# CMake file to check whether compiler supports __builtin_expect builtin 
# available in compilation environment.
# 
# @file 	CheckGccBuiltinExpect.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	03.05.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

set(CMAKE_REQUIRED_QUIET true)

check_cxx_source_compiles("
    int main(void)
    {
        auto r1 = __builtin_expect(true, true);
        auto r2 = __builtin_expect(false,false);
        (void)r1;
        (void)r2;
        return 0;
    }
    "
    ${PB_PARENT_PROJECT_NAME_UPPER}_FEATURE_HAS_GCC_BUILTIN_EXPECT
)