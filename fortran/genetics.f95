module genetics
implicit none
! real*8, parameter :: inf = 1000000000.d0

type group
  real*8  :: fitness  ! values to be sorted by
  integer :: age
  integer, pointer :: chromosome(:)
end type group
contains

! ###################################
! ####    AUXILIARY FUNCTIONS    ####
! ###################################
subroutine group_create(A,genNo)
  type(group)  :: A
  integer, intent(in)  :: genNo
  integer :: i
  allocate(A%chromosome(1:genNo))
  A%chromosome = (/ (i, i=1,genNo) /)
  A%age = 0
end subroutine group_create

subroutine spin_me_round(item)
  type(group)  :: item
  integer :: genNo
  integer :: i
  genNo=size(item%chromosome,1)
  i=minloc(item%chromosome, dim=1)
  item%chromosome=cshift(item%chromosome,i-1)
end subroutine spin_me_round



recursive subroutine QSort(A,nA)
! Type GROUP has been gneralized for purposes of my program, but it's from:
! http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Fortran
  integer, intent(in) :: nA
  type (group), dimension(nA), intent(in out) :: A
  ! LOCAL VARIABLES
  integer :: left, right
  real*8 :: random
  real*8 :: pivot
  type (group) :: temp
  integer :: marker

      if (nA > 1) then
          call random_number(random)
          pivot = A(int(random*real(nA-1))+1)%fitness   ! random pivor (not best performance, but avoids worst-case)
          left = 0
          right = nA + 1

          do while (left < right)
              right = right - 1
              do while (A(right)%fitness < pivot)
                  right = right - 1
              end do
              left = left + 1
              do while (A(left)%fitness > pivot)
                  left = left + 1
              end do
              if (left < right) then
                  temp = A(left)
                  A(left) = A(right)
                  A(right) = temp
              end if
          end do

          if (left == right) then
              marker = left + 1
          else
              marker = left
          end if

          call QSort(A(:marker-1),marker-1)
          call QSort(A(marker:),nA-marker+1)
      end if
end subroutine QSort


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


function mean(list) result(m)
real*8, intent(in) :: list(:)
real*8 :: m
m = sum(list)/size(list)
end function

function variance(list) result(s)
  real*8, intent(in) :: list(:)
  real*8 :: m, s
  m = sum(list)/size(list)
  s = sum((list-m)**2)/size(list)
  s = sqrt(s)
end function variance

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
    a(k) = k+from
  end do!k
  call random_number(r)
  start = a(int(r*(size(a))) + 1)
  do
    call random_number(r)
    k = a(int(r*(size(a))) + 1)
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
  ch1 = -1
  ch2 = -1
  ch1(1) = 1
  ch2(1) = 1
  do i=start,finish
    ch1(i) = p1(i)
    ch2(i) = p2(i)
  enddo!i
  do i=2,len
    if (.not.isElIn(p2(i),ch1)) then
      do j=2,len
        if (ch1(j)==-1) then
          ch1(j) = p2(i)
          exit
        endif
      enddo!j
    endif
    if (.not.isElIn(p1(i),ch2)) then
      do j=2,len
        if (ch2(j)==-1) then
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
subroutine rouletteWheelSelection(fitnesses,p1)
! Chooses parent from the population by the fitness and weighting by the fitness it randomly chooses a parent.
  real*8,  intent(in) :: fitnesses(:)
  integer, intent(out):: p1
  real*8 :: r, total, pick
  integer :: popNo, i
  popNo = size(fitnesses,1)
  total = sum(fitnesses)
  call random_number(r)
  r=r*total
  pick = 0.d0
  do i=1,popNo
    pick = pick + fitnesses(i)
    if (pick > r)  then
      p1=i
      GOTO 11
    endif
  end do!i
11 continue
  ! TODO CHECK
end subroutine rouletteWheelSelection

!### Fitness function
subroutine fitness(population,distance,shift)
  ! Function calculates the fitness of a chromosome 'item'
  type(group), intent(inout) :: population
  real*8,  intent(in)  :: distance(:,:), shift
  integer :: genNo, i
  genNo = size(population%chromosome)
  population%fitness = 0.d0
  do i=1,genNo
    population%fitness = population%fitness + distance(population%chromosome(i),population%chromosome(mod(i,genNo)+1))
  end do!i
  population%fitness = shift - population%fitness
end subroutine fitness


subroutine cycleLength(population,distance)
  ! Function calculates the total length of the path given by a  chromosome ITEM
  type(group), intent(inout) :: population
  real*8,  intent(in)  :: distance(:,:)
  integer :: genNo, i
  genNo = size(population%chromosome,1)
  population%fitness = 0.d0
  do i=1,genNo
    population%fitness = population%fitness + distance(population%chromosome(i),population%chromosome(mod(i,genNo)+1))
  end do!i
end subroutine cycleLength

! ###################################
! ######   POPULATION SCALE    ######
! ###################################
subroutine growPopulation(population,genNo)
!  Grow population of P individuals, everyone with G genes.
  type(group), intent(inout) :: population(:)
  integer, intent(in)  :: genNo
  integer  :: popNo
  integer  :: i
  popNo = size(population)
  do i=1,popNo
    call group_create(population(i),genNo)
    call shuffle(population(i)%chromosome(2:genNo))
  enddo!i
end subroutine growPopulation

end module genetics
