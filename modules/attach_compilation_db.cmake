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

  get_target_property(TRGT_TYPE ${acdb_TARGET} TYPE)
  file(TO_CMAKE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${file}" GENERATED_FILE)

  if(${TRGT_TYPE} STREQUAL "INTERFACE_LIBRARY")
    add_custom_command(OUTPUT ${GENERATED_FILE}
      COMMAND ${CMAKE_COMMAND}
      ARGS -E copy_if_different ${file} ${GENERATED_FILE}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      VERBATIM)
  else()
  add_custom_command(TARGET ${acdb_TARGET} POST_BUILD
    COMMAND ${CMAKE_COMMAND}
        ARGS -E copy_if_different ${file} ${GENERATED_FILE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    VERBATIM)
  endif()
endfunction()

