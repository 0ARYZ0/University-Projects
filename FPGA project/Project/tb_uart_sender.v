`timescale  1ns / 1ps     

module tb_UART_sender;    

// UART_sender Parameters 
parameter RESET      = 0; 
parameter IDLE       = 1; 
parameter START_BIT  = 2; 
parameter DATA_BITS  = 3;
parameter STOP_BIT   = 4;
parameter CLEAN_UP   = 5;

// UART_sender Inputs
reg   clk                                  = 0 ;
reg   start                                = 0 ;
reg   [7:0]  data_in                       = 0 ;

// UART_sender Outputs
wire  tx                                   ;
wire  done                                 ;
wire  busy                                 ;


UART_sender #(
    .RESET     ( RESET     ),
    .IDLE      ( IDLE      ),
    .START_BIT ( START_BIT ),
    .DATA_BITS ( DATA_BITS ),
    .STOP_BIT  ( STOP_BIT  ),
    .CLEAN_UP  ( CLEAN_UP  ))
 u_UART_sender (
    .clk                     ( clk            ),
    .start                   ( start          ),
    .data_in                 ( data_in  [7:0] ),

    .tx                      ( tx             ),
    .done                    ( done           ),
    .busy                    ( busy           )
);


always #50 clk = ~clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb_UART_sender);
end

initial
begin
    clk = 0;
    data_in = 8'b01111111;
    #100;
    start = 1;
    #10000;
    $finish;
end

endmodule