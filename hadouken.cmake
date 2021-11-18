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
set(HDK_ROOT_PROJECT_LANGUAGES         ${PROJECT_LANGUAGES}        )

set(HDK_ROOT_DIRECTORY     ${HDK_ROOT_PROJECT_SOURCE_DIR}/.hadouken)



# Add hadouken cmake modules as cmake modules to parent project
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/)
# Add custom find module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/.hadouken/cmake/modules/find)

# Common utility functions module
include(misc/Utility)

# Capitalize and sanitize project name
hdk_capsan_name(${HDK_ROOT_PROJECT_NAME} HDK_ROOT_PROJECT_NAME_UPPER)

# Hadouken options
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_FLAGS_DEBUG                               "-O0 -g"           )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_FLAGS_RELEASE                             "-O3 -DNDEBUG"     )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_FLAGS_RELWITHDEBINFO                      "-O3 -g -DNDEBUG"  )
set(${HDK_ROOT_PROJECT_NAME_UPPER}_HDK_CXX_FLAGS_MINSIZEREL                          "-Os -DNDEBUG"     )

# Check if user specified a conan profile file
if (${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_PROFILE_FILE AND NOT ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_PROFILE_FILE} STREQUAL "") 
    set(${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_PROFILE_LINE "PROFILE ${${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_PROFILE_FILE}")
else()
    set(${HDK_ROOT_PROJECT_NAME_UPPER}_HADOUKEN_CONAN_PROFILE_LINE "")
endif()

# Enable testing for the project
enable_testing()

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



if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_COVERAGE)
    if(${HADOUKEN_COMPILER} STREQUAL "GCC")
        hdk_log_status("GCC compiler detected, GCov is activated for test coverage.")
        set(HDK_TOOLCONF_COVERAGE_HTML_TITLE "Hadouken GCC Code Coverage Report")
        set(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV ON CACHE BOOL "Enable/disable gcov")
        set(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV OFF CACHE BOOL "Enable/disable llvm-cov")
    elseif(${HADOUKEN_COMPILER} STREQUAL "CLANG")
        hdk_log_status("Clang compiler detected, LLVM Cov is activated for test coverage.")
        set(HDK_TOOLCONF_COVERAGE_HTML_TITLE "Hadouken Clang Code Coverage Report")
        set(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV OFF CACHE BOOL "Enable/disable gcov")
        set(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV ON CACHE BOOL "Enable/disable llvm-cov")
    endif()
endif()

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


