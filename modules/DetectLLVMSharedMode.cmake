# cmake file

include(CMakeParseArguments)

#.rst:
# DetectLLVMSharedMode
# --------------------
#
# This module provides the function detect_llvm_shared_mode().
#
# The ``detect_llvm_shared_mode`` function can be used to detect the mode in
# which the LLVM plugins where built in. There are two possible values:
#
# - static
# - shared
#
#    detect_llvm_shared_mode(
#      SHARED_MODE <mode>
#      LLVM_VERSION <version>
#    )
#
# The ``detect_llvm_shared_mode`` function writes the LLVM build mode detected
# as a string in the <mode> variable. The <version> variable must contain the
# LLVM version string in the form of "[MAJOR].[MINOR].[PATCH]". This version
# strings can be provided by the CMake LLVM infrastructure after including the
# ``AddLLVM`` CMake file in your project. See the `LLVM documentation
# <https://llvm.org/docs/CMake.html>`_.
#
# Under the hood, the function is trying to find
# ``llvm-config[-[MAJOR].[MINOR]]`` exposed in ``PATH`` environment variable,
# in order to detect the correct mode.
#

function(detect_llvm_shared_mode)
  set(options)
  set(oneValueArgs SHARED_MODE LLVM_VERSION)
  set(multiValueArgs)

  cmake_parse_arguments(detect_mode "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

  if(NOT detect_mode_SHARED_MODE)
    message(FATAL_ERROR "SHARED_MODE mandatory argument is missing")
  endif()

  if(NOT detect_mode_LLVM_VERSION)
    message(FATAL_ERROR "LLVM_VERSION mandatory argument is missing")
  endif()

  string(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+$"
    LLVM_VERSION_CHECK "${LLVM_VERSION}")

  if(NOT ${LLVM_VERSION} STREQUAL ${LLVM_VERSION_CHECK})
    message(FATAL_ERROR "LLVM_VERSION is malformatted")
  endif()

  set(LLVM_VERSION "${detect_mode_LLVM_VERSION}")

  set(CONFIG_TOOL "llvm-config")
  set(mode "static")

  #

  # try llvm-config without and with version as a suffix
  execute_process(COMMAND ${CONFIG_TOOL} --version
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE ver
    RESULT_VARIABLE result
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  # check if the version reported by the non-version qualified config tool
  # matches with the one that we expect from our argument
  # if not, cause fallback to the version-qualified config tool
  if(NOT result)
    if(NOT ${LLVM_VERSION} STREQUAL ${ver})
      set(result 1)
    endif()
  endif()

  if(result)
    string(REGEX MATCH "^[0-9]+\\.[0-9]+" LLVM_VERSION_SHORT "${LLVM_VERSION}")
    set(CONFIG_TOOL "${CONFIG_TOOL}-${LLVM_VERSION_SHORT}")

    execute_process(COMMAND ${CONFIG_TOOL} --version
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      OUTPUT_VARIABLE ver
      RESULT_VARIABLE result
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE)
  endif()

  if(result)
    message(FATAL_ERROR "llvm-config could not be located")
  endif()

  if("${LLVM_VERSION}" VERSION_LESS "3.8.0")
    # the LLVMSupport library must always be there,
    # so use it to find its object suffix
    execute_process(COMMAND ${CONFIG_TOOL} --libnames support
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      OUTPUT_VARIABLE libname
      RESULT_VARIABLE result
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    if(NOT result)
      string(REGEX MATCH ".*\\.${CMAKE_STATIC_LIBRARY_SUFFIX}$"
        matched "${libname}")

      if(NOT matched)
        set(mode "shared")
      endif()
    endif()
  else()
    # LLVM versions 3.8 and on have that introspection capability builtin
    execute_process(COMMAND ${CONFIG_TOOL} --shared-mode
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      OUTPUT_VARIABLE mode
      RESULT_VARIABLE result
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE)
  endif()

  if(result)
    message(FATAL_ERROR "Cannot determine shared mode")
  endif()

  set(${detect_mode_SHARED_MODE} "${mode}" PARENT_SCOPE)
endfunction()

