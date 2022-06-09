include(CheckIncludeFile)
include(CheckSymbolExists)

if(CMAKE_C_COMPILER_ID STREQUAL GNU)
  add_compile_options($<$<COMPILE_LANGUAGE:C>:-Werror=implicit-function-declaration>)
elseif(CMAKE_C_COMPILER_ID MATCHES "(Clang|Intel)")
  add_compile_options($<$<COMPILE_LANGUAGE:C>:-Werror=implicit-function-declaration>)
endif()

add_compile_options(
"$<$<COMPILE_LANG_AND_ID:C,Clang,GNU>:-Wall;-Wextra>"
"$<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-Wall;-Wextra;-fimplicit-none>"
"$<$<COMPILE_LANG_AND_ID:Fortran,Intel,IntelLLVM>:-warn>"
)

check_include_file(unistd.h HAVE_UNISTD_H)

check_include_file(signal.h HAVE_SIGNAL_H)

if(HAVE_SIGNAL_H)
  check_symbol_exists("NSIG" "signal.h" HAVE_NSIG)
  if(NOT HAVE_NSIG)
    check_symbol_exists("_NSIG" "signal.h" HAVE__NSIG)
  endif()
endif()
