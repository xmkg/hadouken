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

set(HADOUKEN_COMPILER CLANG)

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


# function(hdk_set_build_variant_clang WARN_BUT_NO_ERROR EXTENDED_WARNINGS EXCLUDED_WARNIGS)
#   hdk_log_set_context("clang")

#   set_property(GLOBAL PROPERTY HADOUKEN_COMPILER "CLANG")

#   set(WBNE "")
#   set(EXTW "")
#   set(EXCW "")

#   foreach(VER_MAJOR RANGE 0 99)
#     foreach(VER_MINOR RANGE 0 99)

#       if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER ${VER_MAJOR}.${VER_MINOR})

#         # Warn but no error
#         if(DEFINED CLANG_${VER_MAJOR}${VER_MINOR}_WARN_BUT_NO_ERROR)
#           hdk_log_trace("Appended ${CLANG_${VER_MAJOR}${VER_MINOR}_WARN_BUT_NO_ERROR} to WARN_BUT_NO_ERROR")
#           string(CONCAT WBNE ${WBNE} " " ${CLANG_${VER_MAJOR}${VER_MINOR}_WARN_BUT_NO_ERROR})
#         endif()

#         # Extended warnings which are not included in -Wall
#         if(DEFINED CLANG_${VER_MAJOR}${VER_MINOR}_EXTENDED_WARNINGS)
#           hdk_log_trace("Appended ${CLANG_${VER_MAJOR}${VER_MINOR}_EXTENDED_WARNINGS} to EXTENDED_WARNINGS")
#           string(CONCAT EXTW ${EXTW} " " ${CLANG_${VER_MAJOR}${VER_MINOR}_EXTENDED_WARNINGS})
#         endif()

#         # Excluded warnings which are included in -Wall but not so much useful
#         if(DEFINED CLANG_${VER_MAJOR}${VER_MINOR}_EXCLUDED_WARNINGS)
#           hdk_log_trace("Appended ${CLANG_${VER_MAJOR}${VER_MINOR}_EXCLUDED_WARNINGS} to EXCLUDED_WARNINGS")
#           string(CONCAT EXCW ${EXCW} " " ${CLANG_${VER_MAJOR}${VER_MINOR}_EXCLUDED_WARNINGS})
#         endif()
#       endif()
#     endforeach()
#   endforeach()


#   set(${EXCLUDED_WARNINGS} ${WBNE} PARENT_SCOPE)
#   set(${EXTENDED_WARNINGS} ${EXTW} PARENT_SCOPE)
#   set(${WARN_BUT_NO_ERROR} ${EXCW} PARENT_SCOPE)
# endfunction()
