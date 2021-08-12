cmake_minimum_required(VERSION 3.19...3.21)

project(FortranSignalWatch
LANGUAGES C Fortran
VERSION 1.1.0)

include(CTest)

include(CheckIncludeFile)
include(CheckSymbolExists)

set(CMAKE_C_STANDARD 99)

if(CMAKE_C_COMPILER_ID MATCHES "(GNU|Clang)")
  string(APPEND CMAKE_C_FLAGS " -Wall -Wextra")
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  string(APPEND CMAKE_Fortran_FLAGS " -Wall -Wextra -fimplicit-none")
endif()

check_include_file("signal.h" HAVE_SIGNAL_H)

if(HAVE_SIGNAL_H)
  check_symbol_exists("NSIG" "signal.h" HAVE_NSIG)
  if(NOT HAVE_NSIG)
    check_symbol_exists("_NSIG" "signal.h" HAVE__NSIG)
  endif()
endif()

add_library(sigwatch src/sigwatch.c)
target_compile_definitions(sigwatch PRIVATE PACKAGE_VERSION="${PROJECT_VERSION}")

foreach(d HAVE_SIGNAL_H HAVE_NSIG HAVE__NSIG)
  if(${d})
    target_compile_definitions(sigwatch PRIVATE ${d})
  endif()
endforeach()

add_subdirectory(examples)

if(BUILD_TESTING)
  add_subdirectory(src/tests)
endif()
