module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output palindrome, done, select, load;
	input go, a_ne_b, front_ge_back;
	input clock, reset;
	wire sGarbage, sStart, s1, s2, s3, s4, s11, s22, s33, s44, sDone1,sDone2;

/*assign done= (~front_ge_back & ~go & clock) | reset;
assign select= ~go & ~reset & clock & front_ge_back;
assign load= ~go & ~reset & clock;
assign palindrome= ~a_ne_b & clock & ~reset & ~front_ge_back & ~go;
*/

	wire sGarbage_next = sGarbage & ~go| reset; //p1
	wire sStart_next = (sStart & go | sGarbage & go | sDone1 & go | sDone2 & go) & ~reset;

	wire s1_next=(sStart & (~go & ~a_ne_b & ~front_ge_back)) & ~reset;//p1
	wire s2_next = s1 & ~reset;
	wire s3_next = s2 & ~reset;
	wire s4_next = s3 & ~reset;

	wire s11_next = (sStart & ~go & (a_ne_b | front_ge_back))& ~reset;//p1
	wire s22_next = s11 & ~reset;
	wire s33_next = s22 & ~reset;
	wire s44_next = s33 & ~reset;
	 
	wire sDone1_next = (s4  | (sDone1 & ~go))& ~reset;
	wire sDone2_next = (s44 | (sDone2 & ~go))& ~reset;

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);

	dffe fs1(s1, s1_next, clock, 1'b1, 1'b0);
	dffe fs2(s2, s2_next, clock, 1'b1, 1'b0);
	dffe fs3(s3, s3_next, clock, 1'b1, 1'b0);
	dffe fs4(s4, s4_next, clock, 1'b1, 1'b0);
	
	dffe fs11(s11, s11_next, clock, 1'b1, 1'b0);
	dffe fs22(s22, s22_next, clock, 1'b1, 1'b0);
	dffe fs33(s33, s33_next, clock, 1'b1, 1'b0);
	dffe fs44(s44, s44_next, clock, 1'b1, 1'b0);
	
	dffe fsDone1 (sDone1, sDone1_next, clock, 1'b1, 1'b0);
	dffe fsDone2 (sDone2, sDone2_next, clock, 1'b1, 1'b0);

	assign done = sDone1 | sDone2;// p1
	assign palindrome = sDone1;
	assign load= go;
	assign select= ~front_ge_back;
			
endmodule // palindrome_control 
