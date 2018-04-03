# cmake file

include(CMakeParseArguments)

function(add_clean_all_target)
  set(options)
  set(oneValueArgs TARGET)
  set(multiValueArgs)

  cmake_parse_arguments(ACAT "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

  if(NOT ACAT_TARGET)
    set(ACAT_TARGET "cleanall")
  endif()

  if(TARGET ${ACAT_TARGET})
    message(FATAL_ERROR "Target ${ACAT_TARGET} already exists")
  endif()

  if(ARGN)
    message(FATAL_ERROR "extraneous arguments provided")
  endif()

  add_custom_target(clean_all
    COMMAND "${CMAKE_COMMAND}" "--build" "${CMAKE_BINARY_DIR}"
    "--target" "${ACAT_TARGET}")
endfunction()

