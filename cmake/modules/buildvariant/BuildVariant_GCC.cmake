#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for GCC specific build, warning and error flags 
# settings.
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

##########################################################
# Explanation of enabled warnings, which treated as errors

# -Wduplicated-cond
#   if(a == 0){
#   ...
#   }else if(a==0) // triggers  

# -Wduplicated-branches
#   if(a == 1){
#    printf("abcdef");
#   }else if(a == 2){
#    printf("abcdef"); // triggers
#   }  

# -Wlogical-op
# int foo(int a)
# {
#   a = a || 0xf0; // triggers
#   return a;
# }
# int foo(int a)
# {
#   if (a < 0 && a < 0) // triggers, same
#     return 0;
#   return 1;
# }

# -Wnull-dereference
# void foo(int *p, int a)
# {
#   int *q = 0;
#   if (0 <= a && a < 10)
#     q = p + a;
#   *q = 1;  // triggers, q might be null
# }

# -Wold-style-cast
# int *foo(void *p)
# {
#   return (int *)p; // triggers, this is c-style cast, use reinterpret_cast<int*>() instead.
# }

# -Wuseless-cast
# int *foo(int *p)
# {
#   return static_cast<int *>(p); // triggers, p is already int*.
# }

# -Wformat=2
# void foo(char *p)
# {
#   printf(p); // triggers, printf expects first parameter to be format parameter, got variable instead. use printf("%s", p); instead.
# }

# -Wcast-qual
# /* p is char ** value.  */
# const char **q = (const char **) p;
# /* Assignment of readonly string to const char * is OK.  */
# *q = "string";
# /* Now char** pointer points to read-only memory.  */
# **p = 'b';

##########################################################

set_property(GLOBAL PROPERTY HADOUKEN_COMPILER "GCC")

set(WARN_BUT_NO_ERROR "-Wlogical-op -Wold-style-cast -Wdouble-promotion -Wsuggest-attribute=pure -Wsuggest-attribute=const -Wsuggest-attribute=noreturn -Wmissing-noreturn")
set(EXTENDED_WARNINGS "-Wuseless-cast -Wformat=2 -Wcast-qual")

# Add GCC 5.0 warnings
if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.0)
  set(WARN_BUT_NO_ERROR "-Wsuggest-override ${WARN_BUT_NO_ERROR}")
endif()


# Add GCC 5.1 warnings
if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.1)
  set(WARN_BUT_NO_ERROR "-Wsuggest-final-methods -Wsuggest-final-types ${WARN_BUT_NO_ERROR}")
endif()


# Add GCC 6.0 warnings
if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 6.0)
  set(EXTENDED_WARNINGS "-Wduplicated-cond -Wnull-dereference ${EXTENDED_WARNINGS}")
endif()

# Add GCC 7.0 warnings
if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 7.0)
  set(EXTENDED_WARNINGS "-Wduplicated-branches ${EXTENDED_WARNINGS}")
endif()

# Add GCC 8.0 warnings
if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 8.0)
  set(WARN_BUT_NO_ERROR "-Wsuggest-attribute=malloc ${WARN_BUT_NO_ERROR}")
endif()

set(EXCLUDED_WARNINGS "-Wno-unknown-pragmas -Wno-switch -Wno-unused-function")
