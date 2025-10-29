`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:02:06 11/04/2022 
// Design Name: 
// Module Name:    revisedPC 
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
module revisedPC(input [31:0] inp,
			 input clock,
			 output reg[31:0] out,
			 input hit
    );
	 
	 initial begin
			out = 0;
	 end
	 
	 always @( negedge clock)
	 begin
			if ( hit == 1)
						out = inp;
	 end
    


endmodule
