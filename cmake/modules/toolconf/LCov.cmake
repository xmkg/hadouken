# ______________________________________________________
# CMake module for running lcov code coverage analysis.
# 
# @file 		LCov.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		13.03.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

option(${PB_PARENT_PROJECT_NAME}_TOOLCONF_USE_LCOV "Use lcov in project" OFF)

if(${PB_PARENT_PROJECT_NAME}_TOOLCONF_USE_LCOV)
    message(STATUS "[*] Configuring `lcov`")

    find_program(LCOV NAMES lcov lcov.bat lcov.exe lcov.perl)
    if(LCOV)
        message(STATUS "\t[+] Found lcov: ${LCOV}")
    else()
        message(FATAL_ERROR "\t[-] `lcov` not found in environment")
    endif()   
endif()