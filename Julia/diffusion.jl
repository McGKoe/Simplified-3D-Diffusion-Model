#!/usr2/local/julia-1.8.2/bin/julia

print("Number of divisions: ")

maxsize = parse(Int32, readline())

cube = Array{Float64,3}(undef, maxsize, maxsize, maxsize)


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

	global timee += timestep

	sumval = 0.0
	maxval = cube[1,1,1]
	minval = cube[1,1,1]

	println("Maxval ", maxval)
	println("Minval", minval)

	for i = 1:maxsize
		for j = 1:maxsize
			for k = 1 maxsize
				maxval = max(maxval, cube[i,j,k])
				minval = min(minval, cube[i,j,k])
				sumval = sumval + cube[i,j,k]			

			end
		end
	end

	println("Maxval ", maxval)
	println("Minval", minval)


	global ratioo = minval/maxval

	
	println("Ratio: ", ratioo)
	println("Time: ", timee)
	println(cube[1,1,1])
	println(cube[maxsize,1,1])
	println(cube[maxsize,maxsize,1])
	println(cube[maxsize,maxsize,maxsize])
	println(sumval)



end


println("Box equilibrated in ", timee, " seconds of simulated time")

exit()
