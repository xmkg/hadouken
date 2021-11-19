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

include_guard(GLOBAL)

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "Code coverage results with an optimised (non-Debug) build may be misleading")
endif()

add_link_options(--coverage)