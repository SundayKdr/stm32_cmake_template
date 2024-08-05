cmake_minimum_required(VERSION 3.16)

set(project_name        Name)
set(TARGET_CPU          "cortex-m4")
set(DEVICE_FAMILY       STM32G4xx)
set(DEVICE_NAME         STM32G431xx)
set(DEVICE_FULL_NAME    STM32G431CBTX)
set(COMPILE_DEFS
        ${DEVICE_NAME}
        USE_HAL_DRIVER
        #USE_FULL_LL_DRIVER
        #USBPD_PORT_COUNT=1
        #_SNK
        #USBPDCORE_LIB_PD3_FULL
)

set(CMAKE_TOOLCHAIN_FILE cmake/toolchain.cmake)
#include(cmake/g_tests.cmake)

include(cmake/utils.cmake)

project(${project_name} C CXX ASM)

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to DEBUG")
    set(CMAKE_BUILD_TYPE DEBUG)
else()
    message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
endif()

message(STATUS "CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")

add_executable(${PROJECT_NAME} Core/Src/main.c startup_${DEVICE_NAME}.s)

add_subdirectory(Drivers)

include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/App
        ${CMAKE_CURRENT_SOURCE_DIR}/Libs
)

utils_target_include_dir_recurse(${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/Core)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/Core/*.*
        ${CMAKE_CURRENT_SOURCE_DIR}/App/*.*
        ${CMAKE_CURRENT_SOURCE_DIR}/Libs/*.*
)

#Excluding directory - no compilation
set (EXCLUDE_DIR "tmp")
foreach (TMP_PATH ${SOURCES})
    string (FIND ${TMP_PATH} ${EXCLUDE_DIR} EXCLUDE_DIR_FOUND)
    if (NOT ${EXCLUDE_DIR_FOUND} EQUAL -1)
        list (REMOVE_ITEM SOURCES ${TMP_PATH})
    endif ()
endforeach(TMP_PATH)
#//Excluding directory

target_sources(${PROJECT_NAME}
        PUBLIC
        ${SOURCES}
)

set_target_properties(${PROJECT_NAME}
        PROPERTIES
        SUFFIX ".elf"
        C_STANDARD 11
        C_EXTENSIONS ON
        CMAKE_C_STANDARD_REQUIRED ON
        CXX_STANDARD 23
        CXX_EXTENSIONS ON
        CMAKE_CXX_STANDARD_REQUIRED ON
        LINK_FLAGS_RELEASE -s
)

target_link_options(${PROJECT_NAME}
        PUBLIC
        -Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.map,--cref
)

utils_target_set_linker_script(${PROJECT_NAME}
        ${CMAKE_CURRENT_SOURCE_DIR}/${DEVICE_FULL_NAME}_FLASH.ld
)

utils_target_generate_hex(${PROJECT_NAME})
utils_target_generate_bin(${PROJECT_NAME})
utils_target_print_size(${PROJECT_NAME})

target_compile_definitions(${PROJECT_NAME}
        PUBLIC
        ${COMPILE_DEFS}
)

target_compile_options(${PROJECT_NAME}
        PRIVATE
        #        -Wall
        #        -Wextra
        #        -Wpedantic
        #        -Werror
        #        -Wduplicated-cond
        #        -Wduplicated-branches
        #        -Wlogical-op
        #        -Wnull-dereference
        #        -Wshadow
        #        -Wconversion
        #        -Wsign-conversion
        #        -Wno-volatile
)