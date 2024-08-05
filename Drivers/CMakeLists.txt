cmake_minimum_required(VERSION 3.16)

file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/*.h
        ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp
)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/*.s
        ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
)

file(GLOB_RECURSE DLS CONFIGURE_DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/*.a
)

target_sources(${PROJECT_NAME}
        PUBLIC
        ${HEADERS}
        PRIVATE
        ${SOURCES}
)

target_link_libraries(${PROJECT_NAME} ${DLS})

utils_target_include_dir_recurse(${PROJECT_NAME} ${CMAKE_CURRENT_SOURCE_DIR})