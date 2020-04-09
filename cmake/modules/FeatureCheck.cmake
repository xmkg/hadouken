# ______________________________________________________
# CMake module for driving check modules.
# 
# @file 		FeatureCheck.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		25.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

include(CheckCXXSourceCompiles)

# A function to check whether specified feature/library is available on the build environment.
# Feature/library names are passed as function arguments. Relevant `check` files must exist.
# Example: feature_check_assert(Pthreads)
function(feature_check_assert)
    message(STATUS "[*] Checking library and feature availability")
    foreach(arg IN LISTS ARGN)
        if(NOT EXISTS "${PROJECT_SOURCE_DIR}/boilerplate/cmake/modules/check/Check${arg}.cmake")
            message(FATAL_ERROR "\t[X] Feature check module for `${arg}` not found!")
        endif()
        include(check/Check${arg})
        string(TOUPPER ${arg} ARG_AS_UPPER)
        if (NOT ${PB_PARENT_PROJECT_NAME}_HAS_${ARG_AS_UPPER})
            message(FATAL_ERROR "\t[-] `${arg}` failed")
        else()
            message(STATUS "\t[+] `${arg}` OK")
            add_compile_definitions(${PB_PARENT_PROJECT_NAME}_HAS_${ARG_AS_UPPER})
        endif()
    endforeach()
endfunction()
