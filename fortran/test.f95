program test
  use helpers
  use genetics
  use slf_random
  implicit none
real*8  :: x,y
integer, parameter :: N=10, M=10**3
integer  :: v(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
integer  :: w(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
integer :: ch1(1:N)=0, ch2(1:N)=0
integer :: i,j,k
logical :: flag_shuffle  =.true.
logical :: flag_pickrange=.true.
logical :: flag_scramble =.true.
logical :: flag_inversion=.true.
logical :: flag_DavisOX1 =.true.

! Turn on a random number generator
call random_init_urandom()
call random_number(x)



print *, "# ======= Testing: SHUFFLE function"
! print "(A,10I2)", " # Starting chromosome: ",v
! print *, "# ======="
do i=1,M
  call shuffle(v(2:N))
  ! print "(A,10I2)", "  ",v
  if(.not.chromosomeCorrect(v)) then 
    print "(A,I6,A,L3)","# Check validity of iteration no ", i,": ", chromosomeCorrect(v)
    flag_shuffle=.false.
  endif
enddo
if(flag_shuffle) print *, "# SHUFFLE function correct."
print *, "# ======="



v(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
print *, "# ======= Testing: PICK_RANGE function"
! print "(A,10I2)", " # Starting chromosome: ",v
! print *, "# ======="
do i=1,M
  call pick_range(1,N,j,k)
  ! print "(A,10I2,4I3)", "  ",v, 1,j,k,N
  if(.not.chromosomeCorrect(v)) then 
    print "(A,I6,A,L3)","# Check validity of iteration no ", i,": ", chromosomeCorrect(v)
    flag_pickrange=.false.
  endif
enddo
if(flag_pickrange) print *, "# PICK_RANGE function correct."
print *, "# ======="



v(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
print *, "# ======= Testing: ScrambleMutation function"
! print "(A,10I2)", " # Starting chromosome: ",v
! print *, "# ======="
do i=1,M
  call ScrambleMutation(v)
  if(.not.chromosomeCorrect(v)) then 
    print "(A,I6,A,L3)","# Check validity of iteration no ", i,": ", chromosomeCorrect(v)
    flag_scramble=.false.
  endif
enddo
if(flag_scramble) print *, "# ScrambleMutation function correct."
print *, "# ======="




v(1:N) = (/1,2,3,4,5,6,7,8,9,0/)
print *, "# ======= Testing: InversionMutation function"
! print "(A,10I2)", " # Starting chromosome: ",v
! print *, "# ======="
do i=1,M
  call InversionMutation(v)
  ! print "(A,10I2)", " ",v
  if(.not.chromosomeCorrect(v)) then 
    print "(A,I6,A,L3)","# Check validity of iteration no ", i,": ", chromosomeCorrect(v)
    flag_inversion=.false.
  endif
enddo
if(flag_inversion) print *, "# InversionMutation function correct."
print *, "# ======="




print *, "# ======= Testing: CrossoverOX1 function"
! print "(A,10I2)", " # Starting chromosome: ",v
! print *, "# ======="
! print "(A,10I2)", " ",v
! print "(A,10I2)", " ",w
! print "(A,10I2)", " ",ch1
! print "(A,10I2)", " ",ch2
! print *, "-------"
! call CrossoverOX1(v,w,ch1,ch2)
! print "(A,10I2)", " ",v
! print "(A,10I2)", " ",w
! print "(A,10I2)", " ",ch1
! print "(A,10I2)", " ",ch2
do i=1,M
  call CrossoverOX1(v,w,ch1,ch2)
  if(.not.(chromosomeCorrect(v).or.chromosomeCorrect(w).or.chromosomeCorrect(ch1).or.chromosomeCorrect(ch2))) then 
    print "(A,I6,A,L3)","# Check validity of iteration no ", i,": ", chromosomeCorrect(v)
    flag_DavisOX1=.false.
  endif
enddo
if(flag_DavisOX1) print *, "# CrossoverOX1 function correct."
print *, "# ======="


x=1.
y=1.
i=1
end program test
