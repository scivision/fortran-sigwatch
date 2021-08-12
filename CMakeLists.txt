cmake_minimum_required(VERSION 3.19...3.21)

project(FortranSignalWatch
LANGUAGES C Fortran
VERSION 1.1.0)

include(CTest)

include(CheckIncludeFile)
include(CheckSymbolExists)

set(CMAKE_C_STANDARD 99)

check_include_file("signal.h" HAVE_SIGNAL_H)

if(HAVE_SIGNAL_H)
  check_symbol_exists("NSIG" "signal.h" HAVE_NSIG)
  if(NOT HAVE_NSIG)
    check_symbol_exists("_NSIG" "signal.h" HAVE__NSIG)
  endif()
endif()

add_library(sigwatch sigwatch.c)
target_compile_definitions(sigwatch PRIVATE PACKAGE_VERSION="${PROJECT_VERSION}")

foreach(d HAVE_SIGNAL_H HAVE_NSIG HAVE__NSIG)
  if(${d})
    target_compile_definitions(sigwatch PRIVATE ${d})
  endif()
endforeach()

# Example

if(WIN32)
  add_executable(demo example_windows.f90)
else()
  add_executable(demo example_unix.f90)
endif()
target_link_libraries(demo PRIVATE sigwatch)

# if(UNIX)
#   add_test(NAME ForkInterrupt COMMAND sh -c "$<TARGET_FILE:demo> & kill -HUP $!")
#   set_tests_properties(ForkInterrupt PROPERTIES
#     TIMEOUT 20
#     PASS_REGULAR_EXPRESSION "lastsig=99")
# endif()
