program galgorithm
  use genetics
  use cities
  use myio
  use cmparser
  use slf_random
  implicit none
  real*8  :: x
  real*8, allocatable  ::  places(:,:), distances(:,:)
  type(group), allocatable  :: population(:), temppop(:)
  integer :: time  = 1000,&
             popNo = 1000
  real*8  :: xmen = 0.001d0
  real*8  :: meanCase
  integer  :: i,t,p,p1,p2, genNo
  integer  :: dt
  real*8   :: data(1:200)



  ! Turn on a random number generator
  call random_init_urandom()

  !!! Command line
  call getArgInt('-pop',popNo)
  call getArgInt('--population',popNo)
  if (popNo < 1000) stop "Spawn more overlords (population should be greater than 1000)!"
  call getArgInt('-t',time)
  call getArgInt('--time',time)
  if (time < 100) stop "Need more time! Use multplicity of 100 generations!"
  call getargReal('-x',xmen)
  call getargReal('-prob',xmen)
  call getargReal('--probability',xmen)
  if (xmen > 1.d-3) stop "Hey, Hulk! Need less radiation (less than 0.001 chance of mutation)!"
  !!! Load favourite places
  ! TODO
  ! Load SOUTH AMERICA
  include 'data/eu.f'
  genNo = size(places,2)
  allocate(distances(genNo,genNo))
  call calcDistances(places,distances)

  !!! Set population & heuristics
  ! TODO
  allocate(temppop(popNo)) ! auxilary population
  do i=1,popNo
    call group_create(temppop(i),genNo)
  enddo!i
  allocate(population(popNo)) !
  call growPopulation(population,genNo)
  do i=1,popNo
    call cycleLength(population(i),distances)
  enddo!i
  meanCase = mean(population(:)%fitness)
  ! DATA
  dt = time/size(data)


  !!! Fitness Base Selection
  ! TODO
  do t=1,time
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
    if(mod(t,dt)==0) then
      open(1,file='time.dat',action='write',access='append')
        write(1,*) t, meanCase - mean(population(:)%fitness), variance(population(:)%fitness)
      close(1)
    endif
  enddo!t
  !!! Save data
  ! TODO

  ! do i=1,10
  !   print "(39I3)", population(i)%chromosome
  ! enddo

end program galgorithm
