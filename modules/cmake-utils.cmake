#.rst:
# cmake-utils
# -------------
#
# cmake utils

cmake_minimum_required(VERSION 2.8.11)

set(CMAKE_UTIL_VERSION_MAJOR "1")
set(CMAKE_UTIL_VERSION_MINOR "1")
set(CMAKE_UTIL_VERSION_PATCH "0")

string(CONCAT CMAKE_UTIL_VERSION
  ${CMAKE_UTIL_VERSION_MAJOR} "."
  ${CMAKE_UTIL_VERSION_MINOR} "."
  ${CMAKE_UTIL_VERSION_PATCH})


#


include(FindPythonModule)
include(FindLLVMPolly)
include(format_check)
include(get_version)
include(set_policies)

