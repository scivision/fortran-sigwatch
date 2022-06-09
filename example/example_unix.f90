module sleep_std
use, intrinsic :: iso_c_binding, only : c_int, c_long
implicit none (type, external)

private
public :: sleep

interface

integer(c_int) function usleep(usec) bind (C)
!! int usleep(useconds_t usec);
!! https://linux.die.net/man/3/usleep
import c_int
integer(c_int), value, intent(in) :: usec
end function usleep
end interface

contains

subroutine sleep(millisec)
integer, intent(in) :: millisec
integer(c_int) :: ierr

ierr = usleep(int(millisec * 1000, c_int))
if (ierr/=0) error stop 'problem with usleep() system call'

end subroutine sleep

end module sleep_std

program sigs

use, intrinsic :: iso_c_binding, only: C_INT, C_CHAR

use sleep_std, only : sleep

implicit none (type, external)

integer :: i, status

interface

integer(C_INT) function watchsignalname(signame, response) bind(C)
import C_INT, C_CHAR
character(kind=c_char), intent(in) :: signame(*)
integer(C_INT), intent(in) :: response
end function watchsignalname
integer(C_INT) function watchsignal(signump) bind(C)
import C_INT
integer(C_INT), intent(in) :: signump
end function watchsignal

integer(C_INT) function getlastsignal() bind(C)
import C_INT
end function getlastsignal

end interface

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
