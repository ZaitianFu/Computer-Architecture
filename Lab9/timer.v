module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here


    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle

	wire[31:0] QC,DC,Q;
    wire TimerWrite,TimerRead,Acknowledge;
	wire intlineenable,realreset;

    //assign q =32'hffffffff;
    wire gettime = address==32'hffff001c;
    wire storetime =  address==32'hffff006c;
	//gate
    and l0(TimerRead,MemRead,gettime);
    and l1(TimerWrite,MemWrite,gettime);
    and l2(Acknowledge,storetime,MemWrite);
    or l3(TimerAddress,storetime,gettime);
    or l4(realreset,reset,Acknowledge);

    register #(32,32'hffffffff) interuptcycle(Q,data,clock,TimerWrite,reset);
	//CC
	register cyclecounter(QC, DC, clock, 1'b1, reset);
    alu32 plus1(DC, , ,`ALU_ADD, QC,32'b1);
    
	// interupt line
    assign intlineenable = Q==QC;  
    register #(1) interuptline(TimerInterrupt,1'b1,clock,intlineenable,realreset);
	//cycle out
	tristate cycleout(cycle,QC,TimerRead);
endmodule
