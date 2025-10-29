`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:10:04 11/17/2022 
// Design Name: 
// Module Name:    regFile 
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
module regFile(	input clk,
	input regWrite,
	input [4:0] readReg1,
	input [4:0] readReg2,
	input [4:0] writeReg,
	input [31:0] writeData,
	output [31:0] readData1,
	output [31:0] readData2 );
	
	
	reg [31:0] registers [31:0];
	initial registers[0] = 0;  // zero register set to zero
	assign readData1 = registers[readReg1];
	assign readData2 = registers[readReg2];
	
	integer i;
	initial  
		begin 
			for(i=1 ; i<32 ; i=i+1)
				registers[i] = i;
		end
		
	always @(posedge clk) 
		begin
			if (regWrite == 1)
				begin
				if (writeReg == 0) // Zero Register Cant be changed
					begin
						$display("%h", registers[writeReg]);
						$display("You can't change the value of zeroRegister!");
						$display("%h", registers[writeReg]);
					end
				else 	
					begin
						$display("%h", registers[writeReg]);
						registers[writeReg] = writeData;
						$display("%h", registers[writeReg]);
						$display("job done");
					end
			end
			else
				begin
					$display("%h", registers[writeReg]);
					$display("You can't write anything at this moment");
					$display("%h", registers[writeReg]);
				end
		end


endmodule
