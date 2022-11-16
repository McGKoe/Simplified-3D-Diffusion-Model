extern crate ndarray;
use math::round;
use ndarray::Array3;
use std::io;


fn main() {
	
	println!("Number of divisions: ");
	let mut user_input = String::new();
	let stdin = io::stdin();

	stdin.read_line(&mut user_input).ok();

	println!("With partition? (y/n) ");
	let mut input = String::new();
	
	stdin.read_line(&mut input).ok();
	
	let partition = input.trim();



	//must use usize here
	let maxsize = user_input.trim().parse::<usize>().unwrap();

	println!("{}", maxsize);
	// declare and zeroes the cube
	let mut cube = Array3::<f64>::zeros((maxsize,maxsize,maxsize));

	let diffusion_coef = 0.175;
	let room_dimension = 5.0;
	let speed_gas_molecules = 250.0;

	let timestep = (room_dimension /speed_gas_molecules)/maxsize as f64;
	let distance_bw = room_dimension/maxsize as f64;

	let dterm = (diffusion_coef * timestep)/(distance_bw * distance_bw);



	


	//initialize first cell
	cube[[0,0,0]] = 1.0e+21;


	//counters
	let mut time = 0.0;
	let mut ratioo = 0.0;




	// without partition
	if partition.ne("y")
	{
		while ratioo < 0.99 
		{
			for i in 0..maxsize {
				for j in 0..maxsize {
					for k in 0..maxsize {
						for l in 0..maxsize {
							for m in 0..maxsize {
								for n in 0..maxsize{
									if     ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
										( ( i == l )   && ( j == m )   && ( k as isize  == (n as isize - 1) as isize )) || 
										( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
										( ( i == l )   && ( j as isize == (m as isize - 1) as isize ) && ( k == n)   ) ||  
										( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
										( ( i as isize == (l as isize - 1) as isize ) && ( j == m )   && ( k == n)   )  {
										let change = (cube[[i,j,k]] - cube[[l,m,n]]) * dterm;

										cube[[i,j,k]] = cube[[i,j,k]] - change;
										cube[[l,m,n]] = cube[[l,m,n]] + change; 
									}
								}
							}
						}
					}
				}
			}

			time = time + timestep;

			let mut sumval = 0.0;
			let mut maxval = cube[[0,0,0]];
			let mut minval = cube[[0,0,0]];

			for i in 0..maxsize {
				for j in 0..maxsize {
					for k in 0..maxsize {
						maxval = maxval.max(cube[[i,j,k]]);
						minval = minval.min(cube[[i,j,k]]);
						sumval += cube[[i,j,k]];


					}
				}
			}

		ratioo = minval/maxval;

	
		println!("Ratio {} ", ratioo);


		println!("time:  {} ", time);
	
		println!("{}",cube[[0,0,0]]);
		println!("{}",cube[[maxsize-1,0,0]]);
		println!("{}",cube[[maxsize-1,maxsize-1,0]]);
		println!("{}",cube[[maxsize-1,maxsize-1,maxsize-1]]);
		println!("Sumval: {} ", sumval);
	

		}

	}
	else // with partition
	{
		
		
		//declare bitmap and fill with ones
		let mut bitmap = Array3::<i64>::ones((maxsize + 2,maxsize + 2,maxsize + 2));

		//zero the walls and partition
		for i in 0..maxsize + 2 {
			for j in 0..maxsize + 2 {
				for k in 0..maxsize + 2{

					if i == 0 || j == 0 || k == 0
					{
						        bitmap[[i,j,k]] = 0;
					}
					if i == maxsize+1 || j == maxsize+1 || k == maxsize+1
					{
						bitmap[[i,j,k]] = 0;
					}
					if i == round::floor((maxsize as f64 + 2 as f64)/2 as f64, 0) as usize && j >= round::floor((maxsize+2) as f64 * 0.25 + 1 as f64, 0) as usize
 					{
						bitmap[[i,j,k]] = 0;
					}



				}
			}
		}



		while ratioo < 0.99 
		{
			for i in 0..maxsize {
				for j in 0..maxsize {
					for k in 0..maxsize {
						for l in 0..maxsize {
							for m in 0..maxsize {
								for n in 0..maxsize{
									if bitmap[[i+1,j+1,k+1]] == 1 && bitmap[[l+1,m+1,n+1]] == 1 {
										if     ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
											( ( i == l )   && ( j == m )   && ( k as isize  == (n as isize - 1) as isize )) || 
											( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
											( ( i == l )   && ( j as isize == (m as isize - 1) as isize ) && ( k == n)   ) ||  
											( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
											( ( i as isize == (l as isize - 1) as isize ) && ( j == m )   && ( k == n)   )  {
											let change = (cube[[i,j,k]] - cube[[l,m,n]]) * dterm;

											cube[[i,j,k]] = cube[[i,j,k]] - change;
											cube[[l,m,n]] = cube[[l,m,n]] + change;
										}
									}
								}
							}
						}
					}
				}
			}

			time = time + timestep;

			let mut sumval = 0.0;
			let mut maxval = cube[[0,0,0]];
			let mut minval = cube[[0,0,0]];

			for i in 0..maxsize {
				for j in 0..maxsize {
					for k in 0..maxsize {
						if bitmap[[i+1,j+1,k+1]] == 1 {
							maxval = maxval.max(cube[[i,j,k]]);
							minval = minval.min(cube[[i,j,k]]);
							sumval += cube[[i,j,k]];

						}
					}
				}
			}

		ratioo = minval/maxval;

	
		println!("Ratio {} ", ratioo);


		println!("time:  {} ", time);
	
		println!("{}",cube[[0,0,0]]);
		println!("{}",cube[[maxsize-1,0,0]]);
		println!("{}",cube[[maxsize-1,maxsize-1,0]]);
		println!("{}",cube[[maxsize-1,maxsize-1,maxsize-1]]);
		println!("Sumval: {} ", sumval);
	

		}
	


	}
	println!("Box equilibrated in {} seconds of simulated time", time);
}
