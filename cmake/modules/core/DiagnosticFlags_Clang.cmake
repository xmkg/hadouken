#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for Clang specific build, warning and error flags 
# settings.
#
# @file 	DiagnosticFlags_Clang.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

# Clang 3.2 and above
set(CLANG_32_WARN_BUT_NO_ERROR "" )
set(CLANG_32_EXTENDED_WARNINGS "" )
set(CLANG_32_EXCLUDED_WARNINGS "-Wno-c++98-compat-pedantic -Wno-documentation -Wno-shadow -Wno-exit-time-destructors -Wno-global-constructors -Wno-braced-scalar-init" )

# Clang 3.4 and above
set(CLANG_34_WARN_BUT_NO_ERROR "" )
set(CLANG_34_EXTENDED_WARNINGS "" )
set(CLANG_34_EXCLUDED_WARNINGS "-Wno-newline-eof" )

# Clang 3.5 and above
set(CLANG_35_WARN_BUT_NO_ERROR "" )
set(CLANG_35_EXTENDED_WARNINGS "" )
set(CLANG_35_EXCLUDED_WARNINGS "-Wno-unreachable-code-return" )

# Clang 3.9 and above
set(CLANG_39_WARN_BUT_NO_ERROR "" )
set(CLANG_39_EXTENDED_WARNINGS "" )
set(CLANG_39_EXCLUDED_WARNINGS "-Wno-shadow-field-in-constructor" )