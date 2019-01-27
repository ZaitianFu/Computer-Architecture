module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target, oldnext_PC;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{instM[15]} }, instM[15:0] };  // sign-extended immediate
    wire [4:0]   rs = instM[25:21];
    wire [4:0]   rt = instM[20:16];
    wire [4:0]   rd = instM[15:11];
    wire [5:0]   opcode = instM[31:26];
    wire [5:0]   funct = instM[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;
	wire [31:0] oldrd1_data, oldrd2_data;

	wire [2:0] oldALUOp;
	wire  oldRegWrite, oldBEQ, oldALUSrc, oldMemRead, oldMemWrite, oldMemToReg, oldRegDst;

	wire [29:0] PC_plus4M;
    wire [31:0] instM,alu_out_dataM,rd2_dataM;
    wire MemReadM,MemWriteM,MemToRegM,RegWriteM;
    wire [4:0]  wr_regnumM;
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4M, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;
	

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (oldrd1_data, oldrd2_data,
               rs, rt, wr_regnumM, wr_data,
               RegWriteM, clk, reset);

    mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_dataM, rd2_dataM, MemReadM, MemWriteM, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_dataM, load_data, MemToRegM);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

	
	assign stall = MemReadM && ((wr_regnumM == rt && RegDst) || (wr_regnumM == rs)) && rs != 0;
	assign flush = PCSrc || reset;

	register #(30,30'h100000) Piplinepcnew (PC_plus4M,PC_plus4,clk,~stall,flush);
    register #(32) Piplineinsnew(instM,inst,clk,~stall,flush);

    register #(32) PipALUout(alu_out_dataM,alu_out_data,clk,~stall,stall);
    register #(32) PiplineW_D(rd2_dataM, rd2_data,clk, ~stall, stall);

    register #(1)  PiplineM0(MemReadM,MemRead,clk,~stall,stall);
  	register #(1)  PiplineM1(MemWriteM,MemWrite,clk,~stall,stall);
  	register #(1)  PiplineM2(MemToRegM,MemToReg,clk,~stall,stall);
	register #(1)  PiplineM3(RegWriteM,RegWrite,clk,~stall,stall);
  	register #(5)  PiplineM4(wr_regnumM,wr_regnum,clk,~stall,stall);
	
	mux2v #(32) rd1new(rd1_data,oldrd1_data,alu_out_dataM,ForwardA);
	mux2v #(32) rd2new(rd2_data,oldrd2_data,alu_out_dataM,ForwardB);
	
	
	assign ForwardA = (wr_regnumM == rs) && RegWriteM && (wr_regnumM!=0);
	assign ForwardB = (wr_regnumM == rt) && RegWriteM && (wr_regnumM!=0);

endmodule // pipelined_machine
