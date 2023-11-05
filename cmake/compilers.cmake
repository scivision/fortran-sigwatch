include(CheckIncludeFile)
include(CheckSymbolExists)

add_compile_options(
"$<$<COMPILE_LANG_AND_ID:C,Clang,GNU,IntelLLVM>:-Wall;-Wextra;-Werror=implicit-function-declaration>"
"$<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-Wall;-Wextra;-fimplicit-none>"
"$<$<COMPILE_LANG_AND_ID:Fortran,IntelLLVM>:-warn>"
)

check_include_file(unistd.h HAVE_UNISTD_H)

check_include_file(signal.h HAVE_SIGNAL_H)

if(HAVE_SIGNAL_H)
  check_symbol_exists("NSIG" "signal.h" HAVE_NSIG)
  if(NOT HAVE_NSIG)
    check_symbol_exists("_NSIG" "signal.h" HAVE__NSIG)
  endif()
endif()
