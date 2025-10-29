`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:50:40 12/08/2022 
// Design Name: 
// Module Name:    alu_CU 
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
module alu_CU(input [2:0]AluOp,
		input [5:0]Function,
		output [3:0]AluCnt
    );
	 
	 assign AluCnt = AluOp == 3'b000 ?
									Function == 6'b000000 ? 4'b0000 :
									Function == 6'b000001 ? 4'b0001 :
									Function == 6'b000010 ? 4'b0101 :
									Function == 6'b000011 ? 4'b0110 :
									Function == 6'b000100 ? 4'b0111 :
									Function == 6'b000101 ? 4'b0011 :
									Function == 6'b000110 ? 4'b0100 : 4'b0010 : // function == 6'b000111
						  AluOp == 3'b001 ? 4'b0001:
						  AluOp == 3'b010 ? 4'b0111: 4'b0000; //aluop == 011

endmodule
