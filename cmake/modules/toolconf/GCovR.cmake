# ______________________________________________________
# CMake module for running gcov code coverage analysis.
# 
# @file 		GCov.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		13.03.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

option(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOVR "Use gcovr in project" OFF)

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOVR)
    message(STATUS "[*] Configuring `gcovr`")

    find_program(GCOVR "gcovr")
    if(GCOVR)
        message(STATUS "\t[+] Found gcovr: ${GCOVR}")
    else()
        message(FATAL_ERROR "\t[-] `gcovr` not found in environment")
    endif()   
endif()
