include(${CMAKE_CURRENT_LIST_DIR}/platform_base.cmake)

function(setup_build_unix)
    set_litecore_source()
endfunction()

function(configure_litecore_unix)
    set_source_files_properties(${C_SRC} PROPERTIES COMPILE_FLAGS -Wno-return-type-c-linkage)
endfunction()