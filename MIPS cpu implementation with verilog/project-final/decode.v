`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:12:04 11/17/2022 
// Design Name: 
// Module Name:    decode 
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
module decode( 		input clk,
		input [31:0]instruction,
		input regWrite,
		input [4:0]write_reg,
		input [31:0]write_data,

		output [5:0]opcode,
		output [31:0]read_data1,
		output [31:0]read_data2,
		output [31:0]sign_extended,
		output [4:0]rt,
		output [4:0]rd,
		output [5:0]funct
    );

	 assign rt = instruction[20:16];
	 assign rd = instruction[15:11];
	 assign opcode = instruction[31:26];
	 assign funct = instruction[5:0];
		
		
	regFile regFileInstance (
		.clk(clk), 
		.regWrite(regWrite), 
		.readReg1(instruction[25:21]), 
		.readReg2(instruction[20:16]), 
		.writeReg(write_reg), 
		.writeData(write_data), 
		.readData1(read_data1), 
		.readData2(read_data2)
	);
	
	signExtend signExtendInstance (
		.inp(instruction[15:0]), 
		.sign_extended(sign_extended)
	);
	



endmodule
