macro(utils_target_include_dir_recurse TARGET_NAME TARGET_DIR)
    file(GLOB_RECURSE ALL_HEADERS CONFIGURE_DEPENDS
            ${TARGET_DIR}/*.h*
    )
    set(INCLUDE_DIRS "")
    foreach(HEADER ${ALL_HEADERS})
        get_filename_component(DIR ${HEADER} PATH)
        list(APPEND INCLUDE_DIRS ${DIR})
    endforeach ()
    list(REMOVE_DUPLICATES INCLUDE_DIRS)
    target_include_directories(${TARGET_NAME}
            PUBLIC
            ${INCLUDE_DIRS}
    )
    unset(INCLUDE_DIRS)
endmacro()

macro(utils_target_include_recurse TARGET_NAME TARGET_DIR)
    utils_target_include_dir_recurse(${TARGET_NAME} ${TARGET_DIR})
    file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
            ${TARGET_DIR}/*.*
    )
    target_sources(${TARGET_NAME}
            PUBLIC
            ${SOURCES}
    )
    endmacro()

macro(utils_target_generate_hex TARGET_NAME)
    add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/bin
        COMMAND ${CMAKE_OBJCOPY} -O ihex
            $<TARGET_FILE:${TARGET_NAME}>
            ${CMAKE_CURRENT_BINARY_DIR}/bin/${TARGET_NAME}.hex
        COMMENT "Building ${HEX_FILE}.hex"
    )
endmacro()

macro(utils_target_generate_bin TARGET_NAME)
    add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/bin
        COMMAND ${CMAKE_OBJCOPY} -O binary
            $<TARGET_FILE:${TARGET_NAME}>
            ${CMAKE_CURRENT_BINARY_DIR}/bin/${TARGET_NAME}.bin
        COMMENT "Building ${TARGET_NAME}.bin"
    )
#    add_custom_target(${TARGET_NAME}-bin
#        ALL COMMAND
#        ${CMAKE_OBJCOPY} -O binary
#                            $<TARGET_FILE:${TARGET_NAME}>
#                            ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.bin
#    )
#    add_dependencies(${TARGET_NAME}-hex
#        ${TARGET_NAME}
#    )
endmacro()

macro(utils_target_print_size TARGET_NAME)
    add_custom_command(
        TARGET ${TARGET_NAME} POST_BUILD COMMAND
        ${CMAKE_SIZE_UTIL} --format=sysv --radix=16 $<TARGET_FILE:${TARGET_NAME}>
    )
endmacro()

macro(utils_target_set_linker_script TARGET_NAME LINKER_SCRIPT)
    target_link_options(${TARGET_NAME}
        PRIVATE
        -T ${LINKER_SCRIPT}
    )
    set_target_properties(${TARGET_NAME}
        PROPERTIES
        LINK_DEPENDS
        ${LINKER_SCRIPT}
    )
endmacro()