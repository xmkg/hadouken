#!/usr/bin/env cmake

# ______________________________________________________
# Finder module for hyperscan.
#
# @file        CMakeLists.txt
# @author      Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date        12.08.2020
#
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

# Leverage PkgConfig to determine possible include and library
# paths.
find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(PC_HYPERSCAN hyperscan)

# Try to determine path for the hyperscan include files
find_path(HYPERSCAN_INCLUDE_DIR
    NAMES hs.h
    HINTS ${PC_HYPERSCAN_INCLUDEDIR}
          ${PC_HYPERSCAN_INCLUDE_DIRS}
          "/usr/include/hs"
    PATH_SUFFIXES hyperscan  
)

# Try to determine path for the hyperscan library binaries
find_library(HYPERSCAN_LINK_LIBRARIES_SHARED
    NAMES libhs.so
    HINTS ${PC_HYPERSCAN_LIBDIR}
          ${PC_HYPERSCAN_LIBRARY_DIRS}
          "/usr/lib"
)

find_library(HYPERSCAN_LINK_LIBRARIES_STATIC
    NAMES libhs.a
    HINTS ${PC_HYPERSCAN_LIBDIR}
          ${PC_HYPERSCAN_LIBRARY_DIRS}
          "/usr/lib"
)

if(HYPERSCAN_INCLUDE_DIR)
    if(EXISTS "${HYPERSCAN_INCLUDE_DIR}/hs.h")
        file(READ "${HYPERSCAN_INCLUDE_DIR}/hs.h" HYPERSCAN_HS_HEADER_CONTENT)
        # Extract major version
        string(REGEX MATCH "#define +HS_MAJOR +([0-9]+)" _dummy "${HYPERSCAN_HS_HEADER_CONTENT}")
        set(HYPERSCAN_VERSION_MAJOR "${CMAKE_MATCH_1}")
        # Extract minor version
        string(REGEX MATCH "#define +HS_MINOR +([0-9]+)" _dummy "${HYPERSCAN_HS_HEADER_CONTENT}")
        set(HYPERSCAN_VERSION_MINOR "${CMAKE_MATCH_1}")
        # Extract patch version
        string(REGEX MATCH "#define +HS_PATCH +([0-9]+)" _dummy "${HYPERSCAN_HS_HEADER_CONTENT}")
        set(HYPERSCAN_VERSION_PATCH "${CMAKE_MATCH_1}")
        # Set the final version
        set(HYPERSCAN_VERSION "${HYPERSCAN_VERSION_MAJOR}.${HYPERSCAN_VERSION_MINOR}.${HYPERSCAN_VERSION_PATCH}")
    endif()
endif()

set(VERSION_OK TRUE)

if(Hyperscan_FIND_VERSION)
    if(Hyperscan_FIND_VERSION_EXACT)
        if(NOT "${Hyperscan_FIND_VERSION}" VERSION_EQUAL "${HYPERSCAN_VERSION}")
            set(VERSION_OK FALSE)
        endif()
    else()
        if(NOT "${HYPERSCAN_VERSION}" VERSION_GREATER "${Hyperscan_FIND_VERSION}")
            set(VERSION_OK FALSE)
        endif()
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Hyperscan
    FOUND_VAR Hyperscan_FOUND
    REQUIRED_VARS HYPERSCAN_INCLUDE_DIR HYPERSCAN_LINK_LIBRARIES_SHARED HYPERSCAN_LINK_LIBRARIES_STATIC VERSION_OK
)

if(Hyperscan_FOUND)
    if(NOT TARGET Hyperscan::Shared AND HYPERSCAN_LINK_LIBRARIES_SHARED)
        # Shared target
        add_library(Hyperscan::Shared INTERFACE IMPORTED)
        set_target_properties(Hyperscan::Shared PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${HYPERSCAN_INCLUDE_DIR}"
            INTERFACE_LINK_LIBRARIES "${HYPERSCAN_LINK_LIBRARIES_SHARED}"
        )
    endif()
    if(NOT TARGET Hyperscan::Static AND HYPERSCAN_LINK_LIBRARIES_STATIC)
        # Static target
        add_library(Hyperscan::Static INTERFACE IMPORTED)
        set_target_properties(Hyperscan::Static PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${HYPERSCAN_INCLUDE_DIR}"
            INTERFACE_LINK_LIBRARIES "${HYPERSCAN_LINK_LIBRARIES_STATIC}"
        )
    endif()
endif()