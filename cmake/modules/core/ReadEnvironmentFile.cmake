#!/usr/bin/env cmake

# ______________________________________________________
# CMake module for reading dotenv files.
# 
# @file 	ReadEnvironmentFile.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	18.01.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________


# Read an environment file and declare each environment
# variable defined in it with set(...) cmake function.
function(hdk_read_environment_file ENVIRONMENT_FILE_NAME PREFIX SUFFIX)

    file(STRINGS ${ENVIRONMENT_FILE_NAME} PROJECT_METADATAS ENCODING UTF-8)

    foreach(ENV_VAR_DECL IN LISTS PROJECT_METADATAS)
        # Trim begin and end
        string(STRIP ENV_VAR_DECL ${ENV_VAR_DECL})

        # Skip empty lines
        string(LENGTH ENV_VAR_DECL ENV_VAR_DECL_LEN)
        if(ENV_VAR_DECL_LEN EQUAL 0)
            continue()
        endif()

        # Skip comments
        string(SUBSTRING ${ENV_VAR_DECL} 0 1 ENV_VAR_DECL_FC)

        if(ENV_VAR_DECL_FC STREQUAL "#")
            continue()
        endif()

        # Convert environment variable declaration to cmake list
        string(REPLACE "=" ";" ENV_VAR_SPLIT ${ENV_VAR_DECL})

        list(GET ENV_VAR_SPLIT 0 ENV_VAR_NAME)
        list(GET ENV_VAR_SPLIT 1 ENV_VAR_VALUE)

        # Replace quotes in environment variable values
        string(REPLACE "\"" "" ENV_VAR_VALUE ${ENV_VAR_VALUE})

        set(${PREFIX}${ENV_VAR_NAME}${SUFFIX} ${ENV_VAR_VALUE} PARENT_SCOPE)
    endforeach()
endfunction()