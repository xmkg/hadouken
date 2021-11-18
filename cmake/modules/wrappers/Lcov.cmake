# Copyright (c) 2012 - 2017, Lars Bilke
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# CHANGES:
#
# 2012-01-31, Lars Bilke
# - Enable Code Coverage
#
# 2013-09-17, Joakim Söderberg
# - Added support for Clang.
# - Some additional usage instructions.
#
#!/usr/bin/env cmake

# 2016-02-03, Lars Bilke
# - Refactored functions to use named parameters
#
# 2017-06-02, Lars Bilke
# - Merged with modified version from github.com/ufz/ogs
#
#
# USAGE:
#
# 1. Copy this file into your cmake modules path.
#
# 2. Add the following line to your CMakeLists.txt:
#      include(CodeCoverage)
#
# 3. Append necessary compiler flags:
#      APPEND_COVERAGE_COMPILER_FLAGS()
#
# 3.a (OPTIONAL) Set appropriate optimization flags, e.g. -O0, -O1 or -Og
#
# 4. If you need to exclude additional directories from the report, specify them
#    using the COVERAGE_LCOV_EXCLUDES variable before calling SETUP_TARGET_FOR_COVERAGE_LCOV.
#    Example:
#      set(COVERAGE_LCOV_EXCLUDES 'dir1/*' 'dir2/*')
#
# 5. Use the functions described below to create a custom make target which
#    runs your test executable and produces a code coverage report.
#
# 6. Build a Debug build:
#      cmake -DCMAKE_BUILD_TYPE=Debug ..
#      make
#      make my_coverage_target
#

include(.hadouken/cmake/modules/wrappers/detail/coverage_set_variables.cmake)

if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV OR ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV)

    include(CMakeParseArguments)

    # Check prereqs
    # find_program(LCOV_PATH  NAMES lcov lcov.bat lcov.exe lcov.perl REQUIRED)

    if(${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV AND ${HDK_ROOT_PROJECT_NAME_UPPER}_TOOLCONF_USE_LLVM_COV)
        message(FATAL_ERROR "Due to compatibility issues you cannot use both of gcov and llvm-cov together in project! Aborting...")
    endif()

    set_common_variables()
    
endif()


# Defines a target for running and collection code coverage information
# Builds dependencies, runs the given executable and outputs reports.
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# SETUP_TARGET_FOR_COVERAGE_LCOV(
#     NAME testrunner_coverage                    # New target name
#     EXECUTABLE testrunner -j ${PROCESSOR_COUNT} # Executable in PROJECT_BINARY_DIR
#     DEPENDENCIES testrunner                     # Dependencies to build first
# )
function(SETUP_TARGET_FOR_COVERAGE_LCOV)

    set(options NONE)
    set(oneValueArgs NAME DIRECTORY FILTER_PATTERN OUTPUT_DIRECTORY WORKING_DIRECTORY)
    set(multiValueArgs EXECUTABLE EXECUTABLE_ARGS DEPENDENCIES LCOV_ARGS GENHTML_ARGS)
    cmake_parse_arguments(Coverage "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT HDK_TOOLPATH_COVERAGE_EXECUTABLE)
        message(FATAL_ERROR "coverage executable not found! Aborting...")
    endif()

    if(NOT Coverage_OUTPUT_DIRECTORY)
        set(Coverage_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
    endif()

    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${Coverage_OUTPUT_DIRECTORY})
    # Setup target
    add_custom_target(${Coverage_NAME}
        DEPENDS ${Coverage_EXECUTABLE}
        # # Create output directory
        # COMMAND ${CMAKE_COMMAND} -E make_directory ${Coverage_OUTPUT_DIRECTORY}
        # Cleanup lcov
        COMMAND ${HDK_TOOL_LCOV} ${Coverage_LCOV_ARGS} --config-file ${CMAKE_SOURCE_DIR}/.lcovrc --gcov-tool ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} -directory ${Coverage_DIRECTORY} --zerocounters
        # Create baseline to make sure untouched files show up in the report
        COMMAND ${HDK_TOOL_LCOV} ${Coverage_LCOV_ARGS} --config-file ${CMAKE_SOURCE_DIR}/.lcovrc --gcov-tool ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} -c -i -d ${Coverage_DIRECTORY} -o ${Coverage_NAME}.base

        # If unit test; 
        #   Gather link targets
        #   Exclude .test target
        #   Determine base path of link targets
        #   Filter by base path

        # Run tests
        COMMAND ${Coverage_EXECUTABLE} ${Coverage_EXECUTABLE_ARGS}

        # Capturing lcov counters and generating report
        COMMAND ${HDK_TOOL_LCOV} ${Coverage_LCOV_ARGS} --config-file ${CMAKE_SOURCE_DIR}/.lcovrc --gcov-tool ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} --directory ${Coverage_DIRECTORY} --capture --output-file ${Coverage_NAME}.info
        # add baseline counters
        COMMAND ${HDK_TOOL_LCOV} ${Coverage_LCOV_ARGS} --config-file ${CMAKE_SOURCE_DIR}/.lcovrc --gcov-tool ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} -a ${Coverage_NAME}.base -a ${Coverage_NAME}.info --output-file ${Coverage_NAME}.total
        COMMAND ${HDK_TOOL_LCOV} ${Coverage_LCOV_ARGS} --config-file ${CMAKE_SOURCE_DIR}/.lcovrc --gcov-tool ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} --remove ${Coverage_NAME}.total ${COVERAGE_LCOV_EXCLUDES} --output-file ${Coverage_OUTPUT_DIRECTORY}/${Coverage_NAME}.info.cleaned
        # Apply specified filter pattern to the final result
        COMMAND ${HDK_TOOL_LCOV} --config-file ${CMAKE_SOURCE_DIR}/.lcovrc --gcov-tool ${HDK_TOOLPATH_COVERAGE_EXECUTABLE} -e ${Coverage_OUTPUT_DIRECTORY}/${Coverage_NAME}.info.cleaned '${Coverage_FILTER_PATTERN}' --output-file ${Coverage_OUTPUT_DIRECTORY}/${Coverage_NAME}.info.cleaned
        # Generating HTML 
        COMMAND ${GENHTML_PATH} --config-file ${CMAKE_SOURCE_DIR}/.lcovrc ${Coverage_GENHTML_ARGS} -o ${Coverage_OUTPUT_DIRECTORY}/${Coverage_NAME} ${Coverage_OUTPUT_DIRECTORY}/${Coverage_NAME}.info.cleaned
        # Erase intermediate artifacts
        COMMAND ${CMAKE_COMMAND} -E remove ${Coverage_NAME}.base ${Coverage_NAME}.total ${Coverage_OUTPUT_DIRECTORY}/${Coverage_NAME}.info.cleaned

        WORKING_DIRECTORY ${Coverage_WORKING_DIRECTORY}
        DEPENDS ${Coverage_DEPENDENCIES}
        COMMENT "Resetting code coverage counters to zero.\nProcessing code coverage counters and generating report."
    )

    # Show where to find the lcov info report
    add_custom_command(TARGET ${Coverage_NAME} POST_BUILD
        COMMAND ;
        COMMENT "Lcov code coverage info report saved in ${Coverage_NAME}.info."
    )

    # Show info where to find the report
    add_custom_command(TARGET ${Coverage_NAME} POST_BUILD
        COMMAND ;
        COMMENT "Open ${Coverage_OUTPUT_DIRECTORY}/${Coverage_NAME}/index.html in your browser to view the coverage report."
    )

endfunction() # SETUP_TARGET_FOR_COVERAGE_LCOV