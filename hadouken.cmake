#!/usr/bin/env cmake

# ______________________________________________________
# Contains the list of required includes for Hadouken.
#
# @file     hadouken.cmake
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date     14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. All rights reserved.
# Licensed under the Apache 2.0 License. See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier: Apache 2.0
# ______________________________________________________



set(PB_PARENT_PROJECT_NAME              ${PROJECT_NAME}             )
set(PB_PARENT_PROJECT_VERSION           ${PROJECT_VERSION}          )
set(PB_PARENT_PROJECT_DESCRIPTION       ${PROJECT_DESCRIPTION}      )
set(PB_PARENT_PROJECT_SOURCE_DIR        ${PROJECT_SOURCE_DIR}       )
set(PB_PARENT_PROJECT_BINARY_DIR        ${PROJECT_BINARY_DIR}       )
set(PB_PARENT_PROJECT_HOMEPAGE_URL      ${PROJECT_HOMEPAGE_URL}     )

string(TOUPPER ${PB_PARENT_PROJECT_NAME} PB_PARENT_PROJECT_NAME_UPPER)

# Maket it C preprocessor macro friently
string(REGEX REPLACE "[^a-zA-Z0-9]" "_" PB_PARENT_PROJECT_NAME_UPPER ${PB_PARENT_PROJECT_NAME_UPPER})

# Enable testing for the project
enable_testing()
# Project-wide C++ standard declaration
# (mgilor): It is a bit restrictive, removed for now.
# set(CMAKE_CXX_STANDARD 17)
#add_compile_options(-std=c++2a)
#add_compile_options(-fconcepts)
# Make C++ standard required.
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Export compile commands for other tool usage
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Hide all symbols on all projects by default
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
# Hide inline functions and template declarations too
set(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)
# Visibility policy
cmake_policy(SET CMP0063 NEW)
# `Adding link libraries to target which is not built in current directory` policy
# (Required for coverage link library injection)
cmake_policy(SET CMP0079 NEW)
# This somehow tends to be unset, and causes third party library headers to generate warnings
# which results in build failure.
SET(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-isystem ")
# Add hadouken cmake modules as cmake modules to parent project
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/)
# Add custom find module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/find)

# Banner module
include(misc/Banner)

message(STATUS "[*] Configuring project: ${PB_PARENT_PROJECT_NAME} with CMake ${CMAKE_VERSION}")

# Discover all helper modules
file(GLOB HELPER_MODULES "${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/helper/*.cmake")
# Discover all toolconf modules
file(GLOB TOOLCONF_MODULES "${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/toolconf/*.cmake")

# Include all found modules
foreach(MODULE_FN IN LISTS HELPER_MODULES TOOLCONF_MODULES)
    include(${MODULE_FN})
endforeach()

include(buildvariant/BuildVariant)
include(FeatureCheck)

