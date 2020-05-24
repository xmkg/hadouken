#!/usr/bin/env cmake

# ______________________________________________________
# Contains helper functions to invoke common git commands in CMake.
# 
# @file 	BuildVariant.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include(CMakeDetermineCCompiler)
include(CMakeDetermineCXXCompiler)

message(STATUS "\t[*] Setting up build details")

if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "\t\tBuild variant is not specified. Assuming `RelWithDebugInfo`.")
  set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif()

message(STATUS "\t\tBuild type: ${CMAKE_BUILD_TYPE}")

set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g -DNDEBUG")
set(CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG")

if(CMAKE_CXX_COMPILER_ID MATCHES "[gG][nN][uU]")
  message(STATUS "\t\tCompiler: GCC ${CMAKE_CXX_COMPILER_VERSION}")
  include(buildvariant/BuildVariant_GCC)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "[cC][lL][aA][nN][gG]")
  message(STATUS "\t\tCompiler: Clang ${CMAKE_CXX_COMPILER_VERSION}")
  include(buildvariant/BuildVariant_Clang)
elseif(CMAKE_C_COMPILER_ID MATCHES "[cC][lL][aA][nN][gG]")
  message(STATUS "\t\tCompiler: Clang ${CMAKE_CXX_COMPILER_VERSION}")
  include(buildvariant/BuildVariant_Clang)
endif()


if((CMAKE_BUILD_TYPE MATCHES RelWithDebInfo) OR (CMAKE_BUILD_TYPE MATCHES Release))
  message(STATUS "\t\t#########################################################################")
  message(STATUS "\t\tBEWARE: As this is a release build, warnings will be treated as errors.")
  message(STATUS "\t\t#########################################################################")
  set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic ${EXTENDED_WARNINGS} -Werror ${EXCLUDED_WARNINGS} ${EXCLUDED_WERRORS}")
else()
  message(STATUS "\t\t#########################################################################")
  message(STATUS "\t\tNOTE: In debug builds, -Werror is disabled in order to not frustate you.\n\t\tDO NOT MERGE CODE WHICH PRODUCES WARNINGS!\n\t\tRelease build will fail on warning.")
  message(STATUS "\t\t#########################################################################")
  set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic ${EXTENDED_WARNINGS} ${WARN_BUT_NO_ERROR} ${EXCLUDED_WARNINGS}")
endif()

message(STATUS "\t\t[*] CXX Flags")
message(STATUS "\t\t\t(any):     ${CMAKE_CXX_FLAGS}")
message(STATUS "\t\t\t(debug):   ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "\t\t\t(release): ${CMAKE_CXX_FLAGS_RELEASE}")

message(STATUS "\t[✔] Build details are set.")


function (build_variant_export_to_macro)
    cmake_parse_arguments(ARGS "" "PREFIX;" "" ${ARGN})

    if(ARGS_PREFIX)
        string(TOUPPER ${ARGS_PREFIX} ARGS_PREFIX)

        # Maket it C preprocessor macro friently
        string(REGEX REPLACE "[^a-zA-Z0-9]" "_" ARGS_PREFIX ${ARGS_PREFIX})
    endif()

    if(CMAKE_BUILD_TYPE MATCHES Debug)
      add_compile_definitions(${ARGS_PREFIX}DEBUG=1)
    else()
      # Other build types are considered non-debug
      add_compile_definitions(${ARGS_PREFIX}NDEBUG=1)
    endif()
endfunction()