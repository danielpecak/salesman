program test
  use genetics
  use cities
  use slf_random
  implicit none
  ! real*8, parameter :: inf = 1.d12
real*8  :: x,y
! integer, parameter :: N=10
! integer  :: v(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
! integer  :: w(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
integer  :: i,j,k
! integer  :: pop(5,10)
type(group), allocatable :: pop(:)
real*8, allocatable  ::  places(:,:), distances(:,:)
integer  :: genNo, popNo

include 'data/sa.f'
genNo = size(places,2)
popNo=genNo
allocate(distances(genNo,genNo))
call calcDistances(places,distances)
allocate(pop(popNo))
do i=1,popNo
  call group_create(pop(i),genNo)
  print "(13I3)", pop(i)%chromosome
enddo

call getHeuristicSolutions(pop,distances)
call QSort(pop,popNo)
do i=1,popNo
  print "(13I3,F10.1,I3)", pop(i)%chromosome, pop(i)%fitness, pop(i)%age
enddo



! print *, "genNo: ", genNo
! print *, inf
! do i=1,genNo
!   do j=1,genNo
!     if(i<j) distances(i,j)=inf
!   enddo
! enddo
! x = 0.d0
! do i=1,genNo
!   ! print "(13F10.1)", distances(i,:)
!   j=minloc(distances(i,:))
!   print *, i, minval(distances(i,:))
! enddo
! print

stop
print *, "=============================="
print *, "=============================="
print *, "This is a testing unit. Here all sort of functions will be tested."
print *, "=============================="

! Turn on a random number generator
call random_init_urandom()
call random_number(x)

print *, "=============================="
print *, "Module GENETICS"
print *, "=============================="
print *, " === GENOM SCALE ==="
print *, "Function: ScrambleMutation"
print *, "Function: InversionMutation"
print *, "Function: CrossoverOX1"
print *, " === INDIVIDUAL SCALE ==="
print *, "Function: rouletteWheelSelection"
print *, "Function: fitness"
print *, "Function: cycleLength"
print *, " === POPULATION SCALE ==="
print *, "Function: growPopulation"

! call growPopulation(pop)
! do i=1,size(pop,2)
!   print "(5I2)", (pop(j,i), j=1,size(pop,1))
! end do!i
print *, "Function: getHeuristicSolutions"


x=1.
y=1.
i=1
j=1
k=1

end program test
