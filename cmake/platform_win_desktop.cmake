include("${CMAKE_CURRENT_LIST_DIR}/platform_win.cmake")

function(setup_build)
    setup_build_win()
    
    add_definitions(
        -D_WIN32_WINNT=0x0601       # Support back to Windows 7
        -DINCL_EXTRA_HTON_FUNCTIONS # Make sure htonll is defined for WebSocketProtocol.hh
    )      
endfunction()

function(configure_litecore)
    configure_litecore_win()
endfunction()