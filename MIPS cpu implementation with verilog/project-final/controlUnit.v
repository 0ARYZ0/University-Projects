`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:41 12/03/2022 
// Design Name: 
// Module Name:    controlUnit 
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
module controlUnit(		input [5:0]opcode,
		output regDst,
		output aluSrc,
		output memToReg,
		output regWrite,
		output memRead,
		output memWrite,
		output branch,
		output [2:0]aluOp
    );
	 
	 assign regDst = opcode == 6'b000000 ? 1 : 0; 	//r-type
	 
	 assign aluSrc = opcode == 6'b000000 ? 0 :	 	//r-type
						  opcode == 6'b000110 ? 0 : 1;	//beq
	
	 assign memToReg = opcode == 6'b000100 ? 1 : 0; //lw	

	 assign regWrite = opcode == 6'b000101 ? 0 :		//sw
							 opcode == 6'b000110 ? 0 : 1;	//beq
	
	 assign memRead = opcode == 6'b000100 ? 1 : 0;	//lw
	
	 assign memWrite = opcode == 6'b000101 ? 1 : 0;	//sw
	 
	 assign branch = opcode == 6'b000110 ? 1 : 0;	//beq
	 
	 assign aluOp = opcode == 6'b000000 ? 3'b000 :			 //r-type
						 opcode == 6'b000100 ? 3'b011 :			 //lw
						 opcode == 6'b000101 ? 3'b011 : 			 //sw
						 opcode == 6'b000111 ? 3'b011 : 			 //addi
						 opcode == 6'b000110 ? 3'b001 : 3'b010; //beq / slti
		

		
		

endmodule
