`timescale 1ns/1ps

module tb_UART (
    output [7:0] out,
    output done
);
reg clk;



reg start_sender;
reg [7:0]data_in_sender;


UART_sender #(
    .RESET     ( 0 ),
    .IDLE      ( 1 ),
    .START_BIT ( 2 ),
    .DATA_BITS ( 3 ),
    .STOP_BIT  ( 4 ),
    .CLEAN_UP  ( 5 ))
 u_UART_sender (
    .clk                     ( clk       ),
    .start                   ( start_sender     ),
    .data_in                 ( data_in_sender ),

    .tx                      ( tx_input_serial ),
    .done                    (  ),
    .busy                    ( busy )
);

wire tx_input_serial;
wire [7:0]out_receiver;

UART_receiver #(
    .IDLE      ( 0 ),
    .START_BIT ( 1 ),
    .DATA_BITS ( 2 ),
    .STOP_BIT  ( 3 ),
    .CLEANUP   ( 4 ))
 u_UART_receiver (
    .clk                     ( clk          ),
    .input_serial            ( tx_input_serial ),

    .done                    ( done           ),
    .output_Byte             ( out_receiver    )
);

assign out = out_receiver;

always #50 clk = ~clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb_UART);
end

initial
begin
    clk = 0;
    
    #200;
    data_in_sender = 8'b01111111;
    start_sender = 1;
    #100;
    start_sender = 0;
    #2000;
    data_in_sender =8'b11001100;
    start_sender = 1;
    #100;
    start_sender = 0;
    #100000;
    $finish;
end
endmodule