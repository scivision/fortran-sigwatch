cmake_minimum_required(VERSION 3.19...3.29)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "use out-of-source build
  cmake -Bbuild")
endif()

project(sigwatch
LANGUAGES C Fortran
VERSION 1.1.0)

enable_testing()


file(GENERATE OUTPUT .gitignore CONTENT "*")

include(cmake/compilers.cmake)

add_library(sigwatch OBJECT src/sigwatch.c src/sleep.c)
target_include_directories(sigwatch PUBLIC
$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
$<INSTALL_INTERFACE:include>
)
target_compile_definitions(sigwatch PRIVATE
PACKAGE_VERSION="${PROJECT_VERSION}"
$<$<BOOL:${HAVE_SIGNAL_H}>:HAVE_SIGNAL_H>
$<$<BOOL:${HAVE_NSIG}>:HAVE_NSIG>
$<$<BOOL:${HAVE__NSIG}>:HAVE__NSIG>
)

install(FILES include/sigwatch.h TYPE INCLUDE)
install(TARGETS sigwatch EXPORT ${PROJECT_NAME}Targets)

# --- tests

add_executable(sigwatch_f $<IF:$<BOOL:${WIN32}>,example/win32.f90,example/unix.f90>)
target_link_libraries(sigwatch_f PRIVATE sigwatch)
add_test(NAME SigWatch_Shell_Fortran COMMAND sigwatch_f)

add_executable(sigwatch_c $<IF:$<BOOL:${WIN32}>,example/win32.c,example/unix.c>)
target_link_libraries(sigwatch_c PRIVATE sigwatch)
add_test(NAME SigWatch_Shell_C COMMAND sigwatch_c)

set_tests_properties(SigWatch_Shell_Fortran SigWatch_Shell_C PROPERTIES
  TIMEOUT 10
  PASS_REGULAR_EXPRESSION "lastsig=99"
  DISABLED $<BOOL:${WIN32}>
  LABELS "shell"
)

if(CMAKE_VERSION VERSION_LESS 3.29)
  set_property(TARGET sigwatch_f sigwatch_c PROPERTY CROSSCOMPILING_EMULATOR ${CMAKE_CURRENT_SOURCE_DIR}/test/test_sigwatch.sh)
  return()
else()
  set_property(TEST SigWatch_shell_C SigWatch_Shell_Fortran PROPERTY TEST_LAUNCHER ${CMAKE_CURRENT_SOURCE_DIR}/test/test_sigwatch.sh)
endif()

# --- Python launcher

find_package(Python COMPONENTS Interpreter)
if(Python_Interpreter_FOUND)
  add_test(NAME SigWatch_Python_C COMMAND sigwatch_c)
  set_tests_properties(SigWatch_Python_C PROPERTIES
    TIMEOUT 10
    PASS_REGULAR_EXPRESSION "lastsig=99"
    LABELS "python"
    DISABLED $<BOOL:${WIN32}>
  )
  set_property(TEST SigWatch_Python_C PROPERTY TEST_LAUNCHER Python::Interpreter ${CMAKE_CURRENT_SOURCE_DIR}/test/test_sigwatch.py)
endif()
