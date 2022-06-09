cmake_minimum_required(VERSION 3.19)

project(FortranSignalWatch
LANGUAGES C Fortran
VERSION 1.1.0)

enable_testing()

include(cmake/compilers.cmake)

add_library(sigwatch src/sigwatch.c src/sleep.c)
target_compile_definitions(sigwatch PRIVATE
PACKAGE_VERSION="${PROJECT_VERSION}"
$<$<BOOL:${HAVE_SIGNAL_H}>:HAVE_SIGNAL_H>
$<$<BOOL:${HAVE_NSIG}>:HAVE_NSIG>
$<$<BOOL:${HAVE__NSIG}>:HAVE__NSIG>
)


add_subdirectory(example)
add_subdirectory(test)
