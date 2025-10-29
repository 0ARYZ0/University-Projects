`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:37 11/04/2022 
// Design Name: 
// Module Name:    cache 
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
module cache(input [127:0] data,// output of our instruction memory
				 input [31:0] address, // output of the pc
				 input clock,
				 output reg [31:0] instruction, // this is the output of cache
				 output reg hit);

		reg [153:0] cache [7:0];

		//valid Bit should be 0 at start
		integer i;
		initial begin  
			for(i=0;i<8;i=i+1)
			begin
				cache[i]=0;
			end
		end

		always@(data)
			begin
				if(data !== 128'bx)
					begin
						cache[address[6:4]][153] = 1;  					// the valid bit
						cache[address[6:4]][152:128] = address[31:7]; // 25 bit of our tag
						cache[address[6:4]][127:0] = data; 		  // 128 bit of our 4 instructions
					end
			end

		always@(posedge clock)
			begin
				if(cache[address[6:4]][152:128] == address[31:7] && cache[address[6:4]][153] == 1)
					begin
						hit = 1;
						if(address[3:2] == 2'b00)
							instruction = cache[address[6:4]][31:0];
						if(address[3:2] == 2'b01)
							instruction = cache[address[6:4]][63:32];
						if(address[3:2] == 2'b10)
							instruction = cache[address[6:4]][95:64];
						if(address[3:2] == 2'b11)
							instruction = cache[address[6:4]][127:96];
					end
				else
					begin
						hit= 0;
						instruction = 32'bx;
					end
		end


endmodule
