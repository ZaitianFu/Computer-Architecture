// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// writeenable (output) - should a new value be captured by the register file
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, rd_src, alu_src2, writeenable, except, opcode, funct);
    output [2:0] alu_op;
    output       rd_src, alu_src2, writeenable, except;
    input  [5:0] opcode, funct;
		
	wire and_ = (opcode == `OP_OTHER0) & (funct == `OP0_AND);//    100
	wire or_ = (opcode == `OP_OTHER0) & (funct == `OP0_OR);//	   101
	wire nor_ = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);//    110
	wire xor_ = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);//    111
	wire add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);//     010
	wire sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);//	   011

	wire addi = (opcode == `OP_ADDI); //& (funct == `OP0_JR);      010
	wire andi = (opcode == `OP_ANDI); //& (funct == `OP0_SYSCALL); 100
	wire ori = (opcode == `OP_ORI); //& (funct == `BREAK);		   101
	wire xori = (opcode == `OP_XORI);					//		   111


	assign writeenable = (add | sub | and_ | or_ | xor_ | nor_ | addi | andi | ori | xori);
	assign except= ~ writeenable;	
	assign rd_src =  (addi | andi | ori | xori);
	assign alu_src2 = rd_src;
	
	assign alu_op[0] = (or_ | xor_ | sub | ori | xori);
	assign alu_op[1] = (xor_ | nor_ | add | sub | addi | xori);
	assign alu_op[2] = (and_ | or_ | xor_ | nor_ | andi | ori | xori);
endmodule // mips_decode
