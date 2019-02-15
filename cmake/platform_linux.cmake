include("${CMAKE_CURRENT_LIST_DIR}/platform_unix.cmake")

function(setup_build_linux)
    add_definitions(-D_CRYPTO_MBEDTLS)
    
    set(
        PLATFORM_SRC
        LiteCore/Unix/strlcat.c
        LiteCore/Unix/arc4random.cc
        LiteCore/Support/StringUtil_icu.cc
        CACHE INTERNAL ""
    )

    set(
        ALL_SRC_FILES
        ${ALL_SRC_FILES}
        LiteCore/Storage/UnicodeCollator_ICU.cc
        CACHE INTERNAL ""
    )
        
    set(WHOLE_LIBRARY_FLAG "-Wl,--whole-archive" CACHE INTERNAL "")
    set(NO_WHOLE_LIBRARY_FLAG "-Wl,--no-whole-archive" CACHE INTERNAL "")
    
    include_directories("LiteCore/Unix")
endfunction()

function(configure_litecore_linux)
    configure_litecore_unix()
endfunction()