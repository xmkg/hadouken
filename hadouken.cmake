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


string(TIMESTAMP HADOUKEN_LOAD_START "%s" UTC)


set(HDK_ROOT_PROJECT_NAME              ${PROJECT_NAME}             )
set(HDK_ROOT_PROJECT_VERSION           ${PROJECT_VERSION}          )
set(HDK_ROOT_PROJECT_DESCRIPTION       ${PROJECT_DESCRIPTION}      )
set(HDK_ROOT_PROJECT_SOURCE_DIR        ${PROJECT_SOURCE_DIR}       )
set(HDK_ROOT_PROJECT_BINARY_DIR        ${PROJECT_BINARY_DIR}       )
set(HDK_ROOT_PROJECT_HOMEPAGE_URL      ${PROJECT_HOMEPAGE_URL}     )

set(HDK_ROOT_DIRECTORY     ${HDK_ROOT_PROJECT_SOURCE_DIR}/.hadouken)

string(TOUPPER ${HDK_ROOT_PROJECT_NAME} HDK_ROOT_PROJECT_NAME_UPPER)

# Maket it C preprocessor macro friently
string(REGEX REPLACE "[^a-zA-Z0-9]" "_" HDK_ROOT_PROJECT_NAME_UPPER ${HDK_ROOT_PROJECT_NAME_UPPER})


# Hadouken options
set(${HDK_ROOT_PROJECT_NAME_UPPER}_CXX_FLAGS_DEBUG                                   "-O0 -g"           )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_FLAGS_RELEASE                             "-O3 -DNDEBUG"     )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_FLAGS_RELWITHDEBINFO                      "-O3 -g -DNDEBUG"  )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_FLAGS_MINSIZEREL                          "-Os -DNDEBUG"     )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_TREAT_WARNINGS_AS_ERRORS_ON_DEBUG         OFF                )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_TREAT_WARNINGS_AS_ERRORS_ON_RELEASE       ON                 )

# Enable testing for the project
enable_testing()
# Project-wide C++ standard declaration
# (mgilor): It is a bit restrictive, removed for now.
# set(CMAKE_CXX_STANDARD 17)
#add_compile_options(-std=c++2a)
#add_compile_options(-fconcepts)
# Make C++ standard required.
# set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Show message context (new on CMake 3.17)
# option(CMAKE_MESSAGE_CONTEXT_SHOW TRUE)
# Warn on deprecated logs
option(CMAKE_WARN_DEPRECATED  ON) 
# Export compile commands for other tool usage
option(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Print colorful makefile output
option(CMAKE_COLOR_MAKEFILE   ON)
# Recommended setting for symbol visibility.
if(NOT DEFINED CMAKE_CXX_VISIBILITY_PRESET)
    set(CMAKE_CXX_VISIBILITY_PRESET hidden)
endif()
# Recommended setting for inline symbol visibility.
option(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)
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

# Logging module
include(misc/Log)

# Banner module
include(misc/Banner)

# Set logging context
hdk_log_set_context("hadouken")
hdk_log_status("-------------------------- hadouken bootstrap start -----------------------------")
hdk_log_status("Configuring project `${HDK_ROOT_PROJECT_NAME}` with CMake ${CMAKE_VERSION}")
hdk_log_unset_context()

# Discover all core modules
file(GLOB CORE_MODULES "${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/core/*.cmake")
# Discover all toolconf modules
file(GLOB TOOLCONF_MODULES "${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/toolconf/*.cmake")
# Discover all wrapper modules
file(GLOB WRAPPER_MODULES "${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/wrappers/*.cmake")


hdk_log_set_context("hadouken.load.core")
hdk_log_status("loading core modules..")
foreach(MODULE_FN IN LISTS CORE_MODULES)
    hdk_log_trace("hadouken: loading core module: ${MODULE_FN}")
    include(${MODULE_FN})
endforeach()
hdk_log_status("core modules loaded")
hdk_log_unset_context()


hdk_set_build_variant()

hdk_log_set_context("hadouken.load.wrapper")
hdk_log_status("loading wrapper modules..")
foreach(MODULE_FN IN LISTS WRAPPER_MODULES)
    hdk_log_trace("hadouken: loading module: ${MODULE_FN}")
    include(${MODULE_FN})
endforeach()
hdk_log_status("wrapper modules loaded")
hdk_log_unset_context()


hdk_log_set_context("hadouken.toolconf")
hdk_log_status("loading tool configuration modules..")
foreach(MODULE_FN IN LISTS TOOLCONF_MODULES)
    hdk_log_trace("hadouken: loading tool configuration module: ${MODULE_FN}")
    include(${MODULE_FN})
endforeach()
hdk_log_status("tool configuration modules loaded")
hdk_log_unset_context()

include(FeatureCheck)

string(TIMESTAMP HADOUKEN_LOAD_END "%s" UTC)
math(EXPR HADOUKEN_LOAD_DURATION "${HADOUKEN_LOAD_END}-${HADOUKEN_LOAD_START}")

hdk_log_set_context("hadouken")
hdk_log_status("Load completed in ${HADOUKEN_LOAD_DURATION} second(s)")
hdk_log_unset_context()
hdk_log_status("--------------------------  hadouken bootstrap end  -----------------------------")


