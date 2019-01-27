// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
	wire w00,w01,w10,w11;
	
	and n00(w00,A,B);
	or n01(w01,A,B);
	nor n10(w10,A,B);
	xor n11(w11,A,B);

	mux4 o0(out,w00,w01,w10,w11,control);

endmodule // logicunit
