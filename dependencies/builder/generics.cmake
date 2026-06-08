function(filter_regex _action _regex _listname)
    # check an action
    if("${_action}" STREQUAL "INCLUDE")
	set(has_include TRUE)
    elseif("${_action}" STREQUAL "EXCLUDE")
	set(has_include FALSE)
    else()
	message(FATAL_ERROR "Incorrect value for ACTION: ${_action}")
    endif()

    set(${_listname})
    foreach(element ${ARGN})
	string(REGEX MATCH ${_regex} result ${element})
	if(result)
	    if(has_include)
		list(APPEND ${_listname} ${element})
	    endif()
	else()
	    if(NOT has_include)
		list(APPEND ${_listname} ${element})
	    endif()
	endif()
    endforeach()

    # put result in parent scope variable
    set(${_listname} ${${_listname}} PARENT_SCOPE)
endfunction()

string(ASCII 27 Esc)
set(Reset "${Esc}[m")
set(Bold  "${Esc}[1m")
set(Blink "${Esc}[5m")

set(Red         "${Esc}[31m")
set(Green       "${Esc}[32m")
set(Yellow      "${Esc}[33m")
set(Blue        "${Esc}[34m")
set(Magenta     "${Esc}[35m")
set(Cyan        "${Esc}[36m")
set(White       "${Esc}[37m")
set(BoldRed     "${Esc}[1;31m")
set(BoldGreen   "${Esc}[1;32m")
set(BoldYellow  "${Esc}[1;33m")
set(BoldBlue    "${Esc}[1;34m")
set(BoldMagenta "${Esc}[1;35m")
set(BoldCyan    "${Esc}[1;36m")
set(BoldWhite   "${Esc}[1;37m")

execute_process( COMMAND bash "-c" "grep URL ${CMAKE_CURRENT_SOURCE_DIR}/inc/tag.h |cut -f2 -d'\"'" OUTPUT_VARIABLE Signature )
execute_process( COMMAND bash "-c" "basename ${Signature}" OUTPUT_VARIABLE Signature )
string(REPLACE "\n" "" Signature ${Signature})  

if( ${Platform} STREQUAL ppc )

    set(boost_inc ./dependencies/include/boost-ppc)
    set(boost_libs ./dependencies/boost-ppc/lib/ppc)
    set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS true)
    set ( DeployArtefact ${Component}-${Signature}.x )
    install (CODE "execute_process( COMMAND printf \"Installing ${Blue}${Artefact}${Reset} @${Green}${Host}:/${DeployPath}${Reset}\n\")")
    install (CODE "execute_process( \
	    COMMAND scp ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}./${Artefact} root@${Host}:${DeployPath}/${DeployArtefact} \
	    COMMAND ssh root@${Host} \"printf ${Blue}; hostname; printf ${Reset}; ls -al ${DeployPath}/${Target}*\")" )
    SET_PROPERTY(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS true)
    set( CMAKE_CXX_STANDARD 98)

elseif( ${Platform} STREQUAL k60 )

    set ( CMAKE_CXX_STANDARD 11)
    SET ( CMAKE_C_COMPILER_WORKS 1)
    SET ( CMAKE_CXX_COMPILER_WORKS 1)

elseif( ${Platform} STREQUAL k25 )

    set(CMAKE_CXX_STANDARD 17)
    SET (CMAKE_C_COMPILER_WORKS 1)
    SET (CMAKE_CXX_COMPILER_WORKS 1)

elseif( ${Platform} STREQUAL zynq7k )

    set(CMAKE_CXX_STANDARD 17)
    SET (CMAKE_C_COMPILER_WORKS 1)
    SET (CMAKE_CXX_COMPILER_WORKS 1)

elseif( ${Platform} STREQUAL i686Debian)

  #  set(CMAKE_CXX_STANDARD 17)

else()


endif()

link_directories(${CMAKE_SOURCE_DIR}/dependencies/build.${Platform} )
set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-write-strings -g2" )
set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-write-strings -g2"  )

