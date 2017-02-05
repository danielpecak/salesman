program galgorithm
  use genetics
  use cities
  use slf_random
  implicit none
  real*8  :: x
  real*8  ::  southAmerica(2,13) ! change name to PLACES everywhere
  real*8  ::  distances(13,13)
  type(group), allocatable  :: population(:), temppop(:)
  integer :: time = 1000, popNo = 1000
  real*8  :: xmen = 0.001d0
  real*8  :: meanCase = 55000.d0
  integer  :: i,t,p,p1,p2, genNo
  ! Turn on a random number generator
  call random_init_urandom()
  !!! System DEFAULT parameters:
  ! TODO

  !!! Command line
  ! TODO
  !!! Load favourite places
  ! TODO
  ! Load SOUTH AMERICA
  include 'data/sa.f'
  call calcDistances(southAmerica,distances)

  !!! Set population & heuristics
  ! TODO
  genNo = size(southAmerica,2)
  popNo = 10
  allocate(temppop(popNo)) ! auxilary population
  do i=1,popNo
    call group_create(temppop(i),genNo)
  enddo!i
  allocate(population(popNo)) !
  call growPopulation(population,genNo)

  do p=1,popNo
    call fitness(population(p),distances,meanCase)
  enddo!p
  call QSort(population,popNo)


  !!! Fitness Base Selection
  ! TODO
  do t=1,time
    do i=1,popNo
      temppop(i)%chromosome = 0
    enddo
    if (mod(t,time/10)==0) print *, "Generation #",t,"out of",time
    do p=1,popNo
      call fitness(population(p),distances,meanCase)
    enddo!p
    call QSort(population,popNo)
    do p=1,popNo/2
      ! Pick parents
      call rouletteWheelSelection(population(:)%fitness,p1)
      call rouletteWheelSelection(population(:)%fitness,p2)
      ! Breed chromosomes using Crossover
      call CrossoverOX1(population(p1)%chromosome,population(p2)%chromosome,temppop(p)%chromosome,temppop(p+popNo/2)%chromosome)
      ! Apply mutation with some probability 'XMEN'
      call random_number(x)
      if (x<xmen) call ScrambleMutation(temppop(p)%chromosome)
      call random_number(x)
      if (x<xmen) call ScrambleMutation(temppop(p+popNo/2)%chromosome)
      call random_number(x)
      if (x<xmen) call InversionMutation(temppop(p)%chromosome)
      call random_number(x)
      if (x<xmen) call InversionMutation(temppop(p+popNo/2)%chromosome)
    enddo!p
    ! Copy temp population
    do i=1,popNo
      population(i)%chromosome = temppop(i)%chromosome
    enddo
  enddo!t
  !!! Save data
  ! TODO


end program galgorithm
