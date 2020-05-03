# ______________________________________________________
# CMake module for finding clang-tidy in environment if installed. 
# The module creates targets named clang-tidy if relevant programs 
# are installed.
# 
# @file 		ClangTidy.cmake
# @author 	    Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		25.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

option(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_TIDY "Use clang-tidy in project" OFF)

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_CLANG_TIDY)
    message(STATUS "[*] Configuring `clang-tidy`")
    # Adding clang-format target if executable is found
    find_program(CLANG_TIDY NAMES "clang-tidy" "clang-tidy-10" "clang-tidy-9" "clang-tidy-8" "clang-tidy-7" "clang-tidy-6" "clang-tidy-5" "clang-tidy-4" "clang-tidy-3")
    if(CLANG_TIDY)
        message(STATUS "\t[+] Found clang-tidy: ${CLANG_TIDY}")
        #set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY}")
        set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY}")
    else()
        message(FATAL_ERROR "\t[-] `clang-tidy` not found in environment")
    endif()
endif()