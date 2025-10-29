`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:37 12/03/2022 
// Design Name: 
// Module Name:    if_id 
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
module if_id(	input 	clk,
	input 	[31:0] instruction,
	input 	[31:0] next_pc,
	input 	hit,
	output	reg [31:0] next_pc_out,
	output  	reg [31:0] instruction_out,
	output   reg hitOut );
	
	
	initial
	begin
		instruction_out = 0;
		next_pc_out = 0;
	end
	
	always @(negedge clk ) 
	begin
			instruction_out = instruction;
			next_pc_out = next_pc;
			hitOut = hit;	
	end


endmodule
