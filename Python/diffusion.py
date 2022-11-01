#!/usr/bin/python
from numpy import *


maxsizestr = input("Number of divisions: ")

maxsize = int(maxsizestr)

answer = input("With partition? (y/n) ")

partition = answer == "y"




cube = zeros((maxsize, maxsize, maxsize), dtype=float64)  #zeros the cube

diffusion_coefficient = 0.175; 
room_dimension = 5;                      # 5 Meters
speed_of_gas_molecules = 250.0;          # Based on 100 g/mol gas at RT
timestep = (room_dimension / speed_of_gas_molecules) / maxsize; # h in seconds
distance_between_blocks = room_dimension / maxsize;

DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks)


#initializing frist cell of cube
cube[0][0][0] = 1.0e21



time = 0.0 #keeps up with system time
ratio = 0.0 # lets us know if the room is equilibrated yet

if not partition:
	while ratio < 0.99:
		for i in range(0, maxsize):
			for j in range(0, maxsize):
				for k in range(0, maxsize):
					for l in range(0, maxsize):
						for m in range(0, maxsize):
							for n in range(0, maxsize):
								if( (i == l and j == m and k == n+1) or
								(i == l and j == m and k == n-1) or
								(i == l and j == m+1 and k == n) or
								(i == l and j == m-1 and k == n) or
								(i == l+1 and j == m and k == n) or
								(i == l-1 and j == m and k == n) ):
									change = (cube[i][j][k] - cube[l][m][n]) * DTerm
									cube[i][j][k] = cube[i][j][k] - change
									cube[l][m][n] = cube[l][m][n] + change

		time = time + timestep

		sumval = 0.0
		maxval = cube[0][0][0]
		minval = cube[0][0][0]

		for i in range(0, maxsize):
			for j in range(0, maxsize):
				for k in range(0, maxsize):
					maxval = max(cube[i][j][k], maxval)
					minval = min(cube[i][j][k], minval)
					sumval = sumval + cube[i][j][k]

		ratio = minval/maxval


		print(ratio)
		print(time,  " " , cube[0][0][0])
		print( " " , cube[maxsize-1][0][0])
		print(        " " , cube[maxsize-1][maxsize-1][0] )
		print(        " " , cube[maxsize-1][maxsize-1][maxsize-1] )
		print(        " " , sumval , "\n")

#case if partition
else:

	#creates and oneses the bitmap
	bitmap = ones((maxsize, maxsize, maxsize), dtype=float64)

	#zero the partition of the bitmap
	for i in range(0,maxsize):
		for j in range(0,maxsize):
			for k in range(0,maxsize):
				if i == int(maxsize/2) and j >= 1 + (maxsize * .25):
					bitmap[i,j,k] = 0
				else:
					bitmap[i,j,k] = 1






	while ratio < 0.99:
		for i in range(0, maxsize):
			for j in range(0, maxsize):
				for k in range(0, maxsize):
					for l in range(0, maxsize):
						for m in range(0, maxsize):
							for n in range(0, maxsize):
								#if (i,j,k) AND (l,m,n) are able to be diffused into
								if bitmap[i,j,k] == 1 and bitmap[l,m,n] == 1:

									if( (i == l and j == m and k == n+1) or
									(i == l and j == m and k == n-1) or
									(i == l and j == m+1 and k == n) or
									(i == l and j == m-1 and k == n) or
									(i == l+1 and j == m and k == n) or
									(i == l-1 and j == m and k == n) ):
										change = (cube[i][j][k] - cube[l][m][n]) * DTerm
										cube[i][j][k] = cube[i][j][k] - change
										cube[l][m][n] = cube[l][m][n] + change

		time = time + timestep

		sumval = 0.0
		maxval = cube[0][0][0]
		minval = cube[0][0][0]

		for i in range(0, maxsize):
			for j in range(0, maxsize):
				for k in range(0, maxsize):
					if bitmap[i,j,k] == 1:
						maxval = max(cube[i][j][k], maxval)
						minval = min(cube[i][j][k], minval)
						sumval = sumval + cube[i][j][k]

		ratio = minval/maxval


		print(ratio)
		print(time,  " " , cube[0][0][0])
		print( " " , cube[maxsize-1][0][0])
		print(        " " , cube[maxsize-1][maxsize-1][0] )
		print(        " " , cube[maxsize-1][maxsize-1][maxsize-1] )
		print(        " " , sumval , "\n")








print("Box equilibrated in " , time , " seconds of simulated time.")

