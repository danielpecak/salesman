module helpers
  use genetics
implicit none
real*8, parameter :: inf = 10.d12

contains
  !> @brief getting a real number from the argument of the program
  subroutine getArgReal(tag,var)
    character(len=*), intent(in) :: tag  !< tag/flag in the command line
    real*8, intent(out)          :: var  !< a real value to assign to the tag
    character(len=10)  :: temptag
    integer  :: i
    integer  :: narg
    narg=command_argument_count()

    do i=1,narg
      call get_command_argument(i,temptag)
      if(trim(tag).eq.trim(temptag)) then
        call get_command_argument(i+1,temptag)
        read(temptag,'(F6.0)') var
        exit
      endif
    end do
  end subroutine getArgReal

  !> @brief getting an integer number from the argument of the program
  subroutine getArgInt(tag,var)
    character(len=*), intent(in) :: tag  !< tag/flag in the command line
    integer, intent(out)         :: var  !< an integer value to assign to the tag
    character(len=10)     :: temptag
    integer :: i
    integer :: narg
    narg=command_argument_count()

    do i=1,narg
      call get_command_argument(i,temptag)
      if(trim(tag).eq.trim(temptag)) then
        call get_command_argument(i+1,temptag)
        read(temptag,'(I8)') var
        exit
      endif
    end do
  endsubroutine getArgInt
  
  !> @brief getting a logical value from the argument of the program
  subroutine getArgLogical(tag,var)
    character(len=*), intent(in) :: tag  !< tag/flag in the command line
    logical, intent(out)         :: var  !< a logical value to assign to the tag
    character(len=10) :: temptag
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
  


function chromosomeCorrect(list) result(isValid)
  ! Checks if LIST contains all possible numbers
  ! Returns TRUE if it does, otherwise FALSE
  integer, intent(in) :: list(:)
  integer :: i
  logical :: isValid
  isValid=.true.
  ! print "(A,I5)" , "# Size of chromosome: ",size(list)
  do i=0,size(list)-1
    if (.not.isElIn(i,list)) then
      isValid=.false.
    endif
  end do
  if(list(1).ne.1) isValid=.false.
end function chromosomeCorrect

end module helpers
