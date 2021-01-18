#!/usr/bin/env cmake

# ______________________________________________________
# Logging utilities for Hadouken.
# 
# @file 	Log.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	17.01.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

function(hdk_log LEVEL MESSAGE)
    message(${LEVEL} ${MESSAGE})
endfunction()

# FATAL_ERROR
# CMake Error, stop processing and generation.

# SEND_ERROR
# CMake Error, continue processing, but skip generation.

# WARNING
# CMake Warning, continue processing.

# AUTHOR_WARNING
# CMake Warning (dev), continue processing.

# DEPRECATION
# CMake Deprecation Error or Warning if variable CMAKE_ERROR_DEPRECATED or CMAKE_WARN_DEPRECATED is enabled, respectively, else no message.

# (none) or NOTICE
# Important message printed to stderr to attract user’s attention.

# STATUS
# The main interesting messages that project users might be interested in. Ideally these should be concise, no more than a single line, but still informative.

# VERBOSE
# Detailed informational messages intended for project users. These messages should provide additional details that won’t be of interest in most cases, but which may be useful to those building the project when they want deeper insight into what’s happening.

# DEBUG
# Detailed informational messages intended for developers working on the project itself as opposed to users who just want to build it. These messages will not typically be of interest to other users building the project and will often be closely related to internal implementation details.

# TRACE
# Fine-grained messages with very low-level implementation details. Messages using this log level would normally only be temporary and would expect to be removed before releasing the project, packaging up the files, etc.

function(hdk_log_err MESSAGE)
    hdk_log(FATAL_ERROR ${MESSAGE})
endfunction()

function(hdk_log_warn MESSAGE)
    hdk_log(WARNING ${MESSAGE})
endfunction()

function(hdk_log_author_warn MESSAGE)
    hdk_log(AUTHOR_WARNING ${MESSAGE})
endfunction()

function(hdk_log_deprecated MESSAGE)
    hdk_log(DEPRECATION ${MESSAGE})
endfunction()

function(hdk_log_notice MESSAGE)
    hdk_log(NOTICE ${MESSAGE})
endfunction()

function(hdk_log_status MESSAGE)
    hdk_log(STATUS ${MESSAGE})
endfunction()

function(hdk_log_verbose MESSAGE)
    hdk_log(VERBOSE ${MESSAGE})
endfunction()

function(hdk_log_debug MESSAGE)
    hdk_log(DEBUG ${MESSAGE})
endfunction()

function(hdk_log_trace MESSAGE)
    hdk_log(TRACE ${MESSAGE})
endfunction()

function (hdk_log_set_context CONTEXT)
    list(APPEND CMAKE_MESSAGE_CONTEXT "${CONTEXT}")
    # Propogate to top
    set(CMAKE_MESSAGE_CONTEXT "${CMAKE_MESSAGE_CONTEXT}" PARENT_SCOPE)
endfunction()

function(hdk_log_unset_context)
    list(POP_BACK CMAKE_MESSAGE_CONTEXT)
    set(CMAKE_MESSAGE_CONTEXT "${CMAKE_MESSAGE_CONTEXT}" PARENT_SCOPE)
endfunction()

function (hdk_log_indent LEVEL)
    foreach(idx RANGE ${LEVEL})
        list(APPEND CMAKE_MESSAGE_INDENT " ")
    endforeach()
    set(CMAKE_MESSAGE_INDENT "${CMAKE_MESSAGE_INDENT}" PARENT_SCOPE)
endfunction()

function (hdk_log_unindent LEVEL)
    foreach(idx RANGE ${LEVEL})
        list(POP_BACK CMAKE_MESSAGE_INDENT)
    endforeach()
    set(CMAKE_MESSAGE_INDENT "${CMAKE_MESSAGE_INDENT}" PARENT_SCOPE)
endfunction()

# function hdk_log_reset_indent(LEVEL)
#     foreach(idx RANGE ${LEVEL})
#         list(POP_BACK CMAKE_MESSAGE_INDENT)
#     endforeach()
# endfunction()

# list(POP_BACK CMAKE_MESSAGE_INDENT)