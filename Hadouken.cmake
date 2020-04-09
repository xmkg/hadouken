# ______________________________________________________
# Contains the list of required includes for the project boilerplate.
#
# @file 		Hadouken.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		14.02.2020
#
# @copyright   2020 NETTSI Informatics Technology Inc.
#
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

set(PB_PARENT_PROJECT_NAME ${PROJECT_NAME})

# Enable testing for the project
enable_testing()
# Project-wide C++ standard declaration
set(CMAKE_CXX_STANDARD 17)
#add_compile_options(-std=c++2a)
#add_compile_options(-fconcepts)
# Make C++ standard required.
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Export compile commands for other tool usage
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Hide all symbols on all projects by default
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
# Hide inline functions and template declarations too
set(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)
# Visibility policy
cmake_policy(SET CMP0063 NEW)
# This somehow tends to be unset, and causes third party library headers to generate warnings
# which results in build failure.
SET(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-isystem ")
# Add project boilerplate modules as cmake modules to parent project
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/boilerplate/cmake/modules/)
# Add custom find module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/boilerplate/cmake/modules/find)

# Banner module
include(misc/Banner)

# Discover all helper modules
file(GLOB HELPER_MODULES "${PROJECT_SOURCE_DIR}/boilerplate/cmake/modules/helper/*.cmake")
# Discover all toolconf modules
file(GLOB TOOLCONF_MODULES "${PROJECT_SOURCE_DIR}/boilerplate/cmake/modules/toolconf/*.cmake")

# Include all found modules
foreach(MODULE_FN IN LISTS HELPER_MODULES TOOLCONF_MODULES)
    include(${MODULE_FN})
endforeach()

include(buildvariant/BuildVariant)
include(FeatureCheck)

