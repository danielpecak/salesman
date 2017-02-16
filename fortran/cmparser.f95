module cmparser
implicit none
contains
    subroutine getArgReal(tag,var)
      character(len=*), intent(in) :: tag
      character(len=10) :: temptag
      real*8, intent(out)          :: var
      integer :: i
      integer :: narg
      narg=command_argument_count()

      do i=1,narg
        call get_command_argument(i,temptag)
        if(trim(tag).eq.trim(temptag)) then
          call get_command_argument(i+1,temptag)
          read(temptag,'(F32.0)') var
          exit
        endif
      end do
  end subroutine getArgReal

  subroutine getArgInt(tag,var)
    character(len=*), intent(in) :: tag
    character(len=10) :: temptag
    integer, intent(out)          :: var
    integer :: i
    integer :: narg
    narg=command_argument_count()

    do i=1,narg
      call get_command_argument(i,temptag)
      if(trim(tag).eq.trim(temptag)) then
        call get_command_argument(i+1,temptag)
        read(temptag,'(I12)') var
        exit
      endif
    end do
endsubroutine getArgInt

subroutine getRange(range)
  real*8, pointer :: range(:)
  integer :: n
  real*8  :: min, dx
  character(len=10) :: temptag
  integer :: narg, i, j
  narg=command_argument_count()
  do i=1,narg
    call get_command_argument(i,temptag)
    if(trim("--range").eq.trim(temptag)) then
      call get_command_argument(i+1,temptag)
      read(temptag,'(F32.0)') min
      call get_command_argument(i+2,temptag)
      read(temptag,'(F32.0)') dx
      call get_command_argument(i+3,temptag)
      read(temptag,'(I2)') n
      allocate(range(n))
      do j=1,n
        range(j) = dx*(j-1) + min
      end do!j
      return
    endif
  end do!i
  print *, "There is no RANGE specified!"
  call exit
endsubroutine getRange

subroutine getArgLogical(tag,var)
  character(len=*), intent(in) :: tag
  character(len=10) :: temptag
  logical, intent(out)          :: var
  integer :: i
  integer :: narg
  narg=command_argument_count()

  do i=1,narg
    call get_command_argument(i,temptag)
    if(trim(tag).eq.trim(temptag)) then
      var = .true.
      exit
    endif
  end do!i
endsubroutine getArgLogical


subroutine notify(prog)
  implicit none
  character(len=*), intent(in) :: prog
  character(len=10000) :: mess
  write(mess,*) "notify-send 'Program ",trim(prog)," zakończył się'"
  call system(trim(mess))
end subroutine notify

end module cmparser
