program galgorithm
  use genetics
  use cities
  use slf_random
  implicit none
  real*8  :: x,y
  real*8  ::  southAmerica(2,13)
  real*8  ::  distances(13,13)
  integer :: ch1(13), ch2(13)
  type(group), allocatable  :: population(:)
  integer :: time = 1000, popNo = 1000
  real*8  :: xmen = 0.001d0
  real*8  :: meanCase = 55000.d0
  integer  :: i,j,k,t,p, genNo
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
  allocate(population(popNo))
  ! allocate(fitnesses(popNo))
  call growPopulation(population,genNo)

  !!! Fitness Base Selection
  ! TODO
  do t=1,time
    if (mod(t,time/10)==0) print *, "Generation #",t,"out of",time
    do p=1,popNo
      call fitness(population(i),distances,meanCase)
    enddo!p

    do p=1,popNo/2
      x=xmen
    enddo!p
  enddo!t
  !!! Save data
  ! TODO

  x=1.
  y=1.
  i=1
  j=1
  k=1
end program galgorithm
