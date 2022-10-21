with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Containers.Ordered_Sets;


procedure Diffusion is

	maxsize : Integer;
	
	type cubee is array(Natural range <>, Natural range <>, Natural range <>) of Float;

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

	timestep := (room_dimension/speed_molecules)/Float(maxsize);
	distance_bw := room_dimension/Float(maxsize);

	DTerm := (diffusion_coef * timestep) / (distance_bw * distance_bw);


	maxsize := maxsize - 1;


	-- declareas and zeroes the cube
	declare
	Cube : cubee(0..maxsize, 0..maxsize, 0..maxsize) := (Others =>(Others =>(Others => 0.0)));
	begin

	Cube(0,0,0) := 1.0e21;


	while(ratio < 0.99) loop
	
		for I in 0..maxsize loop
			for J in 0..maxsize loop
				for K in 0..maxsize loop
					for L in 0..maxsize loop
						for M in 0..maxsize loop
							for N in 0..maxsize loop
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

		for I in 0..maxsize loop
			for J in 0..maxsize loop
				for K in 0..maxsize loop
					maxval := Float'Max(Cube(I,J,K), maxval);
					minval := Float'Min(Cube(I,J,K), minval);

					sumval := sumval + Cube(I,J,K);


				end loop;
			end loop;
		end loop;


		ratio := minval/maxval;


		Put("ratio: ");
		Put_Line(Float'Image(ratio));

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

	Put("Box equilibrated in ");
	Put(Float'Image(time));
	Put_Line(" seconds of simulated time");


	end;
end Diffusion;
