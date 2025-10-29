`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:53 01/18/2023 
// Design Name: 
// Module Name:    data_memory 
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
module data_memory(clk,address,writeData,MemWrite,MemRead,readData);

	input clk;
	input [31:0] address;
	input [31:0] writeData;
	input MemWrite;
	input MemRead;
	
	output reg [31:0] readData;

	// 8 columns & 1024 rows 
	reg [7:0] RAM [1023:0];
	
	integer i;
	initial
		begin
			for(i = 0;i<=1023;i = i+1)
				RAM[i] = i;
		end
		
	always @ (posedge clk)
		begin
			if (MemRead)
				begin

					readData = {RAM[address+3], RAM[address+2], RAM[address+1], RAM[address]};
				end
			
			if (MemWrite) 
				begin
					RAM[address]   = writeData[7:0];
					RAM[address+1] = writeData[15:8];
					RAM[address+2] = writeData[23:16];
					RAM[address+3] = writeData[31:24];

				end	
		end

endmodule
