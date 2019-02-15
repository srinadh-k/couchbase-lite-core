include("${CMAKE_CURRENT_LIST_DIR}/platform_win.cmake")

function(setup_build)
    setup_build_win()
    
    add_definitions(
        -DSQLITE_OS_WINRT               # Signal SQLite to use WinRT system calls instead of Win32
        -DMBEDTLS_NO_PLATFORM_ENTROPY   # mbedcrypto entropy support does not account for Windows Store builds
        -D_WIN32_WINNT=0x0602           # Support back to Windows 8
    )      
endfunction()

function(configure_litecore)
    configure_litecore_win()
    
    # Enable Windows Runtime compilation
    set_target_properties(
        LiteCore PROPERTIES COMPILE_FLAGS 
        /ZW
    )
    
    # Remove the default Win32 libs from linking
    set(
        CMAKE_SHARED_LINKER_FLAGS 
        "${CMAKE_SHARED_LINKER_FLAGS} /nodefaultlib:kernel32.lib /nodefaultlib:ole32.lib"
        PARENT_SCOPE
    )
endfunction()