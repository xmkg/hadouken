# ______________________________________________________
# CMake module for locating and linking google test & google mock.
# 
# @file 		GoogleTest.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		28.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

if(${PB_PARENT_PROJECT_NAME_UPPER}_TOOLCONF_USE_GOOGLE_TEST)
    message(STATUS "[*] Configuring `googletest & googlemock`")

    project(${PB_PARENT_PROJECT_NAME}.test VERSION 1.0.0 LANGUAGES CXX)

    find_package(GTest QUIET REQUIRED)
    find_package(GMock QUIET REQUIRED)

    make_target(TYPE STATIC SOURCES ${PROJECT_SOURCE_DIR}/boilerplate/cmake/modules/toolconf/GoogleTest.cpp LINK PUBLIC GTest::GTest GTest::Main GMock::GMock GMock::Main)
endif()