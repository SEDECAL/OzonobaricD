
set ( CMAKE_SYSTEM_PROCESSOR "i686-w64"            CACHE STRING "")
set ( MACHINE                "i686-w64-mingw32"          CACHE STRING "")
set ( CROSS_PREFIX           "i686-w64-mingw32.static-" CACHE STRING "")
set ( CMAKE_C_FLAGS          "" CACHE STRING "")
set ( CMAKE_CXX_FLAGS        "" CACHE STRING "")

set ( pwd ${CMAKE_CURRENT_SOURCE_DIR} )
set( Platform ${MACHINE} )
ADD_DEFINITIONS( -D__MINGW32__ )
include_directories( ${pwd} ./inc ./dependencies/include )

cmake_policy(SET CMP0048 NEW)
set ( CMAKE_SYSTEM_NAME "Generic"             CACHE STRING "")
set ( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "")
set ( CMAKE_C_COMPILER   ${CROSS_PREFIX}gcc )
set ( CMAKE_CXX_COMPILER ${CROSS_PREFIX}g++ )

SET (CMAKE_C_COMPILER_WORKS 1)
SET (CMAKE_CXX_COMPILER_WORKS 1)

string ( CONCAT prelnk_spec "") 
set( CMAKE_EXE_LINKER_FLAGS ${prelnk_spec} )
