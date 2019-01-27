// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
           output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC, nextPC;  
	wire [31:0] rsData,rtData,rdData,B;
	wire [31:0] imm32;
	wire [4:0]  Rdest;
	wire wr_enable, rd_src, alu_src2, mem_read, word_we, byte_we, byte_load, lui, slt, addm;
	wire [2:0] alu_op;  
	//new
	wire [31:0]data_out,a1_out, slt_out, a2_out, a3_out, a4_out, addm_out, addm2_out, bl_out, mr_out;
	wire [1:0] control_type;
    wire [7:0] bc_out;
	wire  zero, negative, overflow;

    register #(32) PC_reg(PC,nextPC,clock, 1'b1, reset);          // from lab5
	//alu32 pcplus4(nextPC, , , , PC,32'h4, `ALU_ADD);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2] );

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, wr_enable, clock, reset);

    /* add other modules */
	
	mux2v #(5) mux0 (Rdest, inst[15:11], inst[20:16], rd_src);
	mux2v #(32) mux1 (B, rtData, imm32, alu_src2);
	
	
	//sign extender
		assign imm32= {{16{inst[15]}},inst[15:0]};


    /* add other modules */
	data_mem dm(data_out, addm_out, rtData, word_we, byte_we, clock, reset);
	mux2v #(32) mux2(slt_out, a1_out, {31'b0, negative}, slt);
    mux2v #(32) mux3(addm_out, a1_out, rsData, addm);
    mux2v #(32) mux4(bl_out, data_out, {24'b0, bc_out}, byte_load);
    mux2v #(32) mux5(mr_out, slt_out, bl_out, mem_read);
	mux2v #(32) mux7(addm2_out, mr_out, a3_out, addm);
    mux2v #(32) mux6(rdData, addm2_out, {inst[15:0], 16'b0}, lui);
    mux4v #(8) mux8(bc_out, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], addm_out[1:0]);
    mux4v #(32) mux9(nextPC, a2_out, a4_out, {PC[31:28], inst[25:0], 2'b0}, rsData, control_type);

	alu32 a1(a1_out, zero, negative, overflow, rsData, B, alu_op);
    alu32 a2(a2_out, ,,, PC, 32'b100, `ALU_ADD);
    alu32 a3(a3_out, ,,, mr_out, rtData, 3'b010);
    alu32 a4(a4_out, ,,, a2_out, {imm32[29:0], 2'b0}, `ALU_ADD);
	
	mips_decode decoder(alu_op, rd_src, alu_src2, wr_enable, except, control_type[1:0],
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   inst[31:26], inst[5:0], zero);


endmodule // full_machine
