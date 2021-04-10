#!/usr/bin/env cmake

# ______________________________________________________
# Common utilities for hadouken.
# 
# @file 	Utility.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	10.04.2021
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________


function(hdk_list_transform_prepend INPUT_LIST OUTPUT_VARIABLE PREFIX)
    set(temp "")
    foreach(f ${${INPUT_LIST}})
        list(APPEND temp "${PREFIX}${f}")
    endforeach()
    set(${OUTPUT_VARIABLE} "${temp}" PARENT_SCOPE)
endfunction()