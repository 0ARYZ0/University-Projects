`timescale  1ns / 1ps    

module tb_Decoder;       

// Decoder Parameters    
parameter s1  = 2'b00;   
parameter s2  = 2'b01;   
parameter s3  = 2'b10;   
parameter s4  = 2'b11;

// Decoder Inputs
reg   [2:0]  code                          = 0 ;
reg   reset                                = 0 ;
reg   clk                                  = 0 ;
reg   start                                = 0 ;
reg   [7:0]  primeter                      = 0 ;
reg   [11:0]  area                         = 0 ;
reg   [6:0]  start_row                     = 0 ;
reg   [6:0]  start_col                     = 0 ;

// Decoder Outputs
wire  [63:0]  debug1                       ;
wire  [63:0]  debug2                       ;
wire  [63:0]  debug3                       ;
wire  [63:0]  debug4                       ;
wire  [63:0]  debug5                       ;
wire  [63:0]  debug6                       ;
wire  pixel                                ;
wire  done                                 ;
wire  error                                ;


Decoder #(
    .s1 ( s1 ),
    .s2 ( s2 ),
    .s3 ( s3 ),
    .s4 ( s4 ))
 u_Decoder (
    .code                    ( code       [2:0]  ),
    .reset                   ( reset             ),
    .clk                     ( clk               ),
    .start                   ( start             ),
    .primeter                ( primeter   [7:0]  ),
    .area                    ( area       [11:0] ),
    .start_row               ( start_row  [6:0]  ),
    .start_col               ( start_col  [6:0]  ),

    .debug1                  ( debug1     [63:0] ),
    .debug2                  ( debug2     [63:0] ),
    .debug3                  ( debug3     [63:0] ),
    .debug4                  ( debug4     [63:0] ),
    .debug5                  ( debug5     [63:0] ),
    .debug6                  ( debug6     [63:0] ),
    .pixel                   ( pixel             ),
    .done                    ( done              ),
    .error                   ( error             )
);

always #50 clk = ~clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb_Decoder);
end

initial
begin
    reset = 1;
    start_row = 10;
    start_col = 10;
    clk = 0;
    #100
    reset = 0;
    start = 1;
    #800000;
    $finish;
end

endmodule