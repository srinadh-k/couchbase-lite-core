cmake_minimum_required (VERSION 3.9)
project (CppTests)

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

file(COPY data DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/LiteCore/tests)
file(COPY ../../C/tests/data DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/C/tests)
file(GLOB FLEECE_FILES "../../vendor/fleece/Tests/*.json" "../../vendor/fleece/Tests/*.json5" "../../vendor/fleece/Tests/*.fleece" "../../vendor/fleece/Tests/*.txt")
file(COPY ${FLEECE_FILES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/vendor/fleece/Tests)
add_executable(CppTests ${TEST_SRC})

setup_build()

target_compile_definitions(
    CppTests PRIVATE
    -DLITECORE_CPP_TESTS=1
    -D_USE_MATH_DEFINES
    -DNOMINMAX
)

target_include_directories(
    CppTests PRIVATE
    ${TOP}vendor/BLIP-Cpp/src/util
    ${TOP}vendor/BLIP-Cpp/include/blip_cpp
    ${TOP}vendor/fleece/API
    ${TOP}vendor/fleece/Experimental
    ${TOP}vendor/fleece/Fleece/Core
    ${TOP}vendor/fleece/Fleece/Mutable
    ${TOP}vendor/fleece/Fleece/Support
    ${TOP}vendor/fleece/Fleece/Tree
    ${TOP}vendor/fleece/vendor/catch
    ${TOP}vendor/fleece/vendor/jsonsl
    ${TOP}vendor/SQLiteCpp/include
    ${TOP}vendor/SQLiteCpp/sqlite3
    ${TOP}C
    ${TOP}C/include
    ${TOP}C/tests
    ${TOP}LiteCore/BlobStore
    ${TOP}LiteCore/Database
    ${TOP}LiteCore/RevTrees
    ${TOP}LiteCore/Storage
    ${TOP}LiteCore/Support
    ${TOP}LiteCore/Query
    ${TOP}Replicator
    ${TOP}vendor/civetweb/include
)

target_link_libraries(
    CppTests PRIVATE
    LiteCoreStatic
    FleeceStatic
    mbedcrypto
    SQLite3_UnicodeSN
    BLIPStatic
    CivetWeb
    Support
)