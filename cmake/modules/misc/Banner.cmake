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

option(${PB_PARENT_PROJECT_NAME_UPPER}_MISC_NO_HADOUKEN_BANNER "Enable/disable banner" OFF)

if(NOT ${PB_PARENT_PROJECT_NAME_UPPER}_MISC_NO_HADOUKEN_BANNER)
# FIXME(mgilor): Retrieve version number from tags (somehow?)
# git tag --points-at HEAD 
message(STATUS [=[
################################################################################
                     _===__                                      
                   //-==;=_~                                   
                  ||('   ~)      ___      __ __ __------_        
             __----\|    _-_____////     --__---         -_      
            / _----_---_==__   |_|     __=-                \     
           / |  _______     ----_    -=__                  |     
           |  \_/      -----___| |       =-_              _/     
           |           \ \     \\\\      __ ---__       _ -      
           |            \ /     ^^^         ---  -------         
            \_         _|-                                   
             \_________/                                     
           _/   -----  -_.                                   
          /_/|  || ||   _/--__                               
          /  |_      _-       --_                            
         /     ------            |                           
        /      __------____/     |                           
       |      /           /     /                            
     /      /            |     |                             
    (     /              |____|                              
    /\__/                 |  |                               
   (  /                  |  /-__                             
   \  |                  (______)                            
    \\\)                                                     
################################################################################
# hadouken - c++ project development environment                 version 0.9.8 #
]=])
  
endif()