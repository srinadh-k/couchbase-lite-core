include("${CMAKE_CURRENT_LIST_DIR}/platform_unix.cmake")

function(setup_build)
    setup_build_unix()

    set(
        PLATFORM_SRC
        ${PLATFORM_SRC}
        "LiteCore/Support/StringUtil_Apple.mm"
        "LiteCore/Support/LibC++Debug.cc"
        "LiteCore/Support/Instrumentation.cc"
        CACHE INTERNAL ""
    )

    set(
        ALL_SRC_FILES
        ${ALL_SRC_FILES}
        "LiteCore/Storage/UnicodeCollator_Apple.cc"
        CACHE INTERNAL ""
    )

    # Use CommonCrypto for things like hashing and random numbers
    add_definitions(-D_CRYPTO_CC)
    set(LITECORE_CRYPTO_LIB "-framework Security" CACHE INTERNAL "")
endfunction()

function(configure_litecore)
    configure_litecore_unix()

    # Specify list of symbols to export
    set_target_properties(
        LiteCore PROPERTIES LINK_FLAGS
        "-exported_symbols_list ${PROJECT_SOURCE_DIR}/C/c4.exp"
    )
    
    target_link_libraries(
        LiteCore PUBLIC
        "-framework Foundation"
        "-framework CFNetwork"
        "-framework Security"
        z
    )
endfunction()

function(configure_litecore_rest)
    set_target_properties(
        LiteCoreREST PROPERTIES LINK_FLAGS
        "-exported_symbols_list ${CMAKE_CURRENT_SOURCE_DIR}/c4REST.exp"
    )

    target_link_libraries(
        LiteCoreREST PRIVATE
        "-framework Security"
    )
endfunction()