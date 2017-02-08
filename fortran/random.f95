! This module is a part oF SLEZAFORT library and is distributed under MIT license.
! See the project page for more details:  https://github.com/gronki/libslezafort
!
! Copyright (c) 2016 Dominik Gronkiewicz
!
! Permission is hereby granted, free of charge, to any person obtaining a copy
! of this software and associated documentation files (the "Software"), to deal
! in the Software without restriction, including without limitation the rights
! to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
! copies of the Software, and to permit persons to whom the Software is
! furnished to do so, subject to the following conditions:
!
! The above copyright notice and this permission notice shall be included in all
! copies or substantial portions of the Software.
!
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
! AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
! OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
! SOFTWARE.

module slf_random

    use slf_interpol

    integer, parameter, private :: dp = real64

contains

    subroutine random_init_urandom()
        integer :: n,err
        integer, allocatable :: seed(:)

        call random_seed(size=n)
        allocate(seed(n))
        open(unit=33,file='/dev/urandom',action='read',form='unformatted',iostat=err)
        if ( err .ne. 0 ) then
            error stop 'init_random: /dev/urandom not found'
        end if
        read (33) seed
        close(33)
        call random_seed(put=seed)
        deallocate(seed)
    end subroutine

    subroutine random_pdf(x,pdf,xout,cdf)
        real(dp), intent(in) :: x(:)
        real(dp), intent(out) :: xout(:)
        real(dp), intent(in) :: pdf(size(x))
        real(dp), intent(out) :: cdf(size(x))
        real(dp) :: rand(size(xout)), dx(size(x))
        integer :: i

        do i=1,size(x)
            if ( i .gt. 1 ) then
                dx(i) = x(i) - x(i-1)
            else
                dx(i) = x(2) - x(1)
            end if
        end do

        cdf(1) = pdf(1)*dx(1)
        if ( cdf(1) .lt. epsilon(1d0) ) cdf(1) = epsilon(1d0)

        do i = 2,size(x)
            cdf(i) = cdf(i-1) + pdf(i)*dx(i)
            if ( cdf(i) .le. cdf(i-1) ) then
                cdf(i) = cdf(i-1) * ( 1 + epsilon(1d0) )
            end if
        end do

        cdf = cdf / cdf(size(x))

        call random_number(rand)

        do i=1,size(rand)
            call interpol(cdf,x,rand(i),xout(i))
        end do

    end subroutine

end module
