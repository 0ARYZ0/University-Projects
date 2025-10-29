`timescale 1ns/1ps

module UART_receiver
    #(parameter CLKS_PER_BIT = 1)
  (
   input  clk,
   input  input_serial,

   output done,
   output [7:0] output_Byte
   );
    
  parameter IDLE = 0;
  parameter START_BIT = 1;
  parameter DATA_BITS = 2;
  parameter STOP_BIT = 3;
  parameter CLEANUP = 4;
   
  reg r_Rx_Data_R = 1'b1;
  reg reg_input_data = 1'b1;
   
  reg [7:0] clk_count = 0;
  reg [2:0] bit_index  = 0; 
  reg [7:0] total_byte;
  reg reg_done = 0;
  reg [2:0] state = 0;
   
  always @(posedge clk)
    begin
      reg_input_data <= input_serial;
    end
   
   
    always @(posedge clk)begin
        case (state)
            IDLE :begin
                reg_done <= 0;
                clk_count <= 0;
                bit_index <= 0;
                
                if (reg_input_data == 0)          
                    //state <= START_BIT;
                    state <= DATA_BITS;
                else
                    state <= IDLE;
                //state <= START_BIT;
            end
            
            START_BIT :begin
                if (clk_count < (CLKS_PER_BIT-1))begin
                    if (reg_input_data == 0)begin
                        clk_count <= clk_count + 1;  
                        state <= START_BIT;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                else begin
                    clk_count <= 0;
                    state <= DATA_BITS;
                end
            
            // if (reg_input_data == 0)begin
            //             //clk_count <= 0;  // reset counter, found the middle
            //             state <= DATA_BITS;
            //         end
            end 
            
            
            DATA_BITS :begin
                if (clk_count < CLKS_PER_BIT-1)begin
                    clk_count <= clk_count + 1;
                    state <= DATA_BITS;
                end
                else begin
                    clk_count <= 0;
                    total_byte[bit_index] <= reg_input_data;
                    if (bit_index < 7)begin
                        bit_index <= bit_index + 1;
                        state   <= DATA_BITS;
                    end
                    else begin
                        bit_index <= 0;
                        state   <= STOP_BIT;
                    end
                end
            end 
        
            STOP_BIT :begin
                if (clk_count < CLKS_PER_BIT-1)begin
                    clk_count <= clk_count + 1;
                    state <= STOP_BIT;
                end
                else begin
                    reg_done <= 1;
                    clk_count <= 0;
                    state <= CLEANUP;
                end
            end 
        
            
            CLEANUP :begin
                reg_done <= 0;
                state <= IDLE; 
            end
            default: state <= IDLE;
            
        endcase
    end   
   
  assign done  = reg_done;
  assign output_Byte = total_byte;
   
endmodule