set ( CORE_MACHINE "i686Android")
set ( MACHINE ${CORE_MACHINE}          CACHE STRING "")
set ( PLATFORM ${MACHINE} )

set ( ANDROID_NDK_PATH "/home/juanba/Android/android-sdk/ndk/19.2.5345600/" )   

set ( TOOLCHAIN_PATH ${ANDROID_NDK_PATH}/toolchains/llvm/prebuilt/linux-x86_64/bin/ )
set ( CMAKE_SYSROOT ${ANDROID_NDK_PATH}/sysroot )

set ( CMAKE_CXX_FLAGS  "-gcc-toolchain ${ANDROID_NDK_PATH}/toolchains/x86-4.9/prebuilt/linux-x86_64 \
 -isystem ${CMAKE_SYSROOT}/usr/include/i686-linux-android \
 -isystem ${ANDROID_NDK_PATH}sources/cxx-stl/llvm-libc++/include \
 -isystem ${ANDROID_NDK_PATH}sources/android/support/include \
 -isystem ${ANDROID_NDK_PATH}sources/cxx-stl/llvm-libc++abi/include" CACHE STRING "")

add_compile_options( -D${MACHINE} -D__ANDROID_API__=16 -DANDROID_HAS_WSTRING -D${PLATFORM} -DANDROID_ABI=x86  )
add_compile_options( -fno-limit-debug-info -fstack-protector-strong -fPIC )
add_compile_options( -target i686-none-linux-android -mstackrealign )

set ( CMAKE_C_FLAGS ${CMAKE_CXX_FLAGS} )

set ( CMAKE_C_COMPILER   ${TOOLCHAIN_PATH}/clang )
set ( CMAKE_CXX_COMPILER ${TOOLCHAIN_PATH}/clang++ )
set ( CMAKE_TOOLCHAIN_FILE ${TOOLCHAIN_PATH}/build/cmake/android.toolchain.cmake )

SET ( CMAKE_C_COMPILER_WORKS 1 )
SET ( CMAKE_CXX_COMPILER_WORKS 1 )