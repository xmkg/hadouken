#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for GCC specific build, warning and error flags 
# settings.
# 
# @file 	DiagnosticFlags_GCC.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

# TODO(mgilor): These flags are better be provided in a configuration file
# and user should be able to override any of the flags when desired.

# see: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html for
# all warning flag documentations used in this code

##########################################################
# GCC 3.4 and above
# ------------------------------------
# -Wformat=2
#
# Enable -Wformat plus additional format checks. Currently equivalent to -Wformat -Wformat-nonliteral -Wformat-security -Wformat-y2k.
# Check calls to printf and scanf, etc., to make sure that the arguments supplied have types appropriate to the format string specified, 
# and that the conversions specified in the format string make sense. This includes standard functions, and others specified by format 
# attributes (see Function Attributes), in the printf, scanf, strftime and strfmon (an X/Open extension, not in the C standard) families 
# (or other target-specific families). Which functions are checked without format attributes having been specified depends on the standard 
# version selected, and such checks of functions without the attribute specified are disabled by -ffreestanding or -fno-builtin.
#
# The formats are checked against the format features supported by GNU libc version 2.2. These include all ISO C90 and C99 features, 
# as well as features from the Single Unix Specification and some BSD and GNU extensions. Other library implementations may not support 
# all these features; GCC does not support warning about features that go beyond a particular library’s limitations. 
# However, if -Wpedantic is used with -Wformat, warnings are given about format features not in the selected standard version 
# (but not for strfmon formats, since those are not in any version of the C standard). See Options Controlling C Dialect.
#
# Example:
#
# void foo(char *p)
# {
#   printf(p); // triggers, printf expects first parameter to be format parameter, got variable instead. use printf("%s", p); instead.
# }
# ------------------------------------
# -Wcast-qual
#
# Warn whenever a pointer is cast so as to remove a type qualifier from the target type. For example, warn if a const char * 
# is cast to an ordinary char *.Also warn when making a cast that introduces a type qualifier in an unsafe way. For example, 
# casting char ** to const char ** is unsafe.
#
# Example:
#
# /* p is char ** value.  */
# const char **q = (const char **) p;
# /* Assignment of readonly string to const char * is OK.  */
# *q = "string";
# /* Now char** pointer points to read-only memory.  */
# **p = 'b';
set(GCC_34_WARN_BUT_NO_ERROR "-Wold-style-cast -Wmissing-noreturn" )
set(GCC_34_EXTENDED_WARNINGS "-Wformat=2 -Wcast-qual" )
set(GCC_34_EXCLUDED_WARNINGS "-Wno-unknown-pragmas -Wno-switch -Wno-unused-function" )
hdk_unset_if_empty(GCC_34_WARN_BUT_NO_ERROR GCC_34_EXTENDED_WARNINGS GCC_34_EXCLUDED_WARNINGS)

########################################
# GCC 4.3 and above
# ------------------------------------
# -Wlogical-op
# 
# Warn about suspicious uses of logical operators in expressions. This includes using logical operators in contexts 
# where a bit-wise operator is likely to be expected. Also warns when the operands of a logical operator are the same.
# 
# Example:
#
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
set(GCC_43_WARN_BUT_NO_ERROR "-Wlogical-op" )
set(GCC_43_EXTENDED_WARNINGS "" )
set(GCC_43_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_43_WARN_BUT_NO_ERROR GCC_43_EXTENDED_WARNINGS GCC_43_EXCLUDED_WARNINGS)


# GCC 4.6 and above
set(GCC_46_WARN_BUT_NO_ERROR "-Wdouble-promotion -Wsuggest-attribute=pure -Wsuggest-attribute=const -Wsuggest-attribute=noreturn" )
set(GCC_46_EXTENDED_WARNINGS "" )
set(GCC_46_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_46_WARN_BUT_NO_ERROR GCC_46_EXTENDED_WARNINGS GCC_46_EXCLUDED_WARNINGS)


########################################
# GCC 4.8 and above
# ------------------------------------
# -Wold-style-cast
# int *foo(void *p)
# {
#   return (int *)p; // triggers, this is c-style cast, use reinterpret_cast<int*>() instead.
# }
# ------------------------------------
# -Wuseless-cast
# int *foo(int *p)
# {
#   return static_cast<int *>(p); // triggers, p is already int*.
# }
set(GCC_48_WARN_BUT_NO_ERROR "-Wold-style-cast -Wmissing-noreturn" )
set(GCC_48_EXTENDED_WARNINGS "-Wuseless-cast" )
set(GCC_48_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_48_WARN_BUT_NO_ERROR GCC_48_EXTENDED_WARNINGS GCC_48_EXCLUDED_WARNINGS)


# GCC 5.0 and above
set(GCC_50_WARN_BUT_NO_ERROR "-Wsuggest-override" )
set(GCC_50_EXTENDED_WARNINGS "" )
set(GCC_50_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_50_WARN_BUT_NO_ERROR GCC_50_EXTENDED_WARNINGS GCC_50_EXCLUDED_WARNINGS)


# GCC 5.1 and above
set(GCC_51_WARN_BUT_NO_ERROR "-Wsuggest-final-methods -Wsuggest-final-types")
set(GCC_51_EXTENDED_WARNINGS "" )
set(GCC_51_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_51_WARN_BUT_NO_ERROR GCC_51_EXTENDED_WARNINGS GCC_51_EXCLUDED_WARNINGS)


########################################
# GCC 6.0 and above
# ------------------------------------
# -Wduplicated-cond
# 
#   if(a == 0){
#   ...
#   }else if(a==0) // triggers 
# ------------------------------------
# -Wnull-dereference
# void foo(int *p, int a)
# {
#   int *q = 0;
#   if (0 <= a && a < 10)
#     q = p + a;
#   *q = 1;  // triggers, q might be null
# }
set(GCC_60_WARN_BUT_NO_ERROR "" )
set(GCC_60_EXTENDED_WARNINGS "-Wduplicated-cond -Wnull-dereference")
set(GCC_60_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_60_WARN_BUT_NO_ERROR GCC_60_EXTENDED_WARNINGS GCC_60_EXCLUDED_WARNINGS)


########################################
# GCC 7.0 and above
# --------------------------------------
# -Wduplicated-branches:
# 
#   if(a == 1){
#    printf("abcdef");
#   }else if(a == 2){
#    printf("abcdef"); // triggers
#   }  
set(GCC_70_WARN_BUT_NO_ERROR "" )
set(GCC_70_EXTENDED_WARNINGS "-Wduplicated-branches" )
set(GCC_70_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_70_WARN_BUT_NO_ERROR GCC_70_EXTENDED_WARNINGS GCC_70_EXCLUDED_WARNINGS)


# GCC 8.0 and above
set(GCC_80_WARN_BUT_NO_ERROR "-Wsuggest-attribute=malloc" )
set(GCC_80_EXTENDED_WARNINGS "" )
set(GCC_80_EXCLUDED_WARNINGS "" )
hdk_unset_if_empty(GCC_80_WARN_BUT_NO_ERROR GCC_80_EXTENDED_WARNINGS GCC_80_EXCLUDED_WARNINGS)

