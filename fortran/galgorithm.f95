program galgorithm
  use genetics
  use cities
  use slf_random
  implicit none
  real*8  :: x,y
  real*8  ::  southAmerica(2,12)
  real*8  ::  distances(12,12)
  integer, allocatable  :: population(:,:)
  real*8,  allocatable  :: fitnesses(:)
  integer :: time = 1000, popNo = 1000
  real*8  :: xmen = 0.001d0
  real*8  :: meanCase = 50000.d0
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
  southAmerica(:,1) = (/ -0.6040584541d0,-1.0189232173d0 /)
  southAmerica(:,2) = (/ -0.3321361567d0,-1.1390018699d0 /)
  southAmerica(:,3) = (/ -0.275412956d0 ,-0.8365363105d0 /)
  southAmerica(:,4) = (/ -0.5839871677d0,-1.2330751165d0 /)
  southAmerica(:,5) = (/  0.0804596785d0,-1.2929399099d0 /)
  southAmerica(:,6) = (/ -0.0040142573d0,-1.3704325287d0 /)
  southAmerica(:,7) = (/ -0.9023352233d0,-1.0096729723d0 /)
  southAmerica(:,8) = (/  0.1186823891d0,-1.015083493d0  /)
  southAmerica(:,9) = (/ -0.4415683008d0,-1.0060077808d0 /)
  southAmerica(:,10)= (/ -0.2101376419d0,-1.3444271228d0 /)
  southAmerica(:,11)= (/  0.1024508271d0,-0.9628981483d0 /)
  southAmerica(:,12)= (/ -0.6078981785d0,-0.9803514408d0 /)
  southAmerica(:,12)= (/  0.1830850385d0,-1.1672762037d0 /)
  call calcDistances(southAmerica,distances)

  !!! Set population & heuristics
  ! TODO
  genNo = size(southAmerica,2)
  allocate(population(genNo,popNo))
  allocate(fitnesses(popNo))
  call growPopulation(population)

  !!! Fitness Base Selection
  ! TODO
  do t=1,time
    do p=1,popNo
      call fitness(population(:,p),distances,meanCase,fitnesses(p))
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
