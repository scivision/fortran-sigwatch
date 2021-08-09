program sigs

implicit none (type, external)

integer i
integer status

integer watchsignal
integer watchsignalname
integer getlastsignal

!! Watch for signal 10 (which is USR1 on this platform):

status = watchsignal(10)
print '("watchsignal 10:",i2)', status


!! Watch for HUP, too:

status = watchsignalname("HUP", 99)
print '("watchsignal HUP:",i2)', status

do i=1,10
  call sleep(1)
  print '("lastsig=", i2)', getlastsignal()
enddo

print *, "Fortran: stopped watching for signals"

end program
