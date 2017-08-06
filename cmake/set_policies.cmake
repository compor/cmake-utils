# cmake file

function(set_policies)
  math(EXPR is_even "${ARGC} % 2")
  math(EXPR upper "${ARGC} - 1")

  if(NOT is_even EQUAL 0)
    message(FATAL_ERROR "set_policies requires an even number of arguments")
  endif()

  foreach(idx RANGE 0 ${upper} 2)
    set(plc "${ARGV${idx}}")

    math(EXPR nxt_idx "${idx} + 1")
    set(newval "${ARGV${nxt_idx}}")

    if(POLICY ${plc})
      cmake_policy(GET ${plc} oldval)

      if(NOT oldval EQUAL newval)
        cmake_policy(SET "${plc}" "${newval}")

        message(STATUS "policy ${plc}: ${newval}")
      endif()
    else()
      message(WARNING "policy ${plc} is not defined")
    endif()
  endforeach()
endfunction()

