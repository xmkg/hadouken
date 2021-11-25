#!/usr/bin/env cmake

# ______________________________________________________
# A helper function to create CMake components.
# 
# @file 	MakeTarget.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	10.04.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include_guard(DIRECTORY)

include(.hadouken/cmake/modules/core/MakeTarget.cmake)

hdk_list_transform_prepend(__HDK_MAKE_TARGET_OPTION_ARGS __HDK_MAKE_COMPONENT_OPTION_ARGS ALL_)
hdk_list_transform_prepend(__HDK_MAKE_TARGET_SINGLE_VALUE_ARGS __HDK_MAKE_COMPONENT_SINGLE_VALUE_ARGS ALL_)
hdk_list_transform_prepend(__HDK_MAKE_TARGET_MULTI_VALUE_ARGS __HDK_MAKE_COMPONENT_MULTI_VALUE_ARGS ALL_)


mark_as_advanced(__HDK_MAKE_COMPONENT_OPTION_ARGS)
mark_as_advanced(__HDK_MAKE_COMPONENT_SINGLE_VALUE_ARGS)
mark_as_advanced(__HDK_MAKE_COMPONENT_MULTI_VALUE_ARGS)


list(APPEND __HDK_MAKE_COMPONENT_SINGLE_VALUE_ARGS VERSION DESCRIPTION HOMEPAGE_URL)
list(APPEND __HDK_MAKE_COMPONENT_MULTI_VALUE_ARGS "LANGUAGES;TARGET")


#[=======================================================================[.rst:
    make_component
    ------------------- 
    Visibility level: Public (API)

    Create a component with respect to given targets

    This function creates a project and specified targets for it in a single call.
    The common variables between the targets can be given by prefixing ALL_ to the 
    standard make_target arguments.

    .. code-block:: cmake
        make_component(
            example.component2
            VERSION 0.1.0

            TARGET  TYPE STATIC
                    LINK example.component4.static 
                    SUFFIX .static

            TARGET  TYPE SHARED
                    LINK example.component4.shared
                    SUFFIX .shared
                    
            ALL_LINK PUBLIC example.component1 
                            example.component3
                    PRIVATE boost::boost
            
            ALL_WITH_INSTALL
        )

    Note: This function is private and intended to be used internally. Do not call this directly.
#]=======================================================================]
function(make_component COMPONENT_NAME)
    hdk_log_set_context("hdk.mc")

    cmake_parse_arguments(MAKE_COMPONENT_ARGS "${__HDK_MAKE_COMPONENT_OPTION_ARGS}" "${__HDK_MAKE_COMPONENT_SINGLE_VALUE_ARGS}" "${__HDK_MAKE_COMPONENT_MULTI_VALUE_ARGS}" ${ARGN})

    if(NOT DEFINED COMPONENT_NAME)
        hdk_log_err("make_component() requires COMPONENT_NAME parameter to be present")
    endif() 

    if(NOT DEFINED MAKE_COMPONENT_ARGS_TARGET)
        hdk_log_err("make_component() [${MAKE_COMPONENT_ARGS_COMPONENT_NAME}]: make_component() requires at least one TARGET parameter")
    endif()

    if(NOT DEFINED MAKE_COMPONENT_ARGS_VERSION)
        if(HDK_ROOT_PROJECT_VERSION)
            set(MAKE_COMPONENT_ARGS_VERSION ${HDK_ROOT_PROJECT_VERSION})
        else()
            set(MAKE_COMPONENT_ARGS_VERSION 1.0.0)
        endif()
    endif()

    if(NOT DEFINED MAKE_COMPONENT_ARGS_DESCRIPTION)
        if(HDK_ROOT_PROJECT_DESCRIPTION)
            set(MAKE_COMPONENT_ARGS_DESCRIPTION ${HDK_ROOT_PROJECT_DESCRIPTION})
        else()
            set(MAKE_COMPONENT_ARGS_DESCRIPTION "N/A")
        endif()
    endif()

    if(NOT DEFINED MAKE_COMPONENT_ARGS_HOMEPAGE_URL)
        if(HDK_ROOT_PROJECT_HOMEPAGE_URL)
            set(MAKE_COMPONENT_ARGS_HOMEPAGE_URL ${HDK_ROOT_PROJECT_HOMEPAGE_URL})
        else()
            set(MAKE_COMPONENT_ARGS_HOMEPAGE_URL "N/A")
        endif()
    endif()

    if(NOT DEFINED MAKE_COMPONENT_ARGS_LANGUAGES)
        if(HDK_ROOT_PROJECT_LANGUAGES)
            set(MAKE_COMPONENT_ARGS_LANGUAGES ${HDK_ROOT_PROJECT_LANGUAGES})
        else()
            set(MAKE_COMPONENT_ARGS_LANGUAGES C CXX)
        endif()
    endif()

    if(DEFINED MAKE_COMPONENT_ARGS_UNPARSED_ARGUMENTS)
        hdk_log_warn("make_component: Component ${COMPONENT_NAME} has stray arguments: ${MAKE_COMPONENT_ARGS_UNPARSED_ARGUMENTS}")
    endif()

    hdk_capsan_name(COMPONENT_NAME COMPONENT_NAME_UPPER)

    if(${HDK_ROOT_PROJECT_NAME_UPPER}_WITHOUT_${COMPONENT_NAME_UPPER})
        hdk_log_verbose("make_component: Project ${COMPONENT_NAME} skipped since project ${COMPONENT_NAME} build is disabled via ${HDK_ROOT_PROJECT_NAME_UPPER}_WITHOUT_${COMPONENT_NAME_UPPER} option")
        return ()
    endif()

    # Define a project for the component
    project(${COMPONENT_NAME}
        VERSION ${MAKE_COMPONENT_ARGS_VERSION}
        DESCRIPTION ${MAKE_COMPONENT_ARGS_DESCRIPTION}
        HOMEPAGE_URL ${MAKE_COMPONENT_ARGS_HOMEPAGE_URL}
        LANGUAGES ${MAKE_COMPONENT_ARGS_LANGUAGES}
    )

    hdk_log_trace("make_component: created project ${PROJECT_NAME} ${PROJECT_VERSION} ${PROJECT_DESCRIPTION} ${PROJECT_HOMEPAGE_URL} ${PROJECT_LANGUAGES}")

    ####################################################################################
    # Aggregate common arguments into the list
    set(ALL_TARGET_PARAMETERS "")

    # Iterate over all available non-option make_target() parameter names
    foreach (_variableName IN LISTS __HDK_MAKE_TARGET_SINGLE_VALUE_ARGS __HDK_MAKE_TARGET_MULTI_VALUE_ARGS)
        hdk_log_verbose("make_component: Checking variable ${_variableName}")
        # Check if argument is present
        if(NOT DEFINED MAKE_COMPONENT_ARGS_ALL_${_variableName})
            continue()
        endif()
        string(REPLACE "MAKE_COMPONENT_ARGS_ALL_"  "" NEW_VAR_NAME ${_variableName})
        hdk_log_verbose("make_component: found defined ALL argument -> MAKE_COMPONENT_ARGS_ALL_${_variableName} : ${MAKE_COMPONENT_ARGS_ALL_${_variableName}} : resulting var name ${NEW_VAR_NAME}")
        list(APPEND ALL_TARGET_PARAMETERS ${NEW_VAR_NAME})
        list(APPEND ALL_TARGET_PARAMETERS ${MAKE_COMPONENT_ARGS_ALL_${_variableName}})
    endforeach()

    # Iterate over all available option make_target() parameter names
    foreach (_variableName IN LISTS __HDK_MAKE_TARGET_OPTION_ARGS)
        hdk_log_verbose("make_component: Checking variable ${_variableName}")
        # Check if argument is present
        if(NOT DEFINED MAKE_COMPONENT_ARGS_ALL_${_variableName})
            continue()
        endif()
        
        string(REPLACE "MAKE_COMPONENT_ARGS_ALL_"  "" NEW_VAR_NAME ${_variableName})
        hdk_log_verbose("make_component: found defined ALL argument -> MAKE_COMPONENT_ARGS_ALL_${_variableName} : ${MAKE_COMPONENT_ARGS_ALL_${_variableName}} : resulting var name ${NEW_VAR_NAME}")
        # (mgilor): This is a little hack to omit booleans
        # with false values. Their presence in argument list
        # interpreted as true when forwarded, even though
        # their value is FALSE. So, we have to filter them out.
        if(NOT "${MAKE_COMPONENT_ARGS_ALL_${_variableName}}" STREQUAL "FALSE")
            hdk_log_verbose("make_component: Added ${NEW_VAR_NAME}=${MAKE_COMPONENT_ARGS_ALL_${_variableName}} option common variables list")
            list(APPEND ALL_TARGET_PARAMETERS ${NEW_VAR_NAME})
            # (mgilor): Option parameters require no value, so value is omitted here
        endif()
    endforeach()
    ####################################################################################

    set(CURRENT_TARGET_PARAMETERS, "")
    list(LENGTH MAKE_COMPONENT_ARGS_TARGET TARGET_LENGTH)
    MATH(EXPR TARGET_LAST_ELEM_IDX "${TARGET_LENGTH}-1")
    set(TARGET_INDEX 0)
    while(TARGET_INDEX LESS TARGET_LENGTH)
        # Retrieve current list element
        list(GET MAKE_COMPONENT_ARGS_TARGET ${TARGET_INDEX} TARGET_CURRENT)
        if(TARGET_CURRENT STREQUAL "TYPE" OR TARGET_INDEX EQUAL TARGET_LAST_ELEM_IDX)

            if(TARGET_INDEX EQUAL TARGET_LAST_ELEM_IDX)
                hdk_log_trace("make_component: on last target element")
                # If we're at the last argument, append it to the list as well.
                list(APPEND CURRENT_TARGET_PARAMETERS ${TARGET_CURRENT})
            endif()

            list(LENGTH CURRENT_TARGET_PARAMETERS CURRENT_TARGET_PARAMETERS_LEN)
            if(${CURRENT_TARGET_PARAMETERS_LEN} GREATER 0)

                # TODO: Edge case: If a single value argument is explicitly specified in
                # target, use it instead.

                # TODO: Make multiple argument combination strategy selectable to user (intersection, combination ... )

                # Commit previous
                make_target(
                    ${CURRENT_TARGET_PARAMETERS}
                    ${ALL_TARGET_PARAMETERS}
                )
                hdk_log_verbose("make_component: Pushed new target -> ${CURRENT_TARGET_PARAMETERS} ${ALL_TARGET_PARAMETERS}")

                # Reset list
                set(CURRENT_TARGET_PARAMETERS "")
            endif()
        endif()
        list(APPEND CURRENT_TARGET_PARAMETERS ${TARGET_CURRENT})
        MATH(EXPR TARGET_INDEX "${TARGET_INDEX}+1")
    endwhile()
endfunction()