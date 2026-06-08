
set ( CMAKE_SYSTEM_PROCESSOR "i686-linux64"            CACHE STRING "")
set ( CORE_MACHINE "i686")
set ( MACHINE                "Debian"          CACHE STRING "")
set ( PLATFORM ${MACHINE} )

set ( CMAKE_C_FLAGS          "-fPIC -D${MACHINE} -D${PLATFORM}" CACHE STRING "")
set ( CMAKE_CXX_FLAGS        "-fPIC -D${MACHINE} -D${PLATFORM}" CACHE STRING "")

set ( pwd ${CMAKE_CURRENT_SOURCE_DIR} )

include_directories( ${pwd} ./inc ./dependencies/include )

cmake_policy(SET CMP0048 NEW)
set ( CMAKE_SYSTEM_NAME "Generic"             CACHE STRING "")
set ( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE STRING "")
set ( CMAKE_C_COMPILER   ${CROSS_PREFIX}gcc )
set ( CMAKE_CXX_COMPILER ${CROSS_PREFIX}g++ )

string ( CONCAT prelnk_spec "") 
set( CMAKE_EXE_LINKER_FLAGS ${prelnk_spec} )
