#!/usr/bin/env cmake

# ______________________________________________________
# Contains helper functions to invoke common git commands in CMake.
# 
# @file 	Git.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

function (hdk_git_get_branch_name RESULT)
    cmake_parse_arguments(ARGS "" "" "DIRECTORY;" ${ARGN})
    if(NOT ARGS_DIRECTORY)
        set(ARGS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()
    execute_process(
        COMMAND git symbolic-ref -q --short HEAD
        WORKING_DIRECTORY ${ARGS_DIRECTORY}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )
    set(${RESULT} ${GIT_BRANCH} PARENT_SCOPE)
endfunction()

function (hdk_git_get_head_commit_hash RESULT)
    cmake_parse_arguments(ARGS "" "" "DIRECTORY;" ${ARGN})
    if(NOT ARGS_DIRECTORY)
        set(ARGS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()
    execute_process(
        COMMAND git rev-parse --verify HEAD
        WORKING_DIRECTORY ${ARGS_DIRECTORY}
        RESULT_VARIABLE GIT_RESULT_VAR
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
  )
    if(GIT_RESULT_VAR EQUAL "0")
        set(${RESULT} ${GIT_COMMIT_HASH} PARENT_SCOPE)
    else()
        set(${RESULT} "N/A" PARENT_SCOPE)
    endif()
endfunction()

# DEFAULT = HEAD
function (hdk_git_get_tag RESULT)
    cmake_parse_arguments(ARGS "" "" "DIRECTORY;COMMIT;" ${ARGN})
    if(NOT ARGS_DIRECTORY)
        set(ARGS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    execute_process(
        COMMAND git tag --points-at ${ARGS_COMMIT}
        WORKING_DIRECTORY ${ARGS_DIRECTORY}
        OUTPUT_VARIABLE OUTPUT_VAR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

  set(${RESULT} ${OUTPUT_VAR} PARENT_SCOPE)
endfunction()

function (hdk_git_is_worktree_dirty RESULT)
    cmake_parse_arguments(ARGS "" "" "DIRECTORY;" ${ARGN})
    if(NOT ARGS_DIRECTORY)
        set(ARGS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()
    execute_process(
        COMMAND git diff-index --quiet HEAD --
        WORKING_DIRECTORY ${ARGS_DIRECTORY}
        RESULT_VARIABLE GIT_WORKTREE_DIRTY
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
  )
  
  if(GIT_WORKTREE_DIRTY)
    set(${RESULT} true PARENT_SCOPE)
  else()
    set(${RESULT} false PARENT_SCOPE)
  endif()
endfunction()

function (hdk_git_get_config RESULT)
    cmake_parse_arguments(ARGS "" "" "DIRECTORY;CONFIG_KEY;" ${ARGN})
    if(NOT ARGS_DIRECTORY)
        set(ARGS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif()
    if(NOT ARGS_CONFIG_KEY)
        message(FATAL_ERROR "GitConfigGet() requires a config key. Please specify it by adding CONFIG_KEY argument to your function call.")
    endif()
    execute_process(
        COMMAND git config --get ${ARGS_CONFIG_KEY}
        WORKING_DIRECTORY ${ARGS_DIRECTORY}
        OUTPUT_VARIABLE GIT_CONFIG_VALUE
        OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  set(${RESULT} ${GIT_CONFIG_VALUE} PARENT_SCOPE)
endfunction()




function(git_print_status)
    hdk_log_deprecated("`git_print_status` is deprecated and will be removed in future releases. Use `hdk_git_print_status` instead.")
    hdk_git_print_status()
endfunction()

function (hdk_git_print_status)
    hdk_log_set_context("hadouken.git")
    hdk_log_status("VCS (git) status")

    hdk_git_get_branch_name(
        GIT_BRANCH_NAME
        DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    hdk_git_get_head_commit_hash(
        GIT_HEAD_COMMIT
        DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    hdk_git_get_tag(
        GIT_TAGS
        DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    hdk_git_is_worktree_dirty(
        GIT_WORKTREE_STATUS
        DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    hdk_log_status("\tBranch: ${GIT_BRANCH_NAME}")
    hdk_log_status("\tTag: ${GIT_TAGS}")
    hdk_log_status("\tCommit: ${GIT_HEAD_COMMIT}")
    hdk_log_status("\tDirty: ${GIT_WORKTREE_STATUS}")
endfunction()

function (hdk_git_metadata_as_compile_defn)
    cmake_parse_arguments(ARGS "" "PREFIX;" "" ${ARGN})

    hdk_git_get_branch_name(
        GIT_BRANCH_NAME
        DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    hdk_git_get_head_commit_hash(
        GIT_HEAD_COMMIT_HASH
        DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    hdk_git_is_worktree_dirty(
        GIT_IS_WORKTREE_DIRTY
        DIRECTORY ${CMAKE_SOURCE_DIR}
    )

    hdk_git_get_config(
        GIT_CONFIG_USER_NAME
        DIRECTORY ${CMAKE_SOURCE_DIR}
        CONFIG_KEY user.name    
    )

    hdk_git_get_config(
        GIT_CONFIG_USER_EMAIL
        DIRECTORY ${CMAKE_SOURCE_DIR}
        CONFIG_KEY user.email    
    )

    if(ARGS_PREFIX)
        string(TOUPPER ${ARGS_PREFIX} ARGS_PREFIX)

        # Maket it C preprocessor macro friently
        string(REGEX REPLACE "[^a-zA-Z0-9]" "_" ARGS_PREFIX ${ARGS_PREFIX})
    endif()

    add_compile_definitions(${ARGS_PREFIX}GIT_BRANCH_NAME="${GIT_BRANCH_NAME}")
    add_compile_definitions(${ARGS_PREFIX}GIT_COMMIT_ID="${GIT_HEAD_COMMIT_HASH}")
    add_compile_definitions(${ARGS_PREFIX}GIT_WORKTREE_DIRTY="${GIT_IS_WORKTREE_DIRTY}")
    add_compile_definitions(${ARGS_PREFIX}GIT_AUTHOR_NAME="${GIT_CONFIG_USER_NAME}")
    add_compile_definitions(${ARGS_PREFIX}GIT_AUTHOR_EMAIL="${GIT_CONFIG_USER_EMAIL}")
endfunction()


function(hdk_target_needs_git_lfs_files TARGET LFS_ROOT LFS_FILE_LIST)

    if(NOT TARGET ${TARGET})
        hdk_log_err("${TARGET} is not a valid CMake target!")
    endif()

    string(REPLACE "\r" "" LFS_FILE_LIST "${LFS_FILE_LIST}")
    string(REPLACE "\n" "" LFS_FILE_LIST "${LFS_FILE_LIST}")
    string(REPLACE " " "" LFS_FILE_LIST "${LFS_FILE_LIST}")
    string(REPLACE ";" "," LFS_FILE_LIST "${LFS_FILE_LIST}")

    get_target_property(TARGET_BINARY_DIR ${TARGET} BINARY_DIR)

    add_custom_command(
        OUTPUT ${TARGET_BINARY_DIR}/.has_${TARGET}_lfs_files
        COMMAND git -C "${LFS_ROOT}" lfs pull --include="${LFS_FILE_LIST}"
        COMMAND touch ${TARGET_BINARY_DIR}/.has_${TARGET}_lfs_files
        COMMENT "Fetching LFS files for ${TARGET}"
    )

    add_custom_target(
        ${TARGET}.git-lfs-needs
        DEPENDS ${TARGET_BINARY_DIR}/.has_${TARGET}_lfs_files
    )
    add_dependencies(${TARGET} ${TARGET}.git-lfs-needs)
endfunction()
