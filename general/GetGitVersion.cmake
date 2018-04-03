# cmake file

include(CMakeParseArguments)

function(get_git_version)
  set(options SHORT)
  set(oneValueArgs VERSION)
  set(multiValueArgs)

  cmake_parse_arguments(GGV "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

  if(GGV_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR
      "${GGV_UNPARSED_ARGUMENTS} extraneous arguments provided")
  endif()

  if(GGV_SHORT)
    set(cmd_arg "--abbrev=0")
  else()
    set(cmd_arg "--long")
  endif()

  execute_process(COMMAND git describe --tags --always ${cmd_arg}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE ver
    RESULT_VARIABLE result
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  if(result)
    set(ver "0.0.0")
  endif()

  set(${GGV_VERSION} "${ver}" PARENT_SCOPE)
endfunction()

