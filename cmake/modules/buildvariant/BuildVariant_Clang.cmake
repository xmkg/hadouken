#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for Clang specific build, warning and error flags 
# settings.
#
# @file 	BuildVariant_GCC.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

set_property(GLOBAL PROPERTY HADOUKEN_COMPILER "CLANG")

# -Weverything
set(WARN_BUT_NO_ERROR "")
#set(EXCLUDED_WERRORS "-Wno-error=braced-scalar-init")
set(EXCLUDED_WARNINGS "-Wno-braced-scalar-init -Wno-c++98-compat-pedantic -Wno-documentation -Wno-shadow-field-in-constructor -Wno-shadow -Wno-newline-eof -Wno-unreachable-code-return -Wno-exit-time-destructors -Wno-global-constructors")
