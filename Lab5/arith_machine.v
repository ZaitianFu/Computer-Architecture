// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC, nextPC;  
	wire [31:0] rsData,rtData,rdData,B;
	wire [31:0] imm32;
	wire [4:0]  Rdest;
	wire wr_enable, rd_src, alu_src2, zero, negative, overflow;
	wire [2:0] alu_op;
	
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC,nextPC,clock, 1, reset);
	alu32 pcplus4(nextPC, , , , PC,32'h4, `ALU_ADD);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2] );

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, wr_enable, clock, reset);

    /* add other modules */
	
	mux2v #(5) mux0 (Rdest, inst[15:11], inst[20:16], rd_src);
	alu32 rddata(rdData, zero, negative, overflow, rsData, B, alu_op);
	mux2v #(32) mux1 (B, rtData, imm32, alu_src2);
	mips_decode decoder(alu_op,  rd_src, alu_src2, wr_enable, except, inst[31:26], inst[5:0]);
	
	//sign extender
		assign imm32[15:0]= inst[15:0];
    	assign imm32[16]= inst[15];
    	assign imm32[17]= inst[15];
    	assign imm32[18]= inst[15];
    	assign imm32[19]= inst[15];
    	assign imm32[20]= inst[15];
    	assign imm32[21]= inst[15];
    	assign imm32[22]= inst[15];
    	assign imm32[23]= inst[15];
    	assign imm32[24]= inst[15];
    	assign imm32[25]= inst[15];
    	assign imm32[26]= inst[15];
    	assign imm32[27]= inst[15];
    	assign imm32[28]= inst[15];
    	assign imm32[29]= inst[15];
    	assign imm32[30]= inst[15];
    	assign imm32[31]= inst[15];
	
	
	
   
endmodule // arith_machine
