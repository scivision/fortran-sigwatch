add_executable(demo $<IF:$<BOOL:${WIN32}>,example_windows.f90,example_unix.f90>)
target_link_libraries(demo PRIVATE sigwatch)
