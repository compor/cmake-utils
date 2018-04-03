# cmake file

include(CMakeParseArguments)


function(attach_compilation_db)
  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs)

  cmake_parse_arguments(ACDB "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

  if(NOT TARGET ${ACDB_TARGET})
    message(FATAL_ERROR "${ACDB_TARGET} is not a target")
  endif()

  if(ACDB_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR
      "${ACDB_UNPARSED_ARGUMENTS} extraneous arguments provided")
  endif()

  set(DBFILE "compile_commands.json")

  get_target_property(TRGT_TYPE ${ACDB_TARGET} TYPE)
  file(TO_CMAKE_PATH "${CMAKE_SOURCE_DIR}/${DBFILE}" GENERATED_FILE)

  if(${TRGT_TYPE} STREQUAL "INTERFACE_LIBRARY")
    add_custom_command(OUTPUT ${GENERATED_FILE}
      COMMAND ${CMAKE_COMMAND}
      ARGS -E copy_if_different ${DBFILE} ${GENERATED_FILE}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      VERBATIM)
  else()
    add_custom_command(TARGET ${ACDB_TARGET} POST_BUILD
      COMMAND ${CMAKE_COMMAND}
      ARGS -E copy_if_different ${DBFILE} ${GENERATED_FILE}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      VERBATIM)
  endif()
endfunction()

