# cmake file

include(CMakeParseArguments)


function(get_git_version)
  set(options SHORT)
  set(oneValueArgs VERSION)
  set(multiValueArgs)

  cmake_parse_arguments(get_version "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

  if(get_version_SHORT)
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

  set(${get_version_VERSION} "${ver}" PARENT_SCOPE)
endfunction()

