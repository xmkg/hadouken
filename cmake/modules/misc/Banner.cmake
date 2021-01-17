# ______________________________________________________
# CMake module for Clang specific build, warning and error flags 
# settings.
#
# @file 	Banner.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

option(${HDK_ROOT_PROJECT_NAME_UPPER}_MISC_NO_HADOUKEN_BANNER "Enable/disable banner"   OFF             )

if(NOT ${HDK_ROOT_PROJECT_NAME_UPPER}_MISC_NO_HADOUKEN_BANNER)

execute_process(
  COMMAND git tag --points-at HEAD
  WORKING_DIRECTORY ${HDK_ROOT_DIRECTORY}
  OUTPUT_VARIABLE HDK_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

message(STATUS [=[
################################################################################
#      ██╗░░██╗░█████╗░██████╗░░█████╗░██╗░░░██╗██╗░░██╗███████╗███╗░░██╗    #
#      ██║░░██║██╔══██╗██╔══██╗██╔══██╗██║░░░██║██║░██╔╝██╔════╝████╗░██║    #
#      ███████║███████║██║░░██║██║░░██║██║░░░██║█████═╝░█████╗░░██╔██╗██║    #
#      ██╔══██║██╔══██║██║░░██║██║░░██║██║░░░██║██╔═██╗░██╔══╝░░██║╚████║    #
#      ██║░░██║██║░░██║██████╔╝╚█████╔╝╚██████╔╝██║░╚██╗███████╗██║░╚███║    #
#      ╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░░╚════╝░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝    #                                            
################################################################################
# c++ project development environment                          version ]=] ${HDK_VERSION} [=[ #
]=])
  
endif()