`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:12:47 10/28/2022 
// Design Name: 
// Module Name:    instructionMemory 
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
module instructionMemory(input [31:0]insAddress,
		input clock,
		output reg [127:0] out);
		
		reg [7:0] memory [1023:0];
		reg [2:0] clkCount = 0;
		reg [31:0] address = 0;
		
				//for debug
		////////////////////////////////////////////////////////////////////////////////////////
		//integer i ;
		initial begin
			//1add 1,2,3
			memory[0] = 'h00;
			memory[1] = 'h43;
			memory[2] = 'h08;
			memory[3] = 'h00;
			//2sub 4,5,6
			memory[4] = 'h00;
			memory[5] = 'ha6;
			memory[6] = 'h20;
			memory[7] =	'h01;
			//3and 7,8,9
			memory[8] = 'h01;
			memory[9] = 'h09;
			memory[10] = 'h38;
			memory[11] = 'h02;
			//4or 10,11,12
			memory[12] = 'h01;
			memory[13] = 'h6c;
			memory[14] = 'h50;
			memory[15] = 'h03;
			//5slt 13,14,15
			memory[16] = 'h01;
			memory[17] = 'hcf;
			memory[18] = 'h68;
			memory[19] = 'h04;
			//6not 16,17
			memory[20] = 'h02;
			memory[21] = 'h20;
			memory[22] = 'h80;
			memory[23] = 'h07;
			//7sw $18,4($19)
			memory[24] = 'h16;
			memory[25] = 'h72;
			memory[26] = 'h00;
			memory[27] = 'h04;
			//8addi $20, $21, 21
			memory[28] = 'h1e;
			memory[29] = 'hb4;
			memory[30] = 'h00;
			memory[31] = 'h15;
			//9slti $22, $23, 23
			memory[32] = 'h06;
			memory[33] = 'hf6;
			memory[34] = 'h00;
			memory[35] = 'h17;
			//10lsl $24, $25, 3
			memory[36] = 'h03;
			memory[37] = 'h20;
			memory[38] = 'hc0;
			memory[39] = 'hc5;
			//11lsr $26, $27, 3
			memory[40] = 'h03;
			memory[41] = 'h60;
			memory[42] = 'hd0;
			memory[43] = 'hc6;
			//12lw $18, 4($19)
			memory[44] = 'h12;
			memory[45] = 'h72;
			memory[46] = 'h00;
			memory[47] = 'h04;
			//13beq 0,0,-13
			memory[48] = 'h18;
			memory[49] = 'h00;
			memory[50] = 'hff;
			memory[51] = 'hf3;
			//////////////////
			// for(i = 52; i < 1024; i = i + 1)begin
			// 	memory[i] = 0;
			// end
			// memory[52] = 'h00;
			// memory[53] = 'h43;
			// memory[54] = 'h08;
			// memory[55] = 'h00;
			// memory[56] = 'h00;
			// memory[57] = 'h43;
			// memory[58] = 'h08;
			// memory[59] = 'h00;
			// memory[60] = 'h00;
			// memory[61] = 'h43;
			// memory[62] = 'h08;
			// memory[63] = 'h00;

		end
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		//so that we don't have 'don't care' in our initial outputs
	/*	initial begin
				out = 128'b0;

	   end*/
		
		
		always @(posedge clock) begin
			if(address[31:4] != insAddress[31:4])
			begin
				clkCount = 1;
				address = {insAddress[31:4], {4'b00}};
			end
			else if(clkCount == 4)
			begin
				clkCount = 0;
				out = {memory[address + 15], memory[address + 14], memory[address + 13], memory[address + 12] , memory[address + 11], memory[address + 10], memory[address + 9], memory[address + 8] , memory[address + 7], memory[address + 6], memory[address + 5], memory[address + 4] , memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};
			end
			else 
			begin
				clkCount = clkCount + 1;
			end					
			
		end
		
		/*always @(insAddress)
			begin
				clkCount = 0;
			end*/
				

endmodule
