program galgorithm
  use OMP_LIB
  use genetics
  use helpers
  use cities
  use slf_random
  implicit none
  real*8  :: x
  type(group), allocatable  :: population(:), temppop(:)
  real*8, allocatable  ::      places(:,:), distances(:,:)
  character(len=256)   :: filenameTime
  character(len=256)   :: filenameDat
  character(len=128)   :: format
  integer :: time  = 1000,&
             popNo = 1000
  real*8  :: xmen  = 0.001d0
  logical :: flag_new = .false., file_exists
  real*8  :: meanCase
  integer  :: i,t,p,p1,p2, genNo
  integer  :: dt, time0, IOS
  real*8   :: data(1:200)



  ! Turn on a random number generator
  call random_init_urandom()
  !!! System DEFAULT parameters:
  ! TODO
  
  !!! Command line/input file
  ! https://rosettacode.org/wiki/Read_a_configuration_file#Fortran
  ! TODO init file?
  call getArgInt('-P',popNo)
  call getArgInt('-T',time)
  call getArgReal('-X',xmen)
  call getArgLogical('-n',flag_new)
  !!! Check variables
  if(mod(popNo,2)==1) stop('POPNO has to be even!')
  if(time<1) stop('TIME has to be positive integer!')
  if(popNo<1) stop('POPULATION has to be positive integer!')
  if((xmen>1).or.(xmen<0)) stop('XMEN has to be in range (0,1)!')
  
  !!! Load favourite places
  ! Choose from: af.f  all.f  ao.f  as.f  eu.f  na.f  sa.f
  ! Africa, World, Australia&Oceania, Asia, Europe, North America, South America
  ! Load SOUTH AMERICA
  include 'data/sa.f'
  genNo = size(places,2)
  write(format,"(A,I3,A)") "(", genNo,"I4,I6,F12.4)"
  allocate(distances(genNo,genNo))
  call calcDistances(places,distances)

  !!! Set population & heuristics
  ! TODO
  allocate(temppop(popNo)) ! auxilary population
  do p=1,popNo
    call group_create(temppop(p),genNo)
  enddo!p
  allocate(population(popNo)) !
  call growPopulation(population,genNo)

  

  !!! Fitness Base Selection
  ! TODO

  ! Setting up files
  write(filenameTime,"(A,I0.6,A,F4.2,A)") 'output/time_P', popNo, '_X',xmen, '.txt'
  print "(A,A)","# Writing to: ",trim(filenameTime)
  INQUIRE(FILE=trim(filenameTime), EXIST=file_exists)
  if((.not.file_exists).or.(flag_new)) then 
      open(1,file=trim(filenameTime),status='replace',action='write')
      write(1,*) "# Time   Mean   Variance"
      close(1)
      time0=0
    else ! Check what was the number in last simulation
      open(1,file=trim(filenameTime),status='OLD')
      IOS=0
      read(1,*) ! Ignore first line with description of 
      do while (IOS.eq.0)
        read(1,*,iostat=IOS) time0
      end do
      print "(A, I8)", "# Time0 read from the file: ",time0
      close(1)
      write(filenameDat,"(A,I0.6,A,F4.2,A,I0.6,A)") 'output/configuration_P', popNo, '_X',xmen, '_T', time0, '.dat'
      open(1,file=trim(filenameDat),status='OLD')
      do p=1,popNo
        read(1,trim(format)) population(p)%chromosome(:), population(p)%age, population(p)%fitness
      enddo
      close(1)
  endif
  
  do p=1,popNo
    call cycleLength(population(p),distances)
  enddo!p
  meanCase = mean(population(:)%fitness)

do p=1,10
  print trim(format), population(p)%chromosome(:), population(p)%age, population(p)%fitness
enddo

! stop

  ! DATA
  dt = time/size(data)
  if(time<size(data)) dt = 1
  dt = 5
  do t=time0+1,time0+time
    if (mod(t,time/10)==0) print "(A,I8,A,I8)", "# Generation NO",t," out of",time+time0
    do p=1,popNo
      call calcFitness(population(p),distances,meanCase)
    enddo!p
    call QSort(population,popNo)
    !$OMP PARALLEL PRIVATE(p,x)
    !$OMP DO
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
      temppop(p)%age = population(p)%age
      temppop(p+popNo/2)%age = population(p+popNo/2)%age
    enddo!p
    !$OMP END DO
    !$OMP END PARALLEL
    ! Copy temp population
    do p=1,popNo
      population(p)%chromosome = temppop(p)%chromosome
    enddo!p
    if(mod(t,dt)==0) then
      open(1,file=trim(filenameTime),action='write',access='append')
        write(1,*) t, meanCase - mean(population(:)%fitness), variance(population(:)%fitness)
      close(1)
    endif
  enddo!t
  
  !!! Save data
  ! TODO
  write(filenameDat,"(A,I0.6,A,F4.2,A,I0.6,A)") 'output/configuration_P', popNo, '_X',xmen, '_T', time0+time, '.dat'
  print "(A)", "# Calculation finished. Last configuration is saved to: ", trim(filenameDat)
  open(1,file=trim(filenameDat),action='write',status='replace')
  do p=1,popNo
    call cycleLength(population(p),distances)
    write(1,trim(format)) population(p)%chromosome(:), population(p)%age, population(p)%fitness
  enddo
  close(1)

  do p=1,10
    print trim(format), population(p)%chromosome(:), population(p)%age, population(p)%fitness
  enddo


end program galgorithm
