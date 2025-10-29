`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:57 11/04/2022 
// Design Name: 
// Module Name:    fetch 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fetch(	input [31:0] BranchTarget,
					input wire ClockPulse,           
					input PcSource,									  
					output [31:0] NextPc,			 
					output [31:0] Instruction,     
					output wire Hit);

					
	wire [31:0] muxToPC;
	wire [31:0] pc_out;


	wire [127:0] data_line;
    wire hit;
    wire [31:0]pc_out_toMux;
					
					
	/*		mux32 mux32Instance (
		.A(NextPc), 
		.B(BranchTarget), 
		.sel(PcSource), 
		.out(NextAddress)
	);	*/
    assign muxToPC = (PcSource !== 1) ? pc_out_toMux : BranchTarget;		
					
			revisedPC revisedPCInstance (
		.inp(muxToPC), 
		.clock(ClockPulse), 
		.out(pc_out), 
		.hit(Hit)
	);			
					
					
		   instructionMemory instructionMemoryInstance (
		.insAddress(pc_out), 
		.clock(ClockPulse), 
		.out(DataLine)
	);		
					
		  cache cacheInstance (
		.data(data_line), 
		.address(Address), 
		.clock(ClockPulse), 
		.instruction(Instruction), 
		.hit(Hit)
	);
    assign NextPc = pc_out + 4;
    assign pc_out_toMux = pc_out + 4;

endmodule
