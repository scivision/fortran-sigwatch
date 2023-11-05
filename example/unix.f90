program sigs

use, intrinsic :: iso_c_binding, only: C_INT, C_CHAR

implicit none (type, external)

integer :: i, status

interface

integer(C_INT) function watchsignalname(signame, response) bind(C)
import C_INT, C_CHAR
character(kind=c_char), intent(in) :: signame(*)
integer(C_INT), intent(in), value :: response
end function
integer(C_INT) function watchsignal(signum) bind(C)
import C_INT
integer(C_INT), intent(in), value:: signum
end function

integer(C_INT) function getlastsignal() bind(C)
import C_INT
end function

subroutine milli_sleep(millseconds) bind(C, name="c_sleep")
import C_INT
integer(C_INT), intent(in), value :: millseconds
end subroutine

end interface

!! Watch for signal 10 (which is USR1 on this platform):

status = watchsignal(10)
print '("watchsignal 10:",i2)', status


!! Watch for HUP, too:

status = watchsignalname("HUP", 99)
print '("watchsignal HUP:",i2)', status

do i=1,10
  call milli_sleep(500)
  print '("lastsig=", i2)', getlastsignal()
enddo

print '(a)', "Fortran: stopped watching for signals"

end program
