module cities
implicit none
real*8, parameter :: inf = 1.d12
contains

subroutine calcDistances(places,distances)
  ! Calculates distances between all posible cities. We deal with a problem of MINIMAL path, so we set the distance between city with itself as infinity (or very large). To calculate the distance from lattitude and longitude, we assume that the Earth is a sphere (not elipsoid). Then, we use the cosine rules for spherical trigonometry: https://en.wikipedia.org/wiki/Spherical_trigonometry#Cosine_rules_and_sine_rules
  ! The angular distance dS between two points of lattitudes fi1 and fi2 and longitudes  difference deltaLong is:
  ! dS = arccos(sin(f1)sin(f2)+cos(fi1)cos(fi2)cos(deltaLong)). Then, the final distance between points is d=R*dS, where R is mean radius of the earth.
  real*8,  intent(in)  :: places(:,:)
  real*8,  intent(out) :: distances(:,:)
  real*8,  parameter   :: R=6371.d0
  integer :: genNo, i, j
  real*8  :: dLong, fi1, fi2, dist
  genNo = size(places,2)
  distances = inf
  do i=1,genNo
    do j=i+1,genNo
      dLong = dabs(places(2,i)-places(2,j))
      fi1 = places(1,i)
      fi2 = places(1,j)
      dist = acos(sin(fi1)*sin(fi2) + cos(fi1)*cos(fi2)*cos(dLong))
      distances(i,j) = dist*R
      distances(j,i) = dist*R
    end do!j
  end do!i
  ! TODO CHECK
end subroutine calcDistances


end module cities
