module genetics
implicit none
contains

subroutine Shuffle(a)
  ! http://rosettacode.org/wiki/Knuth_shuffle#Fortran
  integer, intent(inout) :: a(:)
  integer :: i, randpos, temp
  real :: r
  do i = size(a), 2, -1
    call random_number(r)
    randpos = int(r * i) + 1
    temp = a(randpos)
    a(randpos) = a(i)
    a(i) = temp
  end do
end subroutine Shuffle


end module genetics
