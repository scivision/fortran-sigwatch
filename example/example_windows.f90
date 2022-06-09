module sleep_std
use, intrinsic :: iso_c_binding, only : c_int, c_long
implicit none (type, external)

private
public :: sleep

interface
subroutine winsleep(dwMilliseconds) bind (C, name='Sleep')
!! void Sleep(DWORD dwMilliseconds)
!! https://docs.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-sleep
import c_long
integer(c_long), value, intent(in) :: dwMilliseconds
end subroutine winsleep

end interface

contains

subroutine sleep(millisec)
integer, intent(in) :: millisec

call winsleep(int(millisec, c_long))

end subroutine sleep

end module sleep_std

program sigs

use, intrinsic :: iso_c_binding, only: C_INT

use sleep_std, only : sleep

implicit none (type, external)

integer :: i, status

interface
integer(C_INT) function watchsignal(sig) bind(C)
import C_INT
integer(C_INT), intent(in) :: sig
end function watchsignal

integer(C_INT) function getlastsignal() bind(C)
import C_INT
end function getlastsignal

end interface

!! you can do ^C once to get a signal. The second time stops the program.
status = watchsignal(2)
print '("watchsignal 10:",i2)', status


do i=1,10
  call sleep(1)
  print '("lastsig=", i2)', getlastsignal()
enddo

print *, "Fortran: stopped watching for signals"

end program
