cmake_minimum_required(VERSION 3.19...3.22)

project(FortranSignalWatch
LANGUAGES C Fortran
VERSION 1.1.0)

include(CTest)

include(CheckIncludeFile)
include(CheckSymbolExists)

set(CMAKE_C_STANDARD 99)

add_compile_options(
"$<$<COMPILE_LANG_AND_ID:C,Clang,GNU>:-Wall;-Wextra>"
"$<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-Wall;-Wextra;-fimplicit-none>"
"$<$<COMPILE_LANG_AND_ID:Fortran,Intel,IntelLLVM>:-warn>"
"$<$<COMPILE_LANG_AND_ID:C,Intel,IntelLLVM>:$<IF:$<BOOL:${WIN32}>,/W3,-w2>>"
"$<$<COMPILE_LANG_AND_ID:CXX,Intel,IntelLLVM>:$<IF:$<BOOL:${WIN32}>,/W3,-w2>>"
)

check_include_file("signal.h" HAVE_SIGNAL_H)

if(HAVE_SIGNAL_H)
  check_symbol_exists("NSIG" "signal.h" HAVE_NSIG)
  if(NOT HAVE_NSIG)
    check_symbol_exists("_NSIG" "signal.h" HAVE__NSIG)
  endif()
endif()

add_library(sigwatch src/sigwatch.c src/sleep.c)
target_compile_definitions(sigwatch PRIVATE
PACKAGE_VERSION="${PROJECT_VERSION}"
$<$<BOOL:${HAVE_SIGNAL_H}>:HAVE_SIGNAL_H>
$<$<BOOL:${HAVE_NSIG}>:HAVE_NSIG>
$<$<BOOL:${HAVE__NSIG}>:HAVE__NSIG>
)


add_subdirectory(example)

if(BUILD_TESTING)
  add_subdirectory(test)
endif()
