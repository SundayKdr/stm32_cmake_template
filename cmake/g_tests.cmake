
include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG main
)

FetchContent_MakeAvailable(googletest)

enable_testing()

include(GoogleTest)

file(GLOB_RECURSE test_sources CONFIGURE_DEPENDS
        ${PROJECT_SOURCE_DIR}/tests/*.*
)

add_executable(${PROJECT_NAME}Test ${test_sources})

target_link_libraries(${PROJECT_NAME}Test
        PUBLIC
        GTest::gtest_main
        GTest::gmock_main
)

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}/_deps/googletest-src/googlemock/include
)

gtest_discover_tests(${PROJECT_NAME}Test)