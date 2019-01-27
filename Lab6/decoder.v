// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// writeenable  (output) - should a new value be captured by the register file
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, rd_src, alu_src2, writeenable, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       rd_src, alu_src2, writeenable, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;
	
	//from lab5
	wire and_ = (opcode == `OP_OTHER0) & (funct == `OP0_AND);//6'h 24   100      
	wire or_ = (opcode == `OP_OTHER0) & (funct == `OP0_OR);//	   25	101
	wire nor_ = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);//    27   111
	wire xor_ = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);//    26   110
	wire add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);//     20   000
	wire sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);//	   22   011

	wire addi = (opcode == `OP_ADDI); //& (funct == `OP0_JR);      08
	wire andi = (opcode == `OP_ANDI); //& (funct == `OP0_SYSCALL); 0c
	wire ori = (opcode == `OP_ORI); //& (funct == `BREAK);		   0d   
	wire xori = (opcode == `OP_XORI);					//		   0e 


	//new lab6
	wire bne = (opcode == `OP_BNE);         //					05
	wire beq = (opcode == `OP_BEQ);			//					04
	wire j = (opcode == `OP_J);				//					02
	wire jr = (opcode == `OP_OTHER0) & (funct == `OP0_JR);//	08
	wire lui = (opcode == `OP_LUI);//							0f
	wire slt = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);//	2a
	wire lw = (opcode == `OP_LW);//								23
	wire lbu = (opcode ==`OP_LBU);//							24
	wire sw = (opcode == `OP_SW);//								2b
	wire sb = (opcode == `OP_SB);//								28
	wire addm= (opcode == `OP0_ADDM);//							2c
	
	assign writeenable = (add | sub | and_ | or_ | xor_ | nor_ | addi | andi | ori | xori | lui | slt | lw | lbu | addm);
	assign except= ~(add | sub | and_ | or_ | xor_ | nor_ | addi | andi | ori | xori | bne | beq | j | jr | lui | slt | lw | lbu | sw | sb | addm);	
	assign rd_src =  (addi | andi | ori | xori | lui | lw | lbu | sb | sw);
	assign alu_src2 = (addi | andi | ori | xori | lui | lw | lbu | sb | sw);
	
	assign alu_op[0] = (or_ | xor_ | sub | ori | xori | beq | bne | lui | slt);
	assign alu_op[1] = (xor_ | nor_ | add | sub | addi | xori | beq | bne | lui | slt | lw | lbu | sw | sb);
	assign alu_op[2] = (and_ | or_ | xor_ | nor_ | andi | ori | xori);

	/*assign lui = lui;
    assign slt = slt;
    assign addm = addm;
	*/	
	assign mem_read = lw | lbu | addm;
	assign word_we = sw;
	assign byte_we = sb;
	assign byte_load = lbu;
	assign control_type[1] = (j | jr);
	assign control_type[0] = ((beq &zero) | (bne & ~zero) | jr);
endmodule // mips_decode
