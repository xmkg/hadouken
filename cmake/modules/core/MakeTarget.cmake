#!/usr/bin/env cmake

# ______________________________________________________
# Contains helper functions to invoke common git commands in CMake.
# 
# @file 	MakeTarget.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

# make_targe function arguments
set(__HDK_MAKE_TARGET_OPTION_ARGS "WITH_COVERAGE;WITH_INSTALL;EXPOSE_PROJECT_METADATA;NO_AUTO_COMPILATION_UNIT;DEBUG_PRINT_PROPERTIES;AUTO_SUFFIX")
set(__HDK_MAKE_TARGET_SINGLE_VALUE_ARGS "TYPE;SUFFIX;PREFIX;NAME;OUTPUT_NAME;PARTOF;PROJECT_METADATA_PREFIX;WORKING_DIRECTORY;COVERAGE_REPORT_OUTPUT_DIRECTORY;EXCLUDE_SOURCES;EXCLUDE_HEADERS")
set(__HDK_MAKE_TARGET_MULTI_VALUE_ARGS "LINK;COMPILE_OPTIONS;COMPILE_DEFINITIONS;DEPENDS;INCLUDES;SOURCES;HEADERS;SYMBOL_VISIBILITY;COVERAGE_TARGETS;COVERAGE_LCOV_FILTER_PATTERN;COVERAGE_GCOVR_FILTER_PATTERN;ARGUMENTS;ADD_TEST_PARAMETERS;GTEST_DISCOVER_PARAMETERS;")

mark_as_advanced(__HDK_MAKE_TARGET_OPTION_ARGS)
mark_as_advanced(__HDK_MAKE_TARGET_SINGLE_VALUE_ARGS)
mark_as_advanced(__HDK_MAKE_TARGET_MULTI_VALUE_ARGS)

include(.hadouken/cmake/modules/core/detail/helper_functions.cmake)

# function hdk_make_target()

# This is a function which is created with aim of
# removing code repetition in cmake files.
# We're doing pretty much the same stuff on all of our library targets.
function(make_target)
    hdk_log_set_context("hdk.mt")
    cmake_parse_arguments(ARGS "${__HDK_MAKE_TARGET_OPTION_ARGS}" "${__HDK_MAKE_TARGET_SINGLE_VALUE_ARGS}" "${__HDK_MAKE_TARGET_MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT DEFINED ARGS_TYPE)
        message(FATAL_ERROR "make_target() requires TYPE parameter.")
    endif()

    if(NOT DEFINED ARGS_WORKING_DIRECTORY)
        set(ARGS_WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    endif()

    if(ARGS_AUTO_SUFFIX)
        # Create a name for the target
        __hdk_make_target_name(TARGET_NAME 
            NAME ${ARGS_NAME} 
            PREFIX ${ARGS_PREFIX} 
            SUFFIX ${ARGS_SUFFIX} 
            TYPE ${ARGS_TYPE}
            AUTO_SUFFIX
        )
    else()
        # Create a name for the target
        __hdk_make_target_name(TARGET_NAME 
            NAME ${ARGS_NAME} 
            PREFIX ${ARGS_PREFIX} 
            SUFFIX ${ARGS_SUFFIX} 
        )
    endif()

    hdk_capsan_name(${PROJECT_NAME} PROJECT_NAME_UPPER)
    hdk_capsan_name(${TARGET_NAME} TARGET_NAME_UPPER)

    if(${HDK_ROOT_PROJECT_NAME_UPPER}_DISABLE_${ARGS_TYPE}_TARGETS)
        hdk_log_verbose("make_target: Target ${TARGET_NAME} skipped since ${ARGS_TYPE} target build is disabled via option")
        return ()
    endif()

    if(${HDK_ROOT_PROJECT_NAME_UPPER}_WITHOUT_${PROJECT_NAME_UPPER})
        hdk_log_verbose("make_target: Target ${TARGET_NAME} skipped since project ${PROJECT_NAME} build is disabled via ${HDK_ROOT_PROJECT_NAME_UPPER}_WITHOUT_${PROJECT_NAME_UPPER} option")
        return ()
    endif()

    if(${HDK_ROOT_PROJECT_NAME_UPPER}_WITHOUT_${TARGET_NAME_UPPER})
        hdk_log_verbose("make_target: Target ${TARGET_NAME} skipped since target ${TARGET_NAME} build is disabled via ${HDK_ROOT_PROJECT_NAME_UPPER}_WITHOUT_${TARGET_NAME_UPPER} option")
        return ()
    endif()

    if(NOT ARGS_NO_AUTO_COMPILATION_UNIT OR NOT ${ARGS_NO_AUTO_COMPILATION_UNIT})
        # Gather sources of target to be created
        hdk_make_compilation_unit(COMPILATION_UNIT
            EXCLUDE_SOURCES "${ARGS_EXCLUDE_SOURCES}"
            EXCLUDE_HEADERS "${ARGS_EXCLUDE_HEADERS}"
        )

        hdk_log_trace("make_target: Target ${TARGET_NAME} headers ${HEADERS}")
        hdk_log_trace("make_target: Target ${TARGET_NAME} sources ${SOURCES}")
    endif()

    # Define target according to type
    if(${ARGS_TYPE} STREQUAL "EXECUTABLE")
        add_executable(${TARGET_NAME} ${COMPILATION_UNIT} ${ARGS_SOURCES})
    elseif(${ARGS_TYPE} STREQUAL "INTERFACE")
        add_library(${TARGET_NAME} INTERFACE)
    elseif(${ARGS_TYPE} STREQUAL "SHARED")
        add_library(${TARGET_NAME} SHARED ${COMPILATION_UNIT} ${ARGS_SOURCES})
    elseif(${ARGS_TYPE} STREQUAL "STATIC")
        add_library(${TARGET_NAME} STATIC ${COMPILATION_UNIT} ${ARGS_SOURCES})
    elseif(${ARGS_TYPE} STREQUAL "UNIT_TEST")
        add_executable(${TARGET_NAME} ${COMPILATION_UNIT} ${ARGS_SOURCES})
        target_link_libraries(${TARGET_NAME} PRIVATE ${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.test)
    elseif(${ARGS_TYPE} STREQUAL "BENCHMARK")
        add_executable(${TARGET_NAME} ${COMPILATION_UNIT} ${ARGS_SOURCES})
        target_link_libraries(${TARGET_NAME} PRIVATE ${HDK_ROOT_PROJECT_NAME}.hadouken_autotargets.benchmark)
    endif()

    # Add project's include directory to target's include directories
    __hdk_add_project_include_directory(
        TARGET_NAME ${TARGET_NAME}
        TYPE ${ARGS_TYPE}
    )

    # Make output name

    if(ARGS_OUTPUT_NAME)
        string(REPLACE "<PROJECT_NAME>" "${PROJECT_NAME}" ARGS_OUTPUT_NAME ${ARGS_OUTPUT_NAME})
        string(REPLACE "<TARGET_NAME>" "${TARGET_NAME}" ARGS_OUTPUT_NAME ${ARGS_OUTPUT_NAME})
        string(TOLOWER "${ARGS_TYPE}" TYPE_TOLOWER)
        string(REPLACE "<TARGET_TYPE>" "${TYPE_TOLOWER}" ARGS_OUTPUT_NAME ${ARGS_OUTPUT_NAME})
    endif()

    # Add othet target options
    __hdk_add_target_options(
        TARGET_NAME ${TARGET_NAME}
        TYPE ${ARGS_TYPE}
        LINK ${ARGS_LINK}
        COMPILE_OPTIONS ${ARGS_COMPILE_OPTIONS}
        COMPILE_DEFINITIONS ${ARGS_COMPILE_DEFINITIONS}
        DEPENDS ${ARGS_DEPENDS}
        PARTOF ${ARGS_PARTOF}
        SYMBOL_VISIBILITY ${ARGS_SYMBOL_VISIBILITY}
        OUTPUT_NAME ${ARGS_OUTPUT_NAME}
    )

    # Add coverage option if set
    if(ARGS_WITH_COVERAGE)    

        # WITH_COVERAGE is only meaningful for unit test and benchmark target types
        if(NOT ${ARGS_TYPE} STREQUAL "UNIT_TEST" AND NOT ${ARGS_TYPE} STREQUAL "BENCHMARK")
            message(FATAL_ERROR "WITH_COVERAGE can only be used together with UNIT_TEST and BENCHMARK targets.")
        endif()
        
        __hdk_setup_coverage_targets(
            TARGET_NAME ${TARGET_NAME} 
            LINK ${ARGS_LINK} 
            COVERAGE_TARGETS ${ARGS_COVERAGE_TARGETS} 
            COVERAGE_LCOV_FILTER_PATTERN ${ARGS_COVERAGE_LCOV_FILTER_PATTERN} 
            COVERAGE_GCOVR_FILTER_PATTERN ${ARGS_COVERAGE_GCOVR_FILTER_PATTERN}
            COVERAGE_REPORT_OUTPUT_DIRECTORY ${ARGS_COVERAGE_REPORT_OUTPUT_DIRECTORY}
            WORKING_DIRECTORY ${ARGS_WORKING_DIRECTORY}
        )
    endif()

    # Add install
    if(${ARGS_WITH_INSTALL})
        __hdk_make_install(
            TARGET_NAME ${TARGET_NAME} 
            TYPE ${ARGS_TYPE} 
        )
    endif()

    # Expose project metadata
    if(ARGS_EXPOSE_PROJECT_METADATA)
        if(${ARGS_TYPE} STREQUAL "INTERFACE" AND ( NOT DEFINED ARGS_PROJECT_METADATA_PREFIX AND NOT DEFINED ARGS_PROJECT_METADATA_SUFFIX  ))
            message(FATAL_ERROR "expose_project_metadata on INTERFACE targets require either prefix or suffix to be defined.")
        endif()
        # Project metadata exposure
        hdk_project_metadata_as_compile_defn(
            TARGET_NAME ${TARGET_NAME}
            TYPE ${ARGS_TYPE}
            PREFIX ${ARGS_PROJECT_METADATA_PREFIX}
            SUFFIX ${ARGS_PROJECT_METADATA_SUFFIX}
        )
    endif()

    # Add format target (if clang-format is available)
    if(HDK_TOOL_CLANG_FORMAT)
        add_custom_target(
            ${TARGET_NAME}.format
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            COMMAND ${HDK_TOOL_CLANG_FORMAT} -i -style=file ${COMPILATION_UNIT}
            COMMENT "Running `clang-format` on compilation unit of  `${TARGET_NAME}`"
        )

        # Project-level meta format target
        if (TARGET ${HDK_ROOT_PROJECT_NAME}.format)
            add_dependencies(${HDK_ROOT_PROJECT_NAME}.format ${TARGET_NAME}.format)
        else()
            add_custom_target(${HDK_ROOT_PROJECT_NAME}.format DEPENDS ${TARGET_NAME}.format)
        endif()

    endif() 

    # Interface targets are excluded from tidy.
    if(NOT ${ARGS_TYPE} STREQUAL "INTERFACE")
        if(CMAKE_CXX_CLANG_TIDY)
        
            # We need to gather target_link_libraries list and iterate through them.
            # For the ones which are indeed cmake targets, we need to obtain their include directories
            # and then pass them to clang-tidy.
            # Freaking tedious!

            set(CT_INCLUDE_DIRECTORIES "")
            get_target_property(CT_LINK_LIBRARIES ${TARGET_NAME} LINK_LIBRARIES)
            
            foreach(CT_LL IN LISTS CT_LINK_LIBRARIES)
                if(TARGET ${CT_LL})
                    # Get public and interface include directories of the target
                    get_target_property(CT_LL_INCLUDE_DIRECTORIES ${CT_LL} INTERFACE_INCLUDE_DIRECTORIES)
                    list(APPEND CT_INCLUDE_DIRECTORIES "-I${CT_LL_INCLUDE_DIRECTORIES}")
                endif()
            endforeach()

            # Add tidy target (if clang-tidy is available)
            add_custom_target(
                ${TARGET_NAME}.tidy
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                COMMAND ${CMAKE_CXX_CLANG_TIDY} ${COMPILATION_UNIT} -- -std=c++${CMAKE_CXX_STANDARD} ${CT_INCLUDE_DIRECTORIES}
                COMMENT "Running `clang-tidy` on compilation unit of `${TARGET_NAME}`"
            )

            # Project-level meta tidy target
            if (TARGET ${HDK_ROOT_PROJECT_NAME}.tidy)
                add_dependencies(${HDK_ROOT_PROJECT_NAME}.tidy ${TARGET_NAME}.tidy)
            else()
                add_custom_target(${HDK_ROOT_PROJECT_NAME}.tidy DEPENDS ${TARGET_NAME}.tidy)
            endif()

        endif()


        # Include what you use integration
        if(CMAKE_CXX_INCLUDE_WHAT_YOU_USE)
            # This is not required as top level CMAKE_CXX_INCLUDE_WHAT_YOU_USE implies the desired behaviour.
            #set_property(TARGET ${TARGET_NAME} PROPERTY CXX_INCLUDE_WHAT_YOU_USE ${CMAKE_CXX_INCLUDE_WHAT_YOU_USE})
        endif()
       
    endif()

    # post options
    if(${ARGS_TYPE} STREQUAL "UNIT_TEST")
        add_test(
            NAME ${TARGET_NAME}
            COMMAND ${TARGET_NAME} ${ARGS_ARGUMENTS} 
            # # COMMAND 
            WORKING_DIRECTORY ${ARGS_WORKING_DIRECTORY}
            ${ARGS_ADD_TEST_PARAMETERS}
        )
        gtest_discover_tests(${TARGET_NAME} WORKING_DIRECTORY ${ARGS_WORKING_DIRECTORY} DISCOVERY_MODE PRE_TEST ${ARGS_GTEST_DISCOVER_PARAMETERS})
    endif()

    # Print target properties for debugging purposes
    if(ARGS_DEBUG_PRINT_PROPERTIES OR ${HDK_ROOT_PROJECT_NAME_UPPER}_DEBUG_TARGET_PRINT_PROPERTIES)
        hdk_print_target_properties(${TARGET_NAME})
    endif()

endfunction()
