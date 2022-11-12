extern crate ndarray;
use ndarray::Array3;
use std::io;

//const MDIM: usize = 10;

fn main() {
	
	let mut user_input = String::new();
	let stdin = io::stdin();

	stdin.read_line(&mut user_input).ok();
	println!("input {} ", user_input);

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



	
	println!("DTerm {} ", dterm);


	//initialize first cell
	cube[[0,0,0]] = 1.0e+21;


	//counters
	let mut time = 0.0;
	let mut ratioo = 0.0;





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

	println!("Box equilibrated in {} seconds of simulated time", time);
}
