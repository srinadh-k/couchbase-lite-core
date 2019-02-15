include("${CMAKE_CURRENT_LIST_DIR}/platform_linux.cmake")

function(setup_build)
    setup_build_linux()

    set(
        ALL_SRC_FILES
        ${ALL_SRC_FILES}
        "LiteCore/Android/unicode/ndk_icu.c"
        CACHE INTERNAL ""
    )

    set(
        PLATFORM_SRC
        ${PLATFORM_SRC}
        "LiteCore/Support/Error_android.cc"
        CACHE INTERNAL ""
    )
    
    # See: https://github.com/android-ndk/ndk/issues/477
    # The issue is also applicable for other areas like fseeko
    add_definitions(-DLITECORE_USES_ICU=1 -D_FILE_OFFSET_BITS=32)
    
    # See: https://github.com/android-ndk/ndk/issues/289
    # Work around an NDK issue that links things like exception handlers in the incorrect order
    set(LITECORE_SHARED_LINKER_FLAGS "${LITECORE_SHARED_LINKER_FLAGS} -Wl,--exclude-libs,libgcc.a" CACHE INTERNAL "")

    include_directories("LiteCore/Android")
endfunction()

function(configure_litecore)
    configure_litecore_linux()
    
    target_link_libraries(
        LiteCore PRIVATE 
        "atomic" 
        "log" 
        zlibstatic
    )
endfunction()

function(configure_litecore_rest)
    target_link_libraries(
        LiteCoreREST PRIVATE
        "atomic"
        "log"
    )
endfunction()