# cmake file

include(CMakeParseArguments)


function(get_version)
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
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE ver
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  set(${get_version_VERSION} "${ver}" PARENT_SCOPE)
endfunction()

