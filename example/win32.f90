program sigs

use, intrinsic :: iso_c_binding, only: C_INT

implicit none (type, external)

integer :: i, status

interface
integer(C_INT) function watchsignal(sig) bind(C)
import C_INT
integer(C_INT), intent(in), value :: sig
end function

integer(C_INT) function getlastsignal() bind(C)
import C_INT
end function

subroutine milli_sleep(millseconds) bind(C, name="c_sleep")
import C_INT
integer(C_INT), intent(in), value :: millseconds
end subroutine

end interface

!! do ^C once to get a signal. The second time stops the program.
status = watchsignal(2)
print '("watchsignal 2:",i2)', status


do i=1,10
  call milli_sleep(500)
  print '("lastsig=", i2)', getlastsignal()
enddo

print '(a)', "Fortran: stopped watching for signals"

end program
