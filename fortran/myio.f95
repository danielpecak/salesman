module myio
  use genetics
implicit none
contains
subroutine fnameSnapshot(continent,popNo,xmen,t,output)
  ! Makes the name of the snapshot to save.
  character(len=*),intent(in)  :: continent
  character(len=200),intent(out) :: output
  integer, intent(in) :: popNo, t
  real*8, intent(in)  :: xmen

  write(output,"(A)") trim(continent)
  write(output,"(A,A,I6.6)") trim(output), '_P', int(popNo/1000.d0)
  write(output,"(A,A,F0.6)") trim(output), '_X', xmen*1000.d0
  write(output,"(A,A,I6.6)") trim(output), '_T', int(t/100.d0)
end subroutine fnameSnapshot

subroutine saveSnapshot(continent,popNo,xmen,t,population,bestpopulation)
  ! Saves progess during the process.
  character(len=*),intent(in)  :: continent
  integer, intent(in)    :: popNo, t
  real*8,  intent(in)    :: xmen
  type(group),intent(in) :: population(:), bestpopulation(:)
  character(len=200)     :: fname, fname2
  integer :: l, i

  l = size(population(1)%chromosome)
  call fnameSnapshot(continent,popNo,xmen,t,fname)
  write(fname2,"(A,A)") 'snapshot/',trim(fname)
  open(unit=10, status='replace', file=trim(fname2), form='unformatted')
  write(10) population(1:popNo)%fitness
  write(10) population(1:popNo)%age
  do i=1,popNo
    write(10) population(i)%chromosome(1:l)
  enddo!i
  write(10) bestpopulation(1:popNo)%fitness
  write(10) bestpopulation(1:popNo)%age
  do i=1,popNo
    write(10) bestpopulation(i)%chromosome(1:l)
  enddo!i
  close(10)
end subroutine saveSnapshot

subroutine loadSnapshot(continent,popNo,xmen,t,population,bestpopulation)
  ! Loads saved progess.
  character(len=*),intent(in)  :: continent
  integer, intent(in)    :: popNo, t
  real*8,  intent(in)    :: xmen
  type(group),intent(out):: population(:), bestpopulation(:)
  character(len=200)     :: fname, fname2
  integer :: l, i

  l = size(population(1)%chromosome)
  call fnameSnapshot(continent,popNo,xmen,t,fname)
  write(fname2,"(A,A)") 'snapshot/',trim(fname)
  open(unit=10, status='old', file=trim(fname2), form='unformatted')
  read(10) population(1:popNo)%fitness
  read(10) population(1:popNo)%age
  do i=1,popNo
    read(10) population(i)%chromosome(1:l)
  enddo!i
  read(10) bestpopulation(1:popNo)%fitness
  read(10) bestpopulation(1:popNo)%age
  do i=1,popNo
    read(10) bestpopulation(i)%chromosome(1:l)
  enddo!i
  close(10)
end subroutine loadSnapshot

subroutine lastSnapshot()
  print *, "Hello"
end subroutine lastSnapshot

end module myio
