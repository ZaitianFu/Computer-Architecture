`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
	wire [31:0] user_status,decoderout;
	wire exception_level,a1,a2,a3,epcenable,exceptreset;
	wire [29:0] epcin;
  	
	wire [31:0] status_register = {16'b0,user_status[15:8],6'b0,exception_level,user_status[0]};
	wire [31:0] cause_register = {16'b0,TimerInterrupt,15'b0};

	and a12(a1,cause_register[15],status_register[15]);
	not n12(a2,status_register[1]);
	and a32(a3,a2,status_register[0]);
	and final(TakenInterrupt,a3,a1);

	decoder32 mtc00(decoderout,regnum,MTC0);

	mux2v #(30)epcinmux(epcin,wr_data[31:2],next_pc,TakenInterrupt);

	or o2(epcenable,decoderout[14],TakenInterrupt);
	
	register #(30) epcregister(EPC,epcin,clock,epcenable,reset);
	or o1(exceptreset,ERET,reset);
	
	dffe exception(exception_level,1'b1,clock,TakenInterrupt,exceptreset);
	register useus(user_status,wr_data,clock,decoderout[12],reset);

	mux32v dataout(rd_data,0,0,0,0,0,0,0,0,0,0,0,0, status_register, cause_register, {EPC,2'b00},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, regnum);

endmodule
