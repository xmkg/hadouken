# ______________________________________________________
# CMake module for include-what-you-use tool integration.
#
# @file 		IncludeWhatYouUse.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		25.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_IWYU)
    get_property(HADOUKEN_COMPILER GLOBAL PROPERTY HADOUKEN_COMPILER)
    if(${CMAKE_VERSION} VERSION_LESS "3.3.0") 
        message(WARNING "Include what you use support requires at least version 3.3 of CMake.")
    elseif (NOT ${HADOUKEN_COMPILER} STREQUAL "CLANG")
        message(WARNING "Include what you use currently only works with clang compiler.")
    else()
        message(STATUS "[*] Configuring `include-what-you-use`")
        find_program(iwyu_path NAMES include-what-you-use iwyu)
        if(iwyu_path)
            set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${iwyu_path})
            list(APPEND CMAKE_CXX_INCLUDE_WHAT_YOU_USE 
                "" # add options here
            )

            # TODO: Check if clang version required for installed iwyu exist on the system
            # (so fucking needy)

            # ${CMAKE_CXX_COMPILER_VERSION} -> current kit
            # need to get version from other kits..
            message(STATUS "\t[+] `include-what-you-use` found: ${iwyu_path}")
        else()
            message(FATAL_ERROR "\t[-] `include-what-you-use` not found in environment")
        endif()
    endif()
endif()




