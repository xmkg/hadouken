# ______________________________________________________
# Contains helper functions to gather header and source files from projects
# containing source files in `include/src` format.
# 
# @file 		AutoCompilationUnit.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		14.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

# Gather all files under `include` and `src` folders at current directory level 
# to `COMPILATION_UNIT` variable in invocation scope.
function(file_gather_compilation_unit)
    file(GLOB_RECURSE HEADERS "include/*")
    file(GLOB_RECURSE SOURCES "src/*")

    set(HEADERS ${HEADERS} PARENT_SCOPE)
    set(SOURCES ${SOURCES} PARENT_SCOPE)
    set(COMPILATION_UNIT ${HEADERS} ${SOURCES} PARENT_SCOPE)
endfunction()

