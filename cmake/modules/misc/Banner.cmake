# ______________________________________________________
# CMake module for Clang specific build, warning and error flags 
# settings.
#
# @file 		Banner.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		14.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

option(${PB_PARENT_PROJECT_NAME_UPPER}_MISC_NO_HADOUKEN_BANNER "Enable/disable banner" OFF)

if(NOT ${PB_PARENT_PROJECT_NAME_UPPER}_MISC_NO_HADOUKEN_BANNER)

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
༼つಠ益ಠ༽つ ─=≡ΣO)) hadouken - c++ build environment boilerplate        version 1
]=])
  
endif()