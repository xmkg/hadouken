#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for copying a CMake target's artifact to some destination
# on events.
# 
# @file 	CopyTargetArtifact.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	18.01.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________


function(hdk_copy_target_artifact_to)
    cmake_parse_arguments(ARGS "" "TARGET_NAME;DESTINATION;STEP;" "" ${ARGN} )

    if(NOT DEFINED ARGS_TARGET_NAME)
        message(FATAL_ERROR "hdk_copy_target_artifact_to() requires TARGET_NAME parameter.")
    endif()


    if(NOT DEFINED ARGS_STEP)
        message(FATAL_ERROR "hdk_copy_target_artifact_to() requires ARGS_STEP parameter.")
    endif()

    if(NOT DEFINED ARGS_DESTINATION)
        message(FATAL_ERROR "hdk_copy_target_artifact_to() requires DESTINATION parameter.")
    endif()

    add_custom_command(TARGET ${ARGS_TARGET_NAME} ${ARGS_STEP}
        COMMAND "${CMAKE_COMMAND}" -E copy 
        "$<TARGET_FILE:${ARGS_TARGET_NAME}>"
        "${ARGS_DESTINATION}/$<TARGET_FILE_NAME:${ARGS_TARGET_NAME}>" 
        COMMENT "Copying `${ARGS_TARGET_NAME}` to output directory"
    )
endfunction()