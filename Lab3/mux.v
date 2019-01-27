// output = A (when control == 0) or B (when control == 1)
module mux2(out, A, B, control);
    output out;
    input  A, B;
    input  control;
    wire   wA, wB, not_control;
         
    not n1(not_control, control);
    and a1(wA, A, not_control);
    and a2(wB, B, control);
    or  o1(out, wA, wB);
endmodule // mux2

// output = A (when control == 00) or B (when control == 01) or
//          C (when control == 10) or D (when control == 11)
module mux4(out, A, B, C, D, control);
    output      out;
    input       A, B, C, D;
    input [1:0] control;
    wire	ab,cd;

	mux2 mab(ab,A,B,control[0]);
	mux2 mcd(cd,C,D,control[0]);
	mux2 mout(out,ab,cd,control[1]);

endmodule // mux4
