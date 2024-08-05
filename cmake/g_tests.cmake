cmake_minimum_required(VERSION 3.16)

include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG main
)

FetchContent_MakeAvailable(googletest)

enable_testing()

include(GoogleTest)

file(GLOB_RECURSE test_sources
        CONFIGURE_DEPENDS
        tests/*.*
)

add_library(TESTS SHARED ${test_sources})

target_link_libraries(TESTS
        PUBLIC
        GTest::gtest_main
        GTest::gmock_main
)

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}/_deps/googletest-src/googlemock/include
)

gtest_discover_tests(TESTS)