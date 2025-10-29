`timescale  1ns / 1ps      

module tb_UART_receiver;   

// UART_receiver Parameters 
parameter IDLE       = 0;  
parameter START_BIT  = 1;  
parameter DATA_BITS  = 2;  
parameter STOP_BIT   = 3;
parameter CLEANUP    = 4;

// UART_receiver Inputs
reg   clk                                  = 0 ;
reg   input_serial                         = 0 ;
reg   _serial                              = 0 ;

// UART_receiver Outputs
wire  done                                 ;
wire  [7:0]  output_Byte                   ;
wire  _Byte                                ;


UART_receiver #(
    .IDLE      ( IDLE      ),
    .START_BIT ( START_BIT ),
    .DATA_BITS ( DATA_BITS ),
    .STOP_BIT  ( STOP_BIT  ),
    .CLEANUP   ( CLEANUP   ))
 u_UART_receiver (
    .clk                     ( clk                 ),
    .input_serial            ( input_serial        ),

    .done                    ( done                ),
    .output_Byte             ( output_Byte   [7:0] )
);

always #50 clk = ~clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb_UART_receiver);
end

initial
begin
    clk = 0;
    input_serial = 1;
    #200;
    input_serial = 0;
    #100;
    input_serial = 1;
    #100;
    input_serial = 1;
    #100;
    input_serial = 1;
    #100;
    input_serial = 1;
    #100;
    input_serial = 1;
    #100;
    input_serial = 1;
    #100;
    input_serial = 1;
    #100;
    input_serial = 0;
    #100;
    input_serial = 1;
    #1000;
    $finish;
end

endmodule