add_test(NAME ForkInterrupt
COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/test_fork_interrupt.sh $<TARGET_FILE:demo>
)
set_tests_properties(ForkInterrupt PROPERTIES
  TIMEOUT 20
  PASS_REGULAR_EXPRESSION "lastsig=99"
  DISABLED $<BOOL:${WIN32}>
)
