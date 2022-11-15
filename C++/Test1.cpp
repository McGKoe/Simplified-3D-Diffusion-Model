#include<iostream>
#include<fstream>
#include <cmath>

using namespace std;


int main()
{

	int maxsize = 10;

  	int bitmap[maxsize + 2][maxsize + 2][maxsize + 2];


int cube[maxsize][maxsize][maxsize];

                for (int i=0; i< maxsize + 2; i++) {
                        for (int j=0; j< maxsize + 2; j++) {
                                for (int k=0; k< maxsize + 2; k++) {

					cout << i << j << k << endl;

					if(i == 0 || j == 0 || k == 0)
						bitmap[i][j][k] = 0;

					else if( i == maxsize+1 || j == maxsize+1 || k == maxsize+1)
						bitmap[i][j][k] = 0;


					else if((i == round((maxsize + 2)/2)) && j >= floor((maxsize + 2) * .25 ))
						bitmap[i][j][k] = 0;
					
					else
						bitmap[i][j][k] = 1;
				}
			}
		}



	for (int i=0; i< maxsize + 2; i++) {
			cout << "Slice " << i << ":" << "\n";
                        for (int j=0; j< maxsize + 2; j++) {
                                for (int k=0; k< maxsize + 2; k++) {
					cout << bitmap[i][j][k];
				}
			cout << "\n";
			}
	}

                for (int i=0; i< maxsize; i++) {
                        for (int j=0; j< maxsize; j++) {
                                for (int k=0; k< maxsize; k++) {

                                        if(bitmap[i + 1][j + 1][k + 1] == 0)
						cube[i][j][k] = 0;
					else
						cube[i][j][k] = 1;
                                }
                        }
                }
        for (int i=0; i< maxsize; i++) {
                        cout << "Slice " << i << ":" << "\n";
                        for (int j=0; j< maxsize; j++) {
                                for (int k=0; k< maxsize; k++) {
                                        cout << cube[i][j][k];
                                }
                        cout << "\n";
                        }
        }



	return 0;

}
