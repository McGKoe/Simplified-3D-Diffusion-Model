#include<iostream>
#include<fstream>
#include <cmath>
#include <stdio.h>
#include <stdlib.h>



using namespace std;


int main()
{

	cout << "Number of Divisions in the room:  ";

	int maxsize  = 10; 
	
	cin >> maxsize;


	cout << "With patition? (y/n)";

	char answer;

	cin >> answer;


	bool partition;

	if(answer == 'y')
	{
		partition = true;
	}


	//allocating memeory
	double*** cube =  new double** [maxsize];

	for (int i = 0; i < maxsize; ++i) 
	{
		cube[i] = new double* [maxsize];
      		for (int j = 0; j < maxsize; j++) 
		{
          		cube[i][j] = new double [maxsize];
          	}
     	}





	/* Zero the cube */

	for (int i=0; i<maxsize; i++) {
    		for (int j=0; j<maxsize; j++) {
        		for (int k=0; k<maxsize; k++) 
			{
            			cube[i][j][k] = 0.0;
        		}
    		}
	}

	double diffusion_coefficient = 0.175;
	double room_dimension = 5;                     // 5 Meters
	double speed_of_gas_molecules = 250.0;          // Based on 100 g/mol gas at RT
	double timestep = (room_dimension / speed_of_gas_molecules) / maxsize; // h in seconds
	double distance_between_blocks = room_dimension / maxsize;

	double DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);

	// Initialize the first cell



	cube[0][0][0] = 1.0e21;

	int pass = 0;

	double time = 0.0;  // to keep up with accumulated system time.
	double ratio = 0.0;


	if(!partition)
	{
		do {

			for (int i=0; i<maxsize; i++) 
			{
                		for (int j=0; j<maxsize; j++) 
				{
                        		for (int k=0; k<maxsize; k++) 
					{
                                		for (int l=0; l<maxsize; l++) 
						{
                                        		for (int m=0; m<maxsize; m++) 
							{
                                                		for (int n=0; n<maxsize; n++) 
								{
                                                        		if (    ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||
                                                                		( ( i == l )   && ( j == m )   && ( k == n-1) ) ||
                                                                		( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||
                                                                		( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||
                                                                		( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||
                                                                		( ( i == l-1 ) && ( j == m )   && ( k == n)   ) ) 
									{
                                                                        		double change = (cube[i][j][k] - cube[l][m][n]) * DTerm;
                                                                        		cube[i][j][k] = cube[i][j][k] - change;
                                                                        		cube[l][m][n] = cube[l][m][n] + change;
                                                                	}
								}
							}
						}
					}
				}
			}

			time = time + timestep;

        		double sumval = 0.0;
        		double maxval = cube[0][0][0];
        		double minval = cube[0][0][0];
        		for (int i=0; i<maxsize; i++) 
			{
                		for (int j=0; j<maxsize; j++) 
				{
                        		for (int k=0; k<maxsize; k++) 
					{
                                		maxval = max(cube[i][j][k],maxval);
                                		minval = min(cube[i][j][k],minval);
                                		sumval += cube[i][j][k];

					}
				}
			}

                	ratio = minval / maxval;

                	cout << ratio << " time = " << time << "\n";

                	cout << time << " " << cube[0][0][0] ;
                	cout <<        " " << cube[maxsize-1][0][0] ;
                	cout <<        " " << cube[maxsize-1][maxsize-1][0] ;
                	cout <<        " " << cube[maxsize-1][maxsize-1][maxsize-1] ;
        	        cout <<        " " << sumval << "\n";
		} while ( ratio < 0.99 );
	}
	else //partition
	{

		int*** bitmap =  new int** [maxsize];

		//allocating memory
        	for (int i = 0; i < maxsize; ++i)
        	{
                	bitmap[i] = new int* [maxsize];
                	for (int j = 0; j < maxsize; j++)
                	{
                	        bitmap[i][j] = new int [maxsize];
                	}
        	}


		//zero the walls and partition of the bitmap
		for (int i = 0; i < maxsize; i++) 
		{
                        for (int j = 0; j < maxsize; j++) 
			{
                                for (int k = 0; k < maxsize; k++) 
				{
						// zero the partition
					if((i == round(maxsize)/2 - 1) && (j >= round(maxsize * .5)-1))
						bitmap[i][j][k] = 0;
					else
						bitmap[i][j][k] = 1;
				}
			}
		}




                do {

                        for (int i=0; i<maxsize; i++)
                        {
                                for (int j=0; j<maxsize; j++)
                                {
                                        for (int k=0; k<maxsize; k++)
                                        {
                                                for (int l=0; l<maxsize; l++)
                                                {
                                                        for (int m=0; m<maxsize; m++)
                                                        {
                                                                for (int n=0; n<maxsize; n++)
                                                                {


									if(bitmap[i][j][k] == 1 && bitmap[l][m][n] == 1)
									{
                                                                        	if (    ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||
                                                                                	( ( i == l )   && ( j == m )   && ( k == n-1) ) ||
                                                                                	( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||
                                                                                	( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||
                                                                                	( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||
                                                                                	( ( i == l-1 ) && ( j == m )   && ( k == n)   ) )
                                                                        	{
                                                                                	        double change = (cube[i][j][k] - cube[l][m][n]) * DTerm;
                                                                                	        cube[i][j][k] = cube[i][j][k] - change;
                                                                                	        cube[l][m][n] = cube[l][m][n] + change;
                                                                        	}
									}
                                                                }
                                                        }
                                                }
                                        }
                                }
                        }

                        time = time + timestep;

                        double sumval = 0.0;
                        double maxval = cube[0][0][0];
                        double minval = cube[0][0][0];
                        for (int i=0; i<maxsize; i++)
                        {
                                for (int j=0; j<maxsize; j++)
                                {
                                        for (int k=0; k<maxsize; k++)
                                        {
						if(bitmap[i][j][k] == 1)
						{
                                                maxval = max(cube[i][j][k],maxval);
                                                minval = min(cube[i][j][k],minval);
                                                sumval += cube[i][j][k];
						}
                                        }
                                }
                        }



                        ratio = minval / maxval;

                        cout << ratio << " time = " << time << "\n";

                        cout << time << " " << cube[0][0][0] ;
                        cout <<        " " << cube[maxsize-1][0][0] ;
                        cout <<        " " << cube[maxsize-1][maxsize-1][0] ;
                        cout <<        " " << cube[maxsize-1][maxsize-1][maxsize-1] ;
                        cout <<        " " << sumval << "\n";
                } while ( ratio < 0.99 );


        	//deallocating memeory from bitmap
		for (int i = 0; i < maxsize; i++ )
		{
			for (int j = 0; j < maxsize; j++ )
			{
				delete[] bitmap[i][j];
                	}
                	delete[] bitmap[i];
        	}
        
        	delete[] bitmap;


	}



	cout << "Box equilibrated in " << time << " seconds of simulated time.";


	//deallocating memory to cube
	for (int i = 0; i< maxsize; i++ ) 
	{
	        for (int j = 0; j < maxsize; j++ ) 
		{
        	    	delete[] cube[i][j];
        	}
        	delete[] cube[i];
    	}

    	delete[] cube;





	
		return 0;

}

