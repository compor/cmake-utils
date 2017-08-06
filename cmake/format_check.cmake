# cmake file

include(CMakeParseArguments)


function(format_check)
  set(options)
  set(oneValueArgs COMMAND)
  set(multiValueArgs FILES)

  cmake_parse_arguments(format_check "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

  set(rv 0)

  foreach(file ${format_check_FILES})
    execute_process(COMMAND
      ${format_check_COMMAND} ${file} | diff -u ${file} - &> /dev/null
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE rv
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    if(rv)
      break()
    endif()
  endforeach()

  if(rv)
    message(STATUS "code formatting is compliant")
  else()
    message(WARNING "code formatting is not compliant")
  endif()
endfunction()

