cmake_minimum_required(VERSION 3.16)
project(nether_pathfinder)

find_package(JNI COMPONENTS JNI_INCLUDE_DIRS)
if(NOT JNI_FOUND)
    set(JNI_INCLUDE_DIRS "$ENV{JAVA_HOME}/include;$ENV{JAVA_HOME}/include/linux")
endif()
include_directories(${JNI_INCLUDE_DIRS})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++20 -Wall")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")

file(GLOB_RECURSE SRC src/*)
list(REMOVE_ITEM SRC "${CMAKE_CURRENT_SOURCE_DIR}/src/benchmark_main.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp")

add_library(nether_pathfinder SHARED ${SRC})

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 13.0)
        message(FATAL_ERROR "requires clang at least clang 13")
    endif()
endif()
