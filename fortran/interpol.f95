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

module slf_interpol

    use iso_fortran_env
    integer, parameter, private :: dp = real64

contains


    subroutine interpol(x_in, y_in, x_out, y_out)
        real(dp), intent(in) :: x_in(:)
        real(dp), intent(in) :: y_in(size(x_in))
        real(dp), intent(in) :: x_out
        real(dp), intent(out) :: y_out
        real(dp) :: x0,x1,y0,y1,t,control
        integer :: i, i_nearest, n

        n = size(y_in)

        t = abs(x_in(1)-x_in(n))

        ! find the nearest point
        control = x_in(2) - x_in(1)
        do i=1,n
            if (i .gt. 1) then
                if ( control * (x_in(i)-x_in(i-1)) .le. 0 ) then
                    write (0,*) 'interpol: x-axis points should be either in ascending or descending order'
                    return
                endif
            endif
            if ( (abs(x_in(i)-x_out) .lt. abs(t)) .or. (i .eq. 1) ) then
                i_nearest = i
                t = x_in(i)-x_out
            end if
        end do

        if ( t .eq. 0. ) then
            y_out = y_in(i_nearest)
            return
        else if (t .gt. 0) then
            if ( i_nearest .eq. 1 ) then
                y_out = y_in(1)
                return
            endif
            x1 = x_in(i_nearest)
            y1 = y_in(i_nearest)
            x0 = x_in(i_nearest-1)
            y0 = y_in(i_nearest-1)
        else
            if ( i_nearest .eq. n ) then
                y_out = y_in(n)
                return
            endif
            x0 = x_in(i_nearest)
            y0 = y_in(i_nearest)
            x1 = x_in(i_nearest+1)
            y1 = y_in(i_nearest+1)
        end if

        t = (x1 - x_out) / (x1-x0)
        y_out = t * y0 + (1.-t) * y1


    end subroutine


end module
