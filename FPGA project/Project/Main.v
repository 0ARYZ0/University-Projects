`timescale 1ns/1ps
`include "Encoder.v"
`include "Decoder.v"
`include "UART_receiver.v"
`include "UART_sender.v"

module Main (
);


reg reset;
reg clk;
reg start_encoder;

wire done_encoder_sender;
wire ready_to_send;
wire [7:0]data_encoder_sender;
wire done_encoder_decoder;
wire [7:0] primeter_encoder_decoder;
wire [11:0] area_encoder_decoder;
wire [6:0] start_row_encoder_decoder;
wire [6:0] start_col_encoder_decoder;


Encoder #(
    .s1 ( 0 ),
    .s2 ( 1 ),
    .s3 ( 2 ),
    .s4 ( 3 ),
    .s5 ( 4 ),
    .s6 ( 5 ))
 u_Encoder (
    .reset                   ( reset ),
    .clk                     ( clk ),
    .start                   ( start_encoder ),
    .sender_done             ( done_encoder_sender ),

    .ready_to_send           ( ready_to_send ),
    .code                    ( data_encoder_sender ),
    .done                    ( done_encoder_decoder ),
    .error                   (),
    .primeter                ( primeter_encoder_decoder ),
    .area                    ( area_encoder_decoder ),
    .start_row               ( start_row_encoder_decoder ),
    .start_col               ( start_col_encoder_decoder )
);

wire data_sender_receiver;

UART_sender #(
    .RESET     ( 0 ),
    .IDLE      ( 1 ),
    .START_BIT ( 2 ),
    .DATA_BITS ( 3 ),
    .STOP_BIT  ( 4 ),
    .CLEAN_UP  ( 5 ))
 u_UART_sender (
    .clk                     ( clk ),
    .start                   ( ready_to_send ),
    .data_in                 ( data_encoder_sender ),

    .tx                      ( data_sender_receiver ),
    .done                    ( done_encoder_sender ),
    .busy                    ( busy      )
);

wire done_receiver_decoder;
wire [7:0] data_receiver_decoder;

UART_receiver #(
    .IDLE      ( 0 ),
    .START_BIT ( 1 ),
    .DATA_BITS ( 2 ),
    .STOP_BIT  ( 3 ),
    .CLEANUP   ( 4 ))
 u_UART_receiver (
    .clk                     ( clk ),
    .input_serial            ( data_sender_receiver ),

    .done                    ( done_receiver_decoder ),
    .output_Byte             ( data_receiver_decoder )
);

wire done_decoder;

Decoder #(
    .s1 ( 2'b00 ),
    .s2 ( 2'b01 ),
    .s3 ( 2'b10 ),
    .s4 ( 2'b11 ))
 u_Decoder (
    .code                    ( data_receiver_decoder ),
    .reset                   ( reset ),
    .clk                     ( clk ),
    .start                   ( done_encoder_decoder ),
    .primeter                ( primeter_encoder_decoder ),
    .area                    ( area_encoder_decoder ),
    .start_row               ( start_row_encoder_decoder ),
    .start_col               ( start_col_encoder_decoder ),
    .done_receiver           ( done_receiver_decoder ),

    .done                    ( done_decoder ),
    .error                   ( ),
    .debug0         ( debug0    ),
    .debug1         ( debug1    ),
    .debug2         ( debug2    ),
    .debug3         ( debug3    ),
    .debug4         ( debug4    ),
    .debug5         ( debug5    ),
    .debug6         ( debug6    ),
    .debug7         ( debug7    ),
    .debug8         ( debug8    ),
    .debug9         ( debug9    ),
    .debug10        ( debug10   ),
    .debug11        ( debug11   ),
    .debug12        ( debug12   ),
    .debug13        ( debug13   ),
    .debug14        ( debug14   ),
    .debug15        ( debug15   ),
    .debug16        ( debug16   ),
    .debug17        ( debug17   ),
    .debug18        ( debug18   ),
    .debug19        ( debug19   ),
    .debug20        ( debug20   ),
    .debug21        ( debug21   ),
    .debug22        ( debug22   ),
    .debug23        ( debug23   ),
    .debug24        ( debug24   ),
    .debug25        ( debug25   ),
    .debug26        ( debug26   ),
    .debug27        ( debug27   ),
    .debug28        ( debug28   ),
    .debug29        ( debug29   ),
    .debug30        ( debug30   ),
    .debug31        ( debug31   ),
    .debug32        ( debug32   ),
    .debug33        ( debug33   ),
    .debug34        ( debug34   ),
    .debug35        ( debug35   ),
    .debug36        ( debug36   ),
    .debug37        ( debug37   ),
    .debug38        ( debug38   ),
    .debug39        ( debug39   ),
    .debug40        ( debug40   ),
    .debug41        ( debug41   ),
    .debug42        ( debug42   ),
    .debug43        ( debug43   ),
    .debug44        ( debug44   ),
    .debug45        ( debug45   ),
    .debug46        ( debug46   ),
    .debug47        ( debug47   ),
    .debug48        ( debug48   ),
    .debug49        ( debug49   ),
    .debug50        ( debug50   ),
    .debug51        ( debug51   ),
    .debug52        ( debug52   ),
    .debug53        ( debug53   ),
    .debug54        ( debug54   ),
    .debug55        ( debug55   ),
    .debug56        ( debug56   ),
    .debug57        ( debug57   ),
    .debug58        ( debug58   ),
    .debug59        ( debug59   ),
    .debug60        ( debug60   ),
    .debug61        ( debug61   ),
    .debug62        ( debug62   ),
    .debug63        ( debug63   )
);

always #50 clk = ~clk;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,Main);
end

initial begin
    clk = 0;
    reset = 1;
    
    #300;
    reset = 0;
    start_encoder = 1;

    #2000000;
    $finish;
end

endmodule