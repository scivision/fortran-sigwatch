program sigs

implicit none (type, external)

integer i
integer status

integer watchsignal
integer watchsignalname
integer getlastsignal

!! you can do ^C once to get a signal. The second time stops the program.
status = watchsignal(2)
print '("watchsignal 10:",i2)', status


do i=1,10
  call sleep(1)
  print '("lastsig=", i2)', getlastsignal()
enddo

print *, "Fortran: stopped watching for signals"

end program
