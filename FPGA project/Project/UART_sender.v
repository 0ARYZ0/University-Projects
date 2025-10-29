`timescale 1ns/1ps
 
module UART_sender 
    #(parameter CLKS_PER_BIT = 1)
(
    input clk,        
    input start,     
    input [7:0]data_in,    
    
    output reg tx,    
    output reg done  
);
    reg [2:0] state  = RESET;
    reg [7:0] data   = 8'b0; 
    reg [2:0] bitIdx = 3'b0; 
    reg [2:0] clk_count;

    parameter RESET = 0;
    parameter IDLE = 1;  
    parameter START_BIT = 2;
    parameter DATA_BITS = 3;   
    parameter STOP_BIT = 4;  
    parameter CLEAN_UP = 5;  

    always @(posedge clk) begin
        case (state)
            default : begin
                state <= IDLE;
            end
            IDLE : begin
                tx <= 1; 
                done <= 0;
                bitIdx <= 0;
                data <= 0;
                clk_count <= 0;
                if (start) begin
                    data <= data_in; 
                    state <= START_BIT;
                end
            end
            START_BIT : begin
                tx <= 0; 
                if(clk_count < CLKS_PER_BIT - 1)begin
                    clk_count <= clk_count + 1;
                    state <= START_BIT;
                end
                else begin
                    clk_count <= 0;
                    state <= DATA_BITS;
                end
            end
            DATA_BITS : begin 
                tx <= data[bitIdx];
                if(clk_count < CLKS_PER_BIT - 1)begin
                    clk_count <= clk_count + 1;
                    state <= DATA_BITS;
                end
                else begin
                    clk_count <= 0;
                    if (bitIdx < 7) begin
                        bitIdx  <= bitIdx + 1;
                    end else begin
                        bitIdx  <= 0;
                        state <= STOP_BIT;
                    end
                end
                
            end
            STOP_BIT : begin 
                tx <= 1;
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                    state <= STOP_BIT;
                end
                else begin
                    clk_count <= 0;
                    data <= 0;
                    state <= CLEAN_UP; 
                end
            end
            CLEAN_UP:begin
                done <= 1;
                state <= IDLE;
            end
        endcase
    end

endmodule