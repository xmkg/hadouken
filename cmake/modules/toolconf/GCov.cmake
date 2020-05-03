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

option(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV "Use gcov in project" OFF)

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GCOV)
    message(STATUS "[*] Configuring `gcov`")

    find_program(GCOV "gcov")
    if(GCOV)
        message(STATUS "\t[+] Found gcov: ${GCOV}")
    else()
        message(FATAL_ERROR "\t[-] `gcov` not found in environment")
    endif()   
endif()
