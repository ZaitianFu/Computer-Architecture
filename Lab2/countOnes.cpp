/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	
	unsigned right1=0x55555555;
	unsigned left1=0xAAAAAAAA;
	input=((input&left1)>>1)+(input&right1);
	
	unsigned right2=0x33333333;
	unsigned left2=0xCCCCCCCC;
	input=((input&left2)>>2)+(input&right2);
	
	unsigned right4=0x0F0F0F0F;
	unsigned left4=0xF0F0F0F0;
	input=((input&left4)>>4)+(input&right4);
	
	unsigned right8=0x00FF00FF;
	unsigned left8=0xFF00FF00;
	input=((input&left8)>>8)+(input&right8);
	
	unsigned right16=0x0000FFFF;
	unsigned left16=0xFFFF0000;
	input=((input&left16)>>16)+(input&right16);
	
	
	return input;
}
