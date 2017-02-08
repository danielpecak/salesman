program test
  use genetics
  use slf_random
  implicit none
real*8  :: x,y
integer, parameter :: N=10
integer  :: v(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
integer :: i

! Turn on a random number generator
call random_init_urandom()
call random_number(x)

print "(10I2)", v
call Shuffle(v)
print "(10I2)", v






x=1.
y=1.
i=1
end program test
