PROGRAM DIFFUSION
        IMPLICIT NONE


        integer :: maxsize
        
        real, dimension(:,:,:), allocatable:: cube


        integer :: i, j, k, l, m, n     ! counter variables

        real :: diffusion_coef


        real :: room_dimension   !five meters
        real :: speed_molecules
        real :: timestep
        real :: distance_bw
        
        real :: DTerm


        real :: time
        real :: ratio 

        real :: change


        real :: sumval, minn, maxx





diffusion_coef = 0.175


room_dimension = 5.0   !five meters
speed_molecules = 250.0


time = 0.0
ratio = 0.0


write (*,*) "Number of divisions: "
read(*,*) maxsize

!calculate values that use maxsize
timestep = (room_dimension / speed_molecules) 


timestep = timestep/maxsize



distance_bw = room_dimension/maxsize


DTerm = (diffusion_coef * timestep)/(distance_bw*distance_bw)



allocate (cube (maxsize, maxsize, maxsize))


!zeroing the cube

cube = 0.0

!do i = 1, maxsize
 !       do j = 1, maxsize
  !              do k = 1, maxsize
   !                     cube(i,j,k) = 0

    !            end do
     !   end do
!end do


!initialize first cell
cube(1,1,1) = 1.0E21

change = 0.0


do while (ratio < 0.99)

        do i = 1, maxsize
                do j = 1, maxsize
                        do k = 1, maxsize
                                do l = 1, maxsize
                                        do m = 1, maxsize
                                                do n = 1, maxsize
                                                if(((i == l) .and. (j == m) .and. (k == n+1)) &
                                                 .or. ((i == l) .and. (j == m) .and.(k == n-1)) &
                                                .or. ((i == l) .and. (j == m+1) .and.(k == n)) &
                                                .or. ((i == l) .and. (j == m-1) .and.(k == n)) &
                                                .or. ((i == l+1) .and. (j == m) .and.(k == n)) &
                                                .or. ((i == l-1) .and. (j == m) .and.(k == n))) then



                                                        change = (cube(k, j, i) - cube(n, m, l)) * DTerm

                                                        cube(k,j,i) = cube(k,j,i) - change
                                                        cube(n,m,l) = cube(n,m,l) + change



                                                end if
                                                end do
                                        end do
                                end do
                        end do
                end do
        end do

        time = time + timestep


        sumval = sum(cube)
        maxx = maxval(cube)
        !cube(1,1,1)
        minn = minval(cube)
        !cube(1,1,1)
       

 
!          do i = 1, maxsize
 !               do j = 1, maxsize
!                        do k = 1, maxsize

 !                               maxx = max(cube(i,j,k), maxx)
  !                              minn = min(cube(i,j,k), minn)

   !                             sumval = sumval + cube(i,j,k)

    !                    end do
     !           end do
      !    end do


        ratio = minn/maxx


        print*, ratio

        print*, "Time: ", time
       
        print*, " ", cube(1,1,1),  " ", cube(maxsize, 1, 1)
        print*,  " ", cube(maxsize, maxsize, 1)
        print*, " ", cube(maxsize, maxsize, maxsize)

        print*, sumval


end do

        print*,  "Box equilibrated in ", time, " seconds of simulated time."



deallocate(cube)
END PROGRAM
