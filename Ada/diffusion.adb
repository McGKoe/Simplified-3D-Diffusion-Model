with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Containers.Ordered_Sets;


procedure Diffusion is

	maxsize : Integer;
	
	type cubee is array(Natural range <>, Natural range <>, Natural range <>) of Float;
	type cubeee is array(Natural range <>, Natural range <>, Natural range <>) of Integer;


	partition : Boolean := FALSE;
	answer : STRING(1..1);



	diffusion_coef : Float := 0.175;
	room_dimension : Float := 5.0; -- five meters long room
	speed_molecules : Float := 250.0;
	timestep : Float;
	distance_bw : Float;

	DTerm : Float;


	time : Float := 0.0;
	ratio : Float := 0.0;

	change : Float := 0.0;


	sumval : Float := 0.0;
	maxval : Float := 0.0;
	minval : Float := 0.0;


begin
	
	-- take maxsize as input
	Put("Number of Divisions: ");
	Get(maxsize);

	--take partition as input
	Put("With partition? (y/n) ");
	Get(answer);

	if answer = "y" then
		partition := TRUE;
	end if;



	timestep := (room_dimension/speed_molecules)/Float(maxsize);
	distance_bw := room_dimension/Float(maxsize);

	DTerm := (diffusion_coef * timestep) / (distance_bw * distance_bw);


	-- declares and zeroes the cube
	declare
        Cube : cubee(0..maxsize-1, 0..maxsize-1, 0..maxsize-1) := (Others =>(Others =>(Others => 0.0)));
	begin

	Cube(0,0,0) := 1.0e21;


	if partition /= TRUE then
		while(ratio < 0.99) loop
	
		for I in 0..maxsize-1 loop
			for J in 0..maxsize-1 loop
				for K in 0..maxsize-1 loop
					for L in 0..maxsize-1 loop
						for M in 0..maxsize-1 loop
							for N in 0..maxsize-1 loop
								if (	((I = L) and (J = M) and (K = N+1)) or
									(I = L and J = M and K = N-1) or
									(I = L and J = M+1 and K = N) or
									(I = L and J = M-1 and K = N) or
									(I = L+1 and J = M and K = N) or
									(I = L-1 and J = M and K = N) ) then
									change := (Cube(I,J,K) - Cube(L,M,N)) * Dterm;
						
									
									Cube(I,J,K) := Cube(I,J,K) - change;
									Cube(L,M,N) := Cube(L,M,N) + change;



								end if;
							end loop;
						end loop;
					end loop;
				end loop;
			end loop;
		end loop;

		time := time + timestep;
		
		sumval := 0.0;
		maxval := Cube(0,0,0);
		minval := Cube(0,0,0);


		-- find min and max of the cube
		for I in 0..maxsize-1 loop
			for J in 0..maxsize-1 loop
				for K in 0..maxsize-1 loop
					maxval := Float'Max(Cube(I,J,K), maxval);
					minval := Float'Min(Cube(I,J,K), minval);

					sumval := sumval + Cube(I,J,K);


				end loop;
			end loop;
		end loop;


		ratio := minval/maxval;


		Put_Line("ratio: " & Float'Image(ratio));

		Put_Line("");

		Put(" time = ");
		Put(Float'Image(time));

		Put(" ");
		Put(Float'Image(Cube(0,0,0)));
		Put(" ");
                Put(Float'Image(Cube(maxsize - 1 ,0,0)));
                Put(" ");
                Put(Float'Image(Cube(maxsize - 1, maxsize - 1,0)));
                Put(" ");
                Put(Float'Image(Cube(maxsize - 1, maxsize - 1, maxsize - 1)));
                Put(" ");
                Put(Float'Image(sumval));






	end loop;


	else 


		-- declare bitmap and fill with ones		
		declare
                Bitmap : cubeee(0..maxsize + 1, 0..maxsize + 1, 0..maxsize + 1) := (Others =>(Others =>(Others => 1)));
                begin

                -- zero walls and partition of bitmap
		for I in 0..maxsize + 1 loop
			for J in 0..maxsize + 1 loop
				for K in 0..maxsize + 1 loop
               
					if(I = 0 or J = 0 or K = 0) then
						Bitmap(I,J,K) := 0;
                
					elsif(I = maxsize + 1 or J = maxsize + 1 or K = maxsize + 1) then
						Bitmap(I,J,K) := 0;
                
					elsif(I = Integer(Float'Floor((Float(maxsize) + 2.0)/2.0)) and Float(j) >= Float'Floor((Float(maxsize) + 2.0) * 0.25 + Float(1.0))) then
						Bitmap(I,J,K) := 0;
					end if;
				end loop;
			end loop;
		end loop;





		while(ratio < 0.99) loop
	
			for I in 0..maxsize-1 loop
				for J in 0..maxsize-1 loop
					for K in 0..maxsize-1 loop
						for L in 0..maxsize-1 loop
							for M in 0..maxsize-1 loop
								for N in 0..maxsize-1 loop
									if(Bitmap(I+1,J+1,K+1) = 1 and Bitmap(L+1,M+1,N+1) = 1) then
										if (	((I = L) and (J = M) and (K = N+1)) or
											(I = L and J = M and K = N-1) or
											(I = L and J = M+1 and K = N) or
											(I = L and J = M-1 and K = N) or
											(I = L+1 and J = M and K = N) or
											(I = L-1 and J = M and K = N) ) then
											change := (Cube(I,J,K) - Cube(L,M,N)) * Dterm;
						
									
											Cube(I,J,K) := Cube(I,J,K) - change;
											Cube(L,M,N) := Cube(L,M,N) + change;



										end if;
									end if;
								end loop;
							end loop;
						end loop;
					end loop;
				end loop;
			end loop;

			time := time + timestep;
		
			sumval := 0.0;
			maxval := Cube(0,0,0);
			minval := Cube(0,0,0);

			for I in 0..maxsize-1 loop
				for J in 0..maxsize-1 loop
					for K in 0..maxsize-1 loop
						if(Bitmap(I+1,J+1,K+1) = 1) then
							maxval := Float'Max(Cube(I,J,K), maxval);
							minval := Float'Min(Cube(I,J,K), minval);
						
							sumval := sumval + Cube(I,J,K);

						end if;
					end loop;
				end loop;
			end loop;


			ratio := minval/maxval;


			Put_Line("ratio: " & Float'Image(ratio));

			Put_Line("");

			Put(" time = ");
			Put(Float'Image(time));

			Put(" ");
			Put(Float'Image(Cube(0,0,0)));
			Put(" ");
                	Put(Float'Image(Cube(maxsize - 1 ,0,0)));
                	Put(" ");
                	Put(Float'Image(Cube(maxsize - 1, maxsize - 1,0)));
                	Put(" ");
                	Put(Float'Image(Cube(maxsize - 1, maxsize - 1, maxsize - 1)));
                	Put(" ");
        	        Put(Float'Image(sumval));






		end loop;



	end;
	end if;

	Put("Box equilibrated in ");
	Put(Float'Image(time));
	Put_Line(" seconds of simulated time");


	end;
end Diffusion;
