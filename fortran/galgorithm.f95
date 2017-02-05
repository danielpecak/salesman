program galgorithm
  use genetics
  use cities
  use slf_random
  implicit none
  real*8  :: x,y
  real*8  ::  southAmerica(2,13)
  real*8  ::  distances(13,13)
  integer :: ch1(13), ch2(13)
  type(group), allocatable  :: population(:), temppop(:)
  integer :: time = 1000, popNo = 1000
  real*8  :: xmen = 0.001d0
  real*8  :: meanCase = 55000.d0
  integer  :: i,j,k,t,p,p1,p2, genNo
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

  !!! Fitness Base Selection
  ! TODO
  do t=1,time
    if (mod(t,time/10)==0) print *, "Generation #",t,"out of",time
    do p=1,popNo
      call fitness(population(p),distances,meanCase)
    enddo!p
    do p=1,popNo/2
      ! Pick parents
      call rouletteWheelSelection(population(:)%fitness,p1)
      call rouletteWheelSelection(population(:)%fitness,p2)
      ! Breed chromosomes using Crossover
      call CrossoverOX1(population(p1)%chromosome,population(p2)%chromosome,ch1,ch2)
      ! Apply mutation with some probability 'XMEN'
      call random_number(x)
      if (x<xmen) call ScrambleMutation(temppop(p)%chromosome)
      call random_number(x)
      if (x<xmen) call ScrambleMutation(temppop(p+popNo/2)%chromosome)
      call random_number(x)
      if (x<xmen) call InversionMutation(temppop(p)%chromosome)
      call random_number(x)
      if (x<xmen) call InversionMutation(temppop(p+popNo/2)%chromosome)
      x=xmen
    enddo!p
    population = temppop
  enddo!t
  !!! Save data
  ! TODO

  x=1.
  y=1.
  i=1
  j=1
  k=1
end program galgorithm
