`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:03:17 01/19/2023
// Design Name:   MIPS
// Module Name:   C:/Users/ARYZ/Desktop/project/mips/mips_tb_final.v
// Project Name:  mips
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MIPS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_tb_final;

	// Inputs
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	MIPS uut (
		.clk(clk)
	);

integer i =0 ;
initial begin
    clk = 0;
end
	always #50 clk = ~clk;
	initial
begin
    $dumpfile("MIPS.vcd");
    $dumpvars(0,mips_tb_final);
end
always @(posedge clk) begin
    if(i > 100)begin
        $finish;
    end
    i = i + 1;
end

	
      
endmodule

