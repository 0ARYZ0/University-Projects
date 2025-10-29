`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:09:07 10/23/2022 
// Design Name: 
// Module Name:    mux32 
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
module mux32(input[31:0] A,
			    input[31:0] B,
				 input sel,
				 output[31:0] out
    );

	assign out = sel ? B: A;



endmodule
