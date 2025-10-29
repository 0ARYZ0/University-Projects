`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:15:02 01/18/2023 
// Design Name: 
// Module Name:    ex_mem_register 
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
module ex_mem_register(clk, hit, branchTarget, zeroFlag, ALUResult, readDataTwo,writeReg, MemRead,
							  MemWrite, Branch, RegWrite, MemToReg ,branchTargetOut, zeroFlagOut, ALUResultOut, 
							  readDataTwoOut,writeRegOut, MemReadOut, MemWriteOut, BranchOut, RegWriteOut,
							  MemToRegOut, hitOut);

		input clk;
		input hit;
		input zeroFlag;
		input MemRead;
		input MemWrite;
		input Branch;
		input RegWrite;
		input MemToReg;
		input [31:0] branchTarget;
		input [31:0] ALUResult;
		input [31:0] readDataTwo;
		input [4:0]  writeReg;
		
		output reg zeroFlagOut;
		output reg MemReadOut;
		output reg MemWriteOut;
		output reg BranchOut;
		output reg RegWriteOut;
		output reg MemToRegOut;
		output reg [31:0] branchTargetOut;
		output reg [31:0] ALUResultOut;
		output reg [31:0] readDataTwoOut;
		output reg [4:0] writeRegOut;
		output hitOut;


		always @(negedge clk) 
			begin
			  if(hit) 
					begin 
					  MemReadOut     <= MemRead;
					  MemWriteOut    <= MemWrite;
					  BranchOut      <= Branch;
					  RegWriteOut    <= RegWrite;
					  MemToRegOut    <= MemToReg;
					  writeRegOut    <= writeReg;
					  branchTargetOut<= branchTarget;
					  ALUResultOut   <= ALUResult;
					  readDataTwoOut <= readDataTwo;
					  zeroFlagOut    <= zeroFlag;

					end
			end
endmodule
