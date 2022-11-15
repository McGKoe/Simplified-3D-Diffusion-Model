#include<iostream>
#include<fstream>
#include <cmath>

using namespace std;


int main()
{

	int maxsize = 10;

  	int bitmap[maxsize+2][maxsize+2][maxsize+2];



                for (int i=0; i< maxsize; i++) {
                        for (int j=0; j< maxsize; j++) {
                                for (int k=0; k< maxsize; k++) {

					if(	(i == 0) || (i == maxsize + 1) ||
						(j == 0) || (j == maxsize + 1) ||
						(k == 0) || (k == maxsize + 1))
                                        {
                                                /* zeros the walls of the room */
                                               	bitmap[i][j][k] = 0;
                                        }
					else if(	(i == (maxsize)/2) && (j >= 1 + (maxsize * .25)))
						bitmap[i][j][k] = 0;
					
					else
						bitmap[i][j][k] = 1;
				}
			}
		}



	for (int i=0; i< maxsize; i++) {
			cout << "Slice " << i << ":" << "\n";
                        for (int j=0; j< maxsize; j++) {
                                for (int k=0; k< maxsize; k++) {
					cout << bitmap[i][j][k];
				}
			cout << "\n";
			}
	}


	return 0;

}
