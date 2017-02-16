module myio
implicit none
contains
subroutine fnameSnapshot(continent,popNo,xmen,t)
  ! Makes the name of the snapshot to save.
  character(len=*),intent(in) :: continent
  integer, intent(in) :: popNo, t
  real*8, intent(in)  :: xmen
  character(len=200)  :: var
  write(var,"(A)") trim(continent)
  write(var,"(A,A,I6.6)") trim(var), '_P', int(popNo/1000.d0)
  write(var,"(A,A,F0.6)") trim(var), '_X', xmen*1000.d0
  write(var,"(A,A,I6.6)") trim(var), '_T', int(t/100.d0)

  ! print "(A,I0.5,f8.4,I0.5)", continent, popNo/1000, xmen*1000.d0, t/100
  print *, trim(var)
end subroutine fnameSnapshot

subroutine saveSnapshot()
  print *, "Hello"
  continue
end subroutine saveSnapshot

subroutine loadSnapshot()
  print *, "Hello"
  continue
end subroutine loadSnapshot

subroutine lastSnapshot()
  print *, "Hello"
  continue
end subroutine lastSnapshot

end module myio
