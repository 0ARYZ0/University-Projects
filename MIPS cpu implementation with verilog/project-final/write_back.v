`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:19 01/18/2023 
// Design Name: 
// Module Name:    write_back 
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
module write_back(MemToReg,readData,ALUResult,writeData);

	input MemToReg;
	input [31:0] readData;
	input [31:0] ALUResult;

	output reg [31:0] writeData;
	
	always @(*)
		begin 
			if (MemToReg == 1)
				writeData = readData;
			else
				writeData = ALUResult;
		end
		
endmodule
