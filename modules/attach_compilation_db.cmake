# cmake file

include(CMakeParseArguments)


function(attach_compilation_db)
  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs)

  cmake_parse_arguments(acdb "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${acdb_TARGET})
    message(FATAL_ERROR
      "cannot attach custom command to non-target: ${acdb_TARGET}")
  endif()

  set(file "compile_commands.json")

  add_custom_command(TARGET ${acdb_TARGET} POST_BUILD
    COMMAND ${CMAKE_COMMAND}
    ARGS -E copy_if_different ${file} "${CMAKE_CURRENT_SOURCE_DIR}/${file}"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    VERBATIM)
endfunction()

