module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire     k1,k2,k3,k4,k5,k6,k7,k8,k9,k0;

and n1(k1,a,d);
and n2(k2,b,d);
and n3(k3,c,d);
and n4(k4,a,e);
and n5(k5,b,e);
and n6(k6,c,e);
and n7(k7,a,f);
and n8(k8,b,f);
and n9(k9,c,f);
and n0(k0,b,g);

or ovalid(valid,k1,k2,k3,k4,k5,k6,k7,k8,k9,k0);
or o0(number[0],k1,k3,k5,k7,k9);
or o1(number[1],k2,k3,k6,k7);
or o2(number[2],k4,k5,k6,k7);
or o3(number[3],k8,k9);
endmodule // keypad
