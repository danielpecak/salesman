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

function pick_random(a) result(i)
  ! Slightly modified version of:
  ! http://rosettacode.org/wiki/Pick_random_element#Fortran
  integer, intent(in) :: a(:)
  integer :: i
  real*8  :: r

  call random_number(r)
  i = a(int(r*size(a)) + 1)
end function

! ###################################
! ######      GENOM SCALE      ######
! ###################################
! ### MUTATION
subroutine ScrambleMutation(item)
! Mutation that shuffles randomly the genes.
  integer, intent(inout) :: item(:)
  integer :: len
  len = size(item,1)


end subroutine ScrambleMutation

end module genetics
