`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:18:30 12/08/2022 
// Design Name: 
// Module Name:    execute 
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
module execute(input clk,
	input [31:0]pc_in,
	input [31:0] ALU_Read_Data1,
	input [31:0] ALU_Read_Data2,
	input [31:0] Immediate,
	input [5:0]  funct,
	input [2:0]  alu_op,
	input alu_src,
	//new
	input [4:0]rt,
	input [4:0]rd,
	input regDst,
	
	output [31:0] ALU_Result,
	output Zero,
	output [31:0] addResult,
	output [31:0] ALU_ReadData,
	output [4:0] RdOrRt);
	 
	wire [3:0] AlU_Control;
	//assign RdOrRt = Immediate[10:6];
	//this the 2 to 1 mux(before the ALU)
	assign ALU_ReadData = (alu_src) ? Immediate : ALU_Read_Data2;
	//new
	wire [4:0]shiftAmount;
	wire [31:0]shifted_immediate;
	
	// ALU_Control_Unit Instance
	alu_CU alu_CUInstance (
		.AluOp(alu_op), 
		.Function(funct), 
		.AluCnt(AlU_Control)
	);

	// ALU Instance
	ALU ALU_Instance (
		 .input1(ALU_Read_Data1), 
		 .input2(ALU_ReadData), 
		 .AluC(AlU_Control), 
		 .shamt(shiftAmount), 
		 .result(ALU_Result), 
		 .zero(Zero)
		 );
	assign shiftAmount = Immediate[10:6];	 
	assign RdOrRt = regDst ? rd : rt;

	
	assign shifted_immediate = Immediate<<2;

	assign addResult = shifted_immediate + pc_in;
	
	
endmodule
