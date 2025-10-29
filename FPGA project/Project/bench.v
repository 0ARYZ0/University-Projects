`timescale  1ns / 1ps    

module tb_Encoder;       

// Encoder Parameters    
parameter PERIOD = 10   ;
parameter s1  = 2'b00;   
parameter s2  = 2'b01;   
parameter s3  = 2'b10;   

// Encoder Inputs
reg   reset                                = 0 ;
reg   clk                                  = 0 ;
reg   start                                = 0 ;

// Encoder Outputs
wire  [7:0]code                         ;
wire  done                                 ;
wire  error                                ;
wire  [7:0]  primeter                      ;
wire  [11:0]  area                         ;
wire  [6:0]start_row                    ;
wire  [6:0]start_col                    ;

Encoder #(
    .s1 ( s1 ),
    .s2 ( s2 ),
    .s3 ( s3 ))
 u_Encoder (
    .reset                   ( reset                     ),
    .clk                     ( clk                       ),
    .start                   ( start                     ),

    .code            ( code              ),
    .done                    ( done                      ),
    .error                   ( error                     ),
    .primeter                ( primeter           [7:0]  ),
    .area                    ( area               [11:0] ),
    .start_row       ( start_row         ),
    .start_col       ( start_col         )
);

always #50 clk = ~clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb_Encoder);
end

initial
begin
    reset = 1;
    clk = 0;
    #100
    reset = 0;
    start = 1;
    #1000000;
    $finish;
end

endmodule