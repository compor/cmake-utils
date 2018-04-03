# cmake file

function(add_cleanall_target)
  add_custom_target(clean_all
    COMMAND "${CMAKE_COMMAND}" "--build" "${CMAKE_BINARY_DIR}"
    "--target" "clean")
endfunction()

