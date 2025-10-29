`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:21:06 01/18/2023 
// Design Name: 
// Module Name:    mem_wb 
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
module mem_wb(clk, hit, readData, ALUResult, writeReg, RegWrite, MemtoReg,hitOut, readDataOut,
				  ALUResultOut, writeRegOut, RegWriteOut,MemtoRegOut);

		input clk;
		input hit;
		input RegWrite;
		input MemtoReg;
		input [4:0] writeReg;
		input [31:0]readData;
		input [31:0]ALUResult;
		
		output     hitOut ;
		output reg RegWriteOut;
		output reg MemtoRegOut;
		output reg [4:0]  writeRegOut;
		output reg [31:0] readDataOut;
		output reg [31:0] ALUResultOut;
		
		assign hitOut = hit;
		
		always @(negedge clk)
			begin
				if(hit) 
					begin 
						MemtoRegOut  <= MemtoReg;
						RegWriteOut  <= RegWrite;
						writeRegOut  <= writeReg;
						readDataOut  <= readData;
						ALUResultOut <= ALUResult;		
					end
			end
endmodule
