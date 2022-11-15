#!/usr2/local/julia-1.8.2/bin/julia

print("Number of divisions: ")

maxsize = parse(Int32, readline())

cube = Array{Float64,3}(undef, maxsize, maxsize, maxsize)

print("With partition? (y/n) ")

partition = readline()


diffusion_coef = 0.175
room_dimension = 5
speed_gas_molecules = 250.0

timestep = (room_dimension/speed_gas_molecules)/maxsize
distance_bw_blocks = room_dimension/maxsize

DTerm = (diffusion_coef * timestep) / (distance_bw_blocks * distance_bw_blocks)

# fills cube with 0
cube = fill!(cube, 0.0)


#initializes first cell
cube[1,1,1] = 1.0e21


timee = 0.0
ratioo = 0.0



# without partition
if partition != "y"
	while ratioo < 0.99

		for i = 1:maxsize
			for j = 1:maxsize
				for k = 1:maxsize
					for l = 1:maxsize
						for m = 1:maxsize
							for n = 1:maxsize
								if (    ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
									( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
									( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
									( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
									( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
									( ( i == l-1 ) && ( j == m )   && ( k == n)   ) ) 
										change = (cube[i,j,k] - cube[l,m,n]) * DTerm
										cube[i,j,k] = cube[i,j,k] - change
										cube[l,m,n] = cube[l,m,n] + change
								end
							end
						end
					end
				end
			end
		end
		#increment time
		global timee += timestep

		sumval = 0.0
		maxval = maximum(cube)
		minval = minimum(cube)

		for i = 1:maxsize
			for j = 1:maxsize
				for k = 1 maxsize
					sumval = sumval + cube[i,j,k]			

				end
			end
		end

		#update ratio
		global ratioo = minval/maxval

	
		println("Ratio: ", ratioo)
		println("Time: ", timee)
		println(cube[1,1,1])
		println(cube[maxsize,1,1])
		println(cube[maxsize,maxsize,1])
		println(cube[maxsize,maxsize,maxsize])
		println(sumval)



	end
	#end of without partiton

#with partition
else 

	#create bitmap
	bitmap = Array{Int8,3}(undef, maxsize + 2, maxsize + 2, maxsize + 2)


	#fill bitmap with ones
	bitmap = fill!(bitmap, 1)

	#zero walls and partition
	for i = 1:maxsize + 2
		for j = 1:maxsize + 2
			for k = 1:maxsize + 2
				if(i == 1 || j == 1 || k == 1)
					bitmap[i,j,k]= 0
			
				elseif( i == maxsize+2 || j == maxsize+2 || k == maxsize+2)
					bitmap[i,j,k] = 0
			
				elseif((i == round((maxsize + 2)/2)) && j >= ceil((maxsize + 2) * .25  + 1))
					bitmap[i,j,k] = 0
				end
			end
		end
	end






	while ratioo < 0.99

		for i = 1:maxsize
			for j = 1:maxsize
				for k = 1:maxsize
					for l = 1:maxsize
						for m = 1:maxsize
							for n = 1:maxsize
								if(bitmap[i + 1, j + 1, k + 1] == 1 && bitmap[l + 1, m+ 1, n + 1] == 1)
									if (    ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
										( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
										( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
										( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
										( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
										( ( i == l-1 ) && ( j == m )   && ( k == n)   ) ) 
											change = (cube[i,j,k] - cube[l,m,n]) * DTerm
											cube[i,j,k] = cube[i,j,k] - change
											cube[l,m,n] = cube[l,m,n] + change
									end
								end
							end
						end
					end
				end
			end
		end

		#increment time
		global timee += timestep

		sumval = 0.0

		#max of the cube
		maxval = maximum(cube)

		#must be calculated to avoid counting the zero inside the partition
		minval = cube[1,1,1]

		for i = 1:maxsize
			for j = 1:maxsize
				for k = 1 maxsize
					if(bitmap[i + 1, j + 1, k + 1] == 1)
						maxval = max(maxval, cube[i,j,k])
						minval = min(minval, cube[i,j,k])
						sumval = sumval + cube[i,j,k]			
					end
				end
			end
		end

		#update ratio
		global ratioo = minval/maxval

	
		println("Ratio: ", ratioo)
		println("Time: ", timee)
		println(cube[1,1,1])
		println(cube[maxsize,1,1])
		println(cube[maxsize,maxsize,1])
		println(cube[maxsize,maxsize,maxsize])
		println(sumval)



	end

end #end of if/else

println("Box equilibrated in ", timee, " seconds of simulated time")

exit()
