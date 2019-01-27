/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include<cmath>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
   assert((length % 8) == 0);

   // allocate an array for the output
   char *message_out = new char[length];

	// TODO: write your code here
/*	int matrix[length][8];			//matrix
	char buffer[10];
	for (int i=0;i<length;i++){
	  for(int j=0;j<8;j++ ){
	    matrix[i][j]=(message_in[i])&(1<<(7-j));
	      
	   }		     	
	}
	
	cout>>(1<<7);
	int Tmatrix[length][8];			//transpose
	for (int i=0; i<length;i++){
	   for (int j=0;j<8;j++){
	      Tmatrix[i][j]=matrix[7-j][7-i];
	   }
	}

	for (int i=0;i<length;i++){		//ascII code
           int sum=0;
	   for (int j=0;j<8;j++){
	      sum=sum+(Tmatrix[i][j]*pow(2,7-j));
	   }
	   message_out[i]=(char)sum;
	}

*/	


int LSB;int output[8];int count=0;int letter=0;

for (int i=0;i<length;i++){
   for (int j=0;j<8;j++){
      LSB=(message_in[j+letter]>>count)&1;
      output[j]=LSB;
   }
   
   char out=(char)((char)output[0]+((char)output[1]<<1)+((char)output[2]<<2)+((char)output[3]<<3)+((char)output[4]<<4)+((char)output[5]<<5)+((char)output[6]<<6)+((char)output[7]<<7));
   
   message_out[i]=out;
   
   if(count==7){
      count=0;
      letter=letter+8;
   }
   else
   	count++;
   
}





return message_out;
}


