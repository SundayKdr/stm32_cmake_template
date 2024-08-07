
function(utils_add_to_sources target)
    set(source_list ${SOURCES_${target}})
    foreach(folder_name ${ARGN})
        file(GLOB_RECURSE sources
            ${CMAKE_CURRENT_SOURCE_DIR}/${folder_name}/*.h*
            ${CMAKE_CURRENT_SOURCE_DIR}/${folder_name}/*.c*
        )
        foreach(file ${sources})
            list(APPEND source_list ${file})
        endforeach ()
    endforeach()
    SET(SOURCES_${target} ${source_list} CACHE INTERNAL "source_list")
endfunction()

function(utils_target_include_dir_recurse target)
    foreach (folder_name ${ARGN})
        file(GLOB_RECURSE all_headers
            ${CMAKE_CURRENT_SOURCE_DIR}/${folder_name}/*.h*
        )
        set(dirs "")
        foreach(header ${all_headers})
            get_filename_component(dir ${header} PATH)
            list(APPEND dirs ${dir})
        endforeach ()
        list(REMOVE_DUPLICATES dirs)
        target_include_directories(${target}
            PUBLIC
            ${dirs}
        )
    endforeach ()
endfunction()

function(utils_add_dls target)
    foreach(folder_name ${ARGN})
        file(GLOB_RECURSE dls CONFIGURE_DEPENDS
            ${CMAKE_CURRENT_SOURCE_DIR}/${folder_name}/*.a
        )
        target_link_libraries(${target}
            PUBLIC
            ${dls}
        )
    endforeach()
endfunction()

function(utils_add_all_from_path target)
    utils_add_to_sources(${ARGV})
    utils_target_include_dir_recurse(${ARGV})
    utils_add_dls(${ARGV})
endfunction()

function(exclude_folder_from_binary target)
    foreach (folder_name ${ARGV})
        foreach(tmp_path ${SOURCES_${target}})
            string (FIND ${tmp_path} ${CMAKE_CURRENT_SOURCE_DIR}/${folder_name} found)
            if (NOT ${found} EQUAL -1)
                list (REMOVE_ITEM ${SOURCES_${target}} ${tmp_path})
            endif ()
        endforeach()
    endforeach()
endfunction()

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