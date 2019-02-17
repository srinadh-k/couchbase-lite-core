cmake_minimum_required (VERSION 3.9)
project (C4Tests)

if(ANDROID)
    # No sense building it for Android since using an Android executable is
    # tricky and strange
    return()
endif()

set(TOP ${PROJECT_SOURCE_DIR}/../../)

if(MSVC)
    include("${CMAKE_CURRENT_LIST_DIR}/cmake/platform_win.cmake")
elseif(APPLE)
    include("${CMAKE_CURRENT_LIST_DIR}/cmake/platform_apple.cmake")
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
    include("${CMAKE_CURRENT_LIST_DIR}/cmake/platform_linux.cmake")
else()
    message(FATAL_ERROR "Unsupported platform ${CMAKE_SYSTEM_NAME}")
endif()

set_source_files(RESULT TEST_SRC)
message(${TEST_SRC})
add_executable(C4Tests ${TEST_SRC})
setup_build()

target_compile_definitions(
    C4Tests PRIVATE
    -DC4_TESTS
)

target_link_libraries(
    C4Tests PRIVATE
    LiteCore
    LiteCoreREST
    CivetWeb
    FleeceStatic
    Support
    BLIPStatic
)

target_include_directories(
    C4Tests PRIVATE
    .
    ${TOP}vendor/fleece/vendor/catch
    ${TOP}vendor/fleece/API
    ${TOP}vendor/fleece/Fleece/Support
    ${TOP}C/include
    ${TOP}C
    ${TOP}Replicator
    ${TOP}Replicator/tests
    ${TOP}REST
    ${TOP}LiteCore/Support
    ${TOP}vendor/SQLiteCpp/sqlite3
    ${TOP}vendor/civetweb/include
    ${TOP}vendor/BLIP-Cpp/src/util
)

file(COPY data DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/C/tests)
file(COPY ../../LiteCore/tests/data/replacedb/ios120/iosdb.cblite2
  DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/LiteCore/tests/data/replacedb/ios120)