`timescale 1ns/1ps

module Encoder (
    input reset,
    input clk,
    input start,
    input sender_done,

    output reg ready_to_send,
    output reg[7:0]code,
    output reg done,
    output reg error,
    output reg [7:0]primeter,
    output reg [11:0]area,
    output [6:0]start_row,
    output [6:0]start_col
);
    assign start_row = reg_start_row;
    assign start_col = reg_start_col;
    reg [0:63] ram [63:0];
    reg [1023:0] border;
    reg [9:0] index_border;
    reg update_index_border = 0;
    reg [9:0] index_send;
    reg update_index_send = 0;

    parameter s1 = 0;
    parameter s2 = 1;
    parameter s3 = 2;
    parameter s4 = 3;
    parameter s5 = 4;
    parameter s6 = 5;

    reg [2:0] state;
    reg [5:0] row;
    reg [5:0] col;
    reg [5:0] reg_start_row;
    reg [5:0] reg_start_col;
    reg [11:0] black_number = 0;
    

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= s1;
            row <= 0;
            col <= 0;
            reg_start_col <= 0;
            reg_start_row <= 0;
            primeter <= 0;
            area <= 0;
            index_border <= 0;
            index_send <= 0;
            ready_to_send <= 0;
        end
        else begin
            case (state)
                s1:begin
                    $readmemb("data.txt", ram, 0, 63);
                    if (start) begin
                        state <= s2;
                    end
                end
                s2:begin
                    if(ram[row][col] == 1) begin
                        state <= s3;
                        reg_start_row <= row;
                        reg_start_col <= col;
                    end
                    else begin
                        if(col < 63)begin
                            col <= col + 1;
                        end
                        else if(row < 63) begin
                            col <= 0;
                            row <= row + 1;
                        end
                        else begin
                            error <= 1;
                        end
                    end
                end
                s3:begin
                    if ((row == reg_start_row) && (col == reg_start_col) && (primeter != 0)) begin
                        state <= s4;
                        row <= 0;
                        col <= 0;
                    end
                    else if ((ram[row][col + 1] == 1) && (ram[row - 1][col + 1] == 0))begin
                        col <= col + 1;
                        border[index_border] <= 0;
                        border[index_border + 1] <= 0;
                        border[index_border + 2] <= 0;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end
                    else if ((ram[row - 1][col + 1] == 1) && (ram[row - 1][col] == 0))begin
                        col <= col + 1;
                        row <= row - 1;
                        border[index_border] <= 1;
                        border[index_border + 1] <= 0;
                        border[index_border + 2] <= 0;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end
                    else if ((ram[row - 1][col] == 1) && (ram[row - 1][col - 1] == 0)) begin
                        row <= row - 1;
                        border[index_border] <= 0;
                        border[index_border + 1] <= 1;
                        border[index_border + 2] <= 0;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end
                    else if ((ram[row - 1][col - 1] == 1) && (ram[row][col - 1] == 0)) begin
                        row <= row - 1;
                        col <= col - 1;
                        border[index_border] <= 1;
                        border[index_border + 1] <= 1;
                        border[index_border + 2] <= 0;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end
                    else if ((ram[row][col - 1] == 1) && (ram[row + 1][col - 1] == 0)) begin
                        col <= col - 1;
                        border[index_border] <= 0;
                        border[index_border + 1] <= 0;
                        border[index_border + 2] <= 1;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end
                    else if ((ram[row + 1][col - 1] == 1) && (ram[row + 1][col] == 0)) begin
                        row <= row + 1;
                        col <= col - 1;
                        border[index_border] <= 1;
                        border[index_border + 1] <= 0;
                        border[index_border + 2] <= 1;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end
                    else if ((ram[row + 1][col] == 1) && (ram[row + 1][col + 1] == 0)) begin
                        row <= row + 1;
                        border[index_border] <= 0;
                        border[index_border + 1] <= 1;
                        border[index_border + 2] <= 1;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end
                    else if ((ram[row + 1][col + 1] == 1) && (ram[row][col + 1] == 0)) begin
                        row <= row + 1;
                        col <= col + 1;
                        border[index_border] <= 1;
                        border[index_border + 1] <= 1;
                        border[index_border + 2] <= 1;
                        border[index_border + 3] <= 0;
                        border[index_border + 4] <= 0;
                        border[index_border + 5] <= 0;
                        border[index_border + 6] <= 0;
                        border[index_border + 7] <= 0;
                        update_index_border <= ~update_index_border;
                        primeter <= primeter + 1;
                    end 
                end
                s4:begin 
                    if(ram[row][col] == 1)begin
                        black_number <= black_number + 1;
                    end
                    if(col < 63)begin
                        col <= col + 1;
                    end
                    else if(row < 63) begin
                        col <= 0;
                        row <= row + 1;
                    end
                    else begin
                        area <= black_number;
                        state <= s5;
                        index_send <= 8;
                    end
                end
                s5:begin
                    ready_to_send <= 0;
                    if(index_send < index_border)begin
                        code[0] <= border[index_send];
                        code[1] <= border[index_send + 1];
                        code[2] <= border[index_send + 2];
                        code[3] <= border[index_send + 3];
                        code[4] <= border[index_send + 4];
                        code[5] <= border[index_send + 5];
                        code[6] <= border[index_send + 6];
                        code[7] <= border[index_send + 7];
                        update_index_send <= ~update_index_send;
                        state <= s6;
                    end
                    else begin
                        done <= 1;
                    end
                end
                s6:begin
                    ready_to_send <= 1;
                    if(sender_done == 1)begin
                        state = s5;
                    end
                end
                default:$display("FSM Unknown State");
            endcase
        end
    end

    always @(update_index_border) begin
        index_border <= index_border + 8;
    end 
    always @(update_index_send) begin
        index_send <= index_send + 8;
    end

endmodule