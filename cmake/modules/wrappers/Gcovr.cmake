#!/usr/bin/env cmake

# ______________________________________________________
# GCovr CMake wrapper module
# 
# @file 	Gcovr.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.11.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV OR ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV)
    include(CMakeParseArguments)
    # Check prereqs
    find_package(Python COMPONENTS Interpreter REQUIRED QUIET)

    if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV AND ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV)
        hdk_log_err("You cannot use both of gcov and llvm-cov together in project due to compatibility issues. Please enable only one of them.")
    endif()
endif()

function(hdk_setup_gcovr_coverage_target)
    cmake_parse_arguments(ARGS "" "NAME;REPORT_TYPE;FILTER_PATTERN;OUTPUT_DIRECTORY;WORKING_DIRECTORY" "EXECUTABLE;EXECUTABLE_ARGS;DEPENDENCIES;EXCLUDES;FILTER_PATTERNS;" ${ARGN})
    hdk_function_required_arguments(ARGS_NAME ARGS_REPORT_TYPE)
    hdk_unset_if_empty(ARGS_FILTER_PATTERN)

    if(NOT Python_FOUND)
        hdk_fnlog_err("`Python` is required for GCovR but is not found! aborting.")
    endif()

    if(NOT HDK_TOOLPATH_COVERAGE_EXECUTABLE)
        hdk_fnlog_err("Coverage executable not set! enable either gcov or llvm-cov. Alternatively; enable `coverage` for auto detection based on toolchain.")
    endif()

    if(NOT HDK_TOOL_GCOVR)
        hdk_fnlog_err("gcovr not found! Aborting...")
    endif() # NOT HDK_TOOL_GCOVR

    if(NOT ARGS_OUTPUT_DIRECTORY)
        set(ARGS_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
    endif()

    # Combine excludes to several -e arguments
    set(LVAR_GCOVR_EXCLUDES "")
    foreach(EXCLUDE ${ARGS_EXCLUDES})
        string(REPLACE "*" "\\*" EXCLUDE_REPLACED ${EXCLUDE})
        list(APPEND LVAR_GCOVR_EXCLUDES "-e")
        list(APPEND LVAR_GCOVR_EXCLUDES "${EXCLUDE_REPLACED}")
    endforeach() 

    # Will keep all provided filter parameters 
    # set(LVAR_FILTER_PATTERNS_PARAMETERIZED "")

    # Backwards compatibility
    if(DEFINED ARGS_FILTER_PATTERN)
        set(LVAR_FILTER_PATTERNS_PARAMETERIZED ${LVAR_FILTER_PATTERNS_PARAMETERIZED} --filter '${ARGS_FILTER_PATTERN}')
    else()
        # Expand FILTER_PATTERNS into --filter <arg> list
        foreach(filter_pattern IN LISTS ARGS_FILTER_PATTERNS)
            set(LVAR_FILTER_PATTERNS_PARAMETERIZED ${LVAR_FILTER_PATTERNS_PARAMETERIZED} --filter '${filter_pattern}')
        endforeach()
    endif()
 
     
    # Set target type based variables
    if(ARGS_REPORT_TYPE STREQUAL "HTML")
        set(LVAR_REPORT_TYPE --html --html-details --html-title '${ARGS_NAME} ${${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_COVERAGE_HTML_TITLE}')
        set(LVAR_OUTPUT_FILE ${ARGS_OUTPUT_DIRECTORY}/${ARGS_NAME}/index.html)
    elseif(ARGS_REPORT_TYPE STREQUAL "XML")
        set(LVAR_REPORT_TYPE --xml)
        set(LVAR_OUTPUT_FILE ${ARGS_OUTPUT_DIRECTORY}/${ARGS_NAME}/report.xml)
    else()
        hdk_fnlog_err("unsupported report type ${ARGS_REPORT_TYPE}")
    endif()

    # Primary target to generate the report
    add_custom_target(${ARGS_NAME}
        # Run tests
        ${ARGS_EXECUTABLE} ${ARGS_EXECUTABLE_ARGS}
        # Create output directory
        COMMAND ${CMAKE_COMMAND} -E make_directory ${ARGS_OUTPUT_DIRECTORY}
        # Create folder
        COMMAND ${CMAKE_COMMAND} -E make_directory ${ARGS_OUTPUT_DIRECTORY}/${ARGS_NAME}

        # Running gcovr
        COMMAND ${Python_EXECUTABLE} ${HDK_TOOL_GCOVR} ${LVAR_REPORT_TYPE}
            --gcov-executable ${HDK_TOOLPATH_COVERAGE_EXECUTABLE}
            --root ${HDK_ROOT_PROJECT_SOURCE_DIR} ${GCOVR_EXCLUDES}
            --object-directory=${PROJECT_BINARY_DIR}
            ${LVAR_FILTER_PATTERNS_PARAMETERIZED}
            --output ${LVAR_OUTPUT_FILE}
        WORKING_DIRECTORY ${ARGS_WORKING_DIRECTORY}
        DEPENDS ${ARGS_DEPENDENCIES}
        COMMENT "Running gcovr to produce HTML code coverage report."
    )

    # Show info where to find the report
    if(ARGS_REPORT_TYPE STREQUAL "HTML")
        add_custom_command(TARGET ${ARGS_NAME} POST_BUILD
            COMMAND ;
            COMMENT "Open ${LVAR_OUTPUT_FILE} in your browser to view the coverage report."
        )
    elseif(ARGS_REPORT_TYPE STREQUAL "XML")
        add_custom_command(TARGET ${ARGS_NAME} POST_BUILD
            COMMAND ;
            COMMENT "Cobertura code coverage report saved in ${LVAR_OUTPUT_FILE}."
        )
    endif()
endfunction()


