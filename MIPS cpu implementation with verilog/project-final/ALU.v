`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:01:42 12/08/2022 
// Design Name: 
// Module Name:    ALU 
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
module ALU(			input [3:0]AluC,
		input [4:0]shamt,
		input [31:0]input1,
		input [31:0]input2,
		output [31:0]result,
		output zero
    );
	 
	 assign result = AluC == 4'b0000 ? input1 + input2 :
						  AluC == 4'b0001 ? input1 - input2 :
						  AluC == 4'b0010 ? ~input1 :
						  AluC == 4'b0011 ? input1 << shamt :
						  AluC == 4'b0100 ? input1 >> shamt :
						  AluC == 4'b0101 ? input1 & input2:
						  AluC == 4'b0110 ? input1 | input2:
										(input1 < input2) ? 1 : 0;  // aluc == 4'b0111
										
										
	 assign zero = result == 0 ? 1 : 0;
	


endmodule
