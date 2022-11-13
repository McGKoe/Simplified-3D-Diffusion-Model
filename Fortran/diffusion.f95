PROGRAM DIFFUSION
        IMPLICIT NONE


        integer :: maxsize
        
        real, dimension(:,:,:), allocatable:: cube
        real, dimension(:,:,:), allocatable:: bitmap


        character(len = 1) :: answer

        logical :: partition



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


write(*,*) "With partiton? (y/n) "
read(*,*) answer

if (answer == 'y') then
        partition = .true.
        write(*,*) partition
end if

!calculate values that use maxsize
timestep = (room_dimension / speed_molecules) 


timestep = timestep/maxsize



distance_bw = room_dimension/maxsize


DTerm = (diffusion_coef * timestep)/(distance_bw*distance_bw)



allocate (cube (maxsize, maxsize, maxsize))


!zeroing the cube

cube = 0.0


!initialize first cell
cube(1,1,1) = 1.0E21

change = 0.0


if (.not. partition) then
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

else 

        !allocate bitmap
        allocate (bitmap (maxsize + 2, maxsize + 2, maxsize + 2))


        !fill bitmap with ones

        bitmap = 1.0



        !zero the walls and partition of bitmap
        do i = 1, maxsize + 2
                do j = 1, maxsize + 2
                        do k = 1, maxsize + 2

                        if(i == 1 .or.j == 1 .or. k == 1) then
                                bitmap(k,j,i) = 0
                        end if
                        if (i == maxsize + 2 .or. j == maxsize + 2 .or. &
                                k == maxsize + 2) then
                                bitmap(k,j,i) = 0
                        end if
                        if (i == ANINT((real(maxsize) + 2)/2) .and. j >= &
ceiling((maxsize + 2) * .25 + 1)) then
                                bitmap(k,j,i) = 0

                        end if
                        end do
                end do
        end do
        
        

        do while (ratio < 0.99)
        
                do i = 1, maxsize
                        do j = 1, maxsize
                                do k = 1, maxsize
                                        do l = 1, maxsize
                                                do m = 1, maxsize
                                                        do n = 1, maxsize
                                                                if(bitmap(k + 1,j + 1,i + 1) &
== 1 .and. bitmap(n + 1, m + 1, l + 1) == 1) then
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
                                                                end if
                                                        end do
                                                end do
                                        end do
                                end do
                        end do
                end do

                time = time + timestep


        !        sumval = sum(cube)
      !          maxx = maxval(cube)
        !cube(1,1,1)
       !         minn = minval(cube)
        !cube(1,1,1)
       

                maxx = cube(1,1,1)
                minn = cube(1,1,1)


 
          do i = 1, maxsize
                do j = 1, maxsize
                        do k = 1, maxsize

                                 if(bitmap(k + 1,j + 1,i + 1) ==1) then
                                maxx = max(cube(k,j,i), maxx)
                                minn = min(cube(k,j,i), minn)

                                sumval = sumval + cube(k,j,i)
                                end if
                        end do
                end do
          end do




                ratio = minn/maxx


                print*, "Ratio: ", ratio

                print*, "Time: ", time
       
                print*, " ", cube(1,1,1),  " ", cube(maxsize, 1, 1)
                print*,  " ", cube(maxsize, maxsize, 1)
                print*, " ", cube(maxsize, maxsize, maxsize)

                print*, sumval

        end do
end if


        print*,  "Box equilibrated in ", time, " seconds of simulated time."



deallocate(cube)
END PROGRAM
