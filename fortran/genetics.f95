module genetics
implicit none
contains

subroutine shuffle(a)
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
end subroutine shuffle

subroutine pick_range(from,to,start,finish)
  ! Modified version of:
  ! http://rosettacode.org/wiki/Pick_random_element#Fortran
  integer, intent(in)  :: from, to
  integer, intent(out) :: start, finish
  integer, allocatable :: a(:)
  integer :: k
  real*8  :: r

  allocate(a(to-from))
  do k=1, to-from
    a(k) = k+from-1
  end do!k

  call random_number(r)
  start = a(int(r*size(a)) + 1)
  do
    call random_number(r)
    k = a(int(r*size(a)) + 1)
    if (k>start) then
      finish = k
      exit
    elseif (k<start) then
      finish = start
      start = k
      exit
    end if
  end do
end subroutine

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
