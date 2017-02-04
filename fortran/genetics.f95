module genetics
implicit none
real*8, parameter :: inf = 1000000000.d0
contains

function isElIn(item,list) result(is)
  integer, intent(in) :: list(:), item
  integer :: i
  logical :: is
  is=.false.
  do i=1,size(list)
    if (list(i) == item) then
      is=.true.
    endif
  end do

end function isElIn

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
  do k=1, to-from+1
    a(k) = k+from-1
  end do!k
  call random_number(r)
  start = a(int(r*(size(a)+1)) + 1)
  do
    call random_number(r)
    k = a(int(r*(size(a)+1)) + 1)
    if (k>start) then
      finish = k
      exit
    elseif (k<start) then
      finish = start
      start = k
      exit
    end if
  end do
end subroutine pick_range

! ###################################
! ######      GENOM SCALE      ######
! ###################################
! ### MUTATION
subroutine ScrambleMutation(item)
! Mutation that shuffles randomly the genes.
  integer, intent(inout) :: item(:)
  integer :: len, start,finish
  len = size(item,1)
  call pick_range(2,len,start,finish)
  call shuffle(item(start:finish))
end subroutine ScrambleMutation

subroutine InversionMutation(item)
  ! Mutation that invertes random sequence of genes.
  integer, intent(inout) :: item(:)
  integer :: len, start,finish , i, temp
  len = size(item,1)
  call pick_range(2,len,start,finish)
  ! Inverse given range of genes
  do i=start,(finish+start-1)/2
    temp = item(i)
    item(i) = item(finish+start-i)
    item(finish+start-i) = temp
  end do!i
end subroutine InversionMutation

!### Davis' Order Crossover (O1)
subroutine CrossoverOX1(p1,p2,ch1,ch2)
!Applies so called Davis' Order Crossover OX1 for permutation based crossovers.
  integer, intent(in)  :: p1(:), p2(:)
  integer, intent(out) :: ch1(:), ch2(:)
  integer :: len, start, finish, i, j
  len = size(ch1)
  call pick_range(2,len,start,finish)
  print *, start, finish
  ch1 = 0
  ch2 = 0
  ch1(1) = 1
  ch2(1) = 1
  do i=start,finish
    ch1(i) = p1(i)
    ch2(i) = p2(i)
  enddo!i
  do i=2,len
    if (.not.isElIn(p2(i),ch1)) then
      do j=1,len
        if (ch1(j)==0) then
          ch1(j) = p2(i)
          exit
        endif
      enddo!j
    endif
    if (.not.isElIn(p1(i),ch2)) then
      do j=1,len
        if (ch2(j)==0) then
          ch2(j) = p1(i)
          exit
        endif
      enddo!j
    endif
  enddo!i
end subroutine CrossoverOX1

! ###################################
! ######    INDIVIDUAL SCALE    #####
! ###################################
! ### Choose parents
!### Fitness function
subroutine fitness(item,distance,shift,total)
  ! Function calculates the fitness of a chromosome 'item'
  integer, intent(in)  :: item(:)
  real*8,  intent(in)  :: distance(:,:), shift
  real*8,  intent(out) :: total
  integer :: genNo, i
  genNo = size(item,1)
  total = 0.d0
  do i=1,genNo
    total = total + distance(item(i),item(mod(i,genNo)+1))
  end do!i
  total = shift - total
end subroutine fitness


subroutine cycleLength(item,distance,total)
  ! Function calculates the total length of the path given by a  chromosome ITEM
  integer, intent(in)  :: item(:)
  real*8,  intent(in)  :: distance(:,:)
  real*8,  intent(out) :: total
  integer :: genNo, i
  genNo = size(item,1)
  total = 0.d0
  do i=1,genNo
    total = total + distance(item(i),item(mod(i,genNo)+1))
  end do!i
end subroutine cycleLength

! ###################################
! ######   POPULATION SCALE    ######
! ###################################
subroutine growPopulation(population)
!  Grow population of P individuals, everyone with G genes.
  integer, intent(inout) :: population(:,:)
  integer  :: popNo, genNo
  integer  :: i, j
  popNo = size(population,2)
  genNo = size(population,1)
  do i=1,popNo
    population(:,i) = (/ (j, j=1,genNo) /)
    call shuffle(population(2:genNo,i))
  enddo!i
end subroutine growPopulation

end module genetics
