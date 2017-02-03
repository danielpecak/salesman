program test
  use functions
  use slf_random
  implicit none
real*8  :: x,y
integer :: i

call random_init_urandom()
do i=1,10**5
  call random_number(x)
  call random_number(y)
  if (x<1.d-5) then
    print *, x
  endif
  if (y<1.d-5) then
    print *, y
  endif
enddo
end program test
