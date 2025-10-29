`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:54:37 11/17/2022 
// Design Name: 
// Module Name:    signExtend 
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
module signExtend(input  [15:0]  inp,
						output [31:0]  sign_extended);
						
		assign sign_extended [15:0] = inp;				
		assign sign_extended [31:16] = {16{inp[15]}};


endmodule
