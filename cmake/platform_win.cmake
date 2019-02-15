include(${CMAKE_CURRENT_LIST_DIR}/platform_base.cmake)

function(setup_build_win)
    set_litecore_source()

    # Use mbedcrypto for hashing, random numbers, etc
    add_definitions(-D_CRYPTO_MBEDTLS)
    
    # Compile string literals as UTF-8,
    # Enable exception handling for C++ but disable for extern C
    # Disable the following warnings:
    #   4068 (unrecognized pragma)
    #   4244 (converting float to integer)
    #   4018 (signed / unsigned mismatch)
    #   4819 (character that cannot be represented in current code page)
    #   4800 (value forced to bool)
    # Disable warning about "insecure" C runtime functions (strcpy vs strcpy_s)
    set(LITECORE_CXX_FLAGS 
        "/utf-8 \
        /EHsc \
        /wd4068 \
        /wd4244 \
        /wd4018 \
        /wd4819 \
        /wd4800 \
        -D_CRT_SECURE_NO_WARNINGS=1"
        CACHE INTERNAL ""
    )
    
    set(
        LITECORE_C_FLAGS
        "/utf-8 \
        /wd4068 \
        /wd4244 \
        /wd4018 \
        /wd4819 \
        /wd4800 \
        -D_CRT_SECURE_NO_WARNINGS=1" 
        CACHE INTERNAL ""
    )
    
    # Disable the following warnings:
    #   4099 (library linked without debug info)
    #   4221 (object file with no new public symbols)
    set(
        LITECORE_SHARED_LINKER_FLAGS 
        "/ignore:4099 \
        /ignore:4221"
        CACHE INTERNAL ""
    )
    
    set(
        LITECORE_STATIC_LINKER_FLAGS
        "/ignore:4221"
        CACHE INTERNAL ""
    )
    
    set(
        PLATFORM_SRC
        MSVC/asprintf.c
        vendor/fleece/MSVC/memmem.cc
        MSVC/mkstemp.cc
        MSVC/mkdtemp.cc
        MSVC/strlcat.c
        MSVC/vasprintf-msvc.c
        MSVC/arc4random.cc
        MSVC/strptime.cc
        LiteCore/Support/StringUtil_winapi.cc
        LiteCore/Support/Error_windows.cc
        CACHE INTERNAL ""
    )

    set(
        ALL_SRC_FILES
        ${ALL_SRC_FILES}
        LiteCore/Storage/UnicodeCollator_winapi.cc
        CACHE INTERNAL ""
    )
    
    include_directories("MSVC")
    include_directories("vendor/fleece/MSVC")
endfunction()

function(configure_litecore_win)
    target_compile_definitions(
        LiteCoreStatic PUBLIC 
        -DUNICODE               # Use wide string variants for Win32 calls
        -D_UNICODE              # Ditto
        -D_USE_MATH_DEFINES     # Define math constants like PI
        -DLITECORE_EXPORTS      # Export functions marked CBL_CORE_API, etc
        -DWIN32                 # Identify as WIN32
    )
    
    # Set the exported symbols for LiteCore
    set_target_properties(
        LiteCore PROPERTIES LINK_FLAGS
        "/def:${PROJECT_SOURCE_DIR}/C/c4.def"
    )
    
    # Link with subproject libz and Windows sockets lib
    target_link_libraries(
        LiteCore PRIVATE 
        zlibstatic 
        Ws2_32
    )
endfunction()

function(configure_litecore_rest)
    set_target_properties(LiteCoreREST PROPERTIES LINK_FLAGS
              "/def:${PROJECT_SOURCE_DIR}/REST/c4REST.def")
endfunction()