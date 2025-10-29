`timescale 1ns/1ps

module Decoder (
    input [7:0]code,
    input reset,
    input clk,
    input start,
    input [7:0]primeter,
    input [11:0]area,
    input [6:0]start_row,
    input [6:0]start_col,
    input done_receiver,

    output reg done,
    output reg error,
    output reg[63:0]debug0,
    output reg[63:0]debug1,
    output reg[63:0]debug2,
    output reg[63:0]debug3,
    output reg[63:0]debug4,
    output reg[63:0]debug5,
    output reg[63:0]debug6,
    output reg[63:0]debug7,
    output reg[63:0]debug8,
    output reg[63:0]debug9,
    output reg[63:0]debug10,
    output reg[63:0]debug11,
    output reg[63:0]debug12,
    output reg[63:0]debug13,
    output reg[63:0]debug14,
    output reg[63:0]debug15,
    output reg[63:0]debug16,
    output reg[63:0]debug17,
    output reg[63:0]debug18,
    output reg[63:0]debug19,
    output reg[63:0]debug20,
    output reg[63:0]debug21,
    output reg[63:0]debug22,
    output reg[63:0]debug23,
    output reg[63:0]debug24,
    output reg[63:0]debug25,
    output reg[63:0]debug26,
    output reg[63:0]debug27,
    output reg[63:0]debug28,
    output reg[63:0]debug29,
    output reg[63:0]debug30,
    output reg[63:0]debug31,
    output reg[63:0]debug32,
    output reg[63:0]debug33,
    output reg[63:0]debug34,
    output reg[63:0]debug35,
    output reg[63:0]debug36,
    output reg[63:0]debug37,
    output reg[63:0]debug38,
    output reg[63:0]debug39,
    output reg[63:0]debug40,
    output reg[63:0]debug41,
    output reg[63:0]debug42,
    output reg[63:0]debug43,
    output reg[63:0]debug44,
    output reg[63:0]debug45,
    output reg[63:0]debug46,
    output reg[63:0]debug47,
    output reg[63:0]debug48,
    output reg[63:0]debug49,
    output reg[63:0]debug50,
    output reg[63:0]debug51,
    output reg[63:0]debug52,
    output reg[63:0]debug53,
    output reg[63:0]debug54,
    output reg[63:0]debug55,
    output reg[63:0]debug56,
    output reg[63:0]debug57,
    output reg[63:0]debug58,
    output reg[63:0]debug59,
    output reg[63:0]debug60,
    output reg[63:0]debug61,
    output reg[63:0]debug62,
    output reg[63:0]debug63
);

    parameter s1 = 2'b00;
    parameter s2 = 2'b01;
    parameter s3 = 2'b10;
    parameter s4 = 2'b11;

    reg [0:63] ram [63:0];
    reg [1023:0] border;
    reg [9:0] index_border;

    reg [5:0] reg_start_row;
    reg [5:0] reg_start_col;
    reg [1:0] state;
    reg [5:0] row;
    reg [5:0] col;
    reg paint;
    reg [7:0]recived_primeter;
    reg [11:0]recived_area;
    reg [3:0]should_start;
    reg [7:0]calculated_primeter;

    reg update_index_border8 = 0;
    reg update_index_border3 = 0;

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0;i < 64 ;i = i + 1) begin
                ram[i] = 0;
            end
            done <= 0;
            error <= 0;
            state <= s1;
            row <= 0;
            col <= 0;
            index_border <= 0;
            recived_primeter <= 0;
            recived_area <= 0;
            calculated_primeter <= 0;
        end
        else begin
            case (state)
                s1:begin
                    if(start)begin
                        row <= start_row;
                        col <= start_col;
                        recived_primeter <= primeter;
                        recived_area <= area;
                        should_start <= 0;
                        state <= s2;
                    end
                    else if (done_receiver == 1) begin
                        border[index_border] <= code[0];
                        border[index_border + 1] <= code[1];
                        border[index_border + 2] <= code[2];
                        border[index_border + 3] <= code[3];
                        border[index_border + 4] <= code[4];
                        border[index_border + 5] <= code[5];
                        border[index_border + 6] <= code[6];
                        border[index_border + 7] <= code[7];
                        update_index_border8 <= ~update_index_border8;
                    end
                end
                s2:begin
                    if (should_start > 14) begin
                        state <= s3;
                        index_border <= 0;
                    end
                    else if(done_receiver == 1)begin
                        border[index_border] <= code[0];
                        border[index_border + 1] <= code[1];
                        border[index_border + 2] <= code[2];
                        border[index_border + 3] <= code[3];
                        border[index_border + 4] <= code[4];
                        border[index_border + 5] <= code[5];
                        border[index_border + 6] <= code[6];
                        border[index_border + 7] <= code[7];
                        update_index_border8 <= ~update_index_border8;
                        should_start <= 0;
                    end
                    else begin
                        should_start <= should_start + 1;
                    end
                end
 
                s3:begin
                    if (ram[row][col] == 1) begin
                        row <= 0;
                        col <= 0;
                        paint <= 0;
                        state <= s4;
                    end
                    else if (border[index_border + 2] == 0 && border[index_border + 1]== 0 && border[index_border] == 0) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        col = col + 1;
                        calculated_primeter = calculated_primeter + 1;
                        //debug0 <= 0;
                    end
                    else if ({border[index_border + 2], border[index_border + 1], border[index_border]} == 1) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        row = row - 1;
                        col = col + 1;
                        calculated_primeter = calculated_primeter + 1;
                        //debug1 <= 0;
                    end
                    else if ({border[index_border + 2], border[index_border + 1], border[index_border]} == 2) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        row = row - 1;
                        calculated_primeter = calculated_primeter + 1;
                        //debug2 <= 0;
                    end
                    else if ({border[index_border + 2], border[index_border + 1], border[index_border]} == 3) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        row = row - 1;
                        col = col - 1;
                        calculated_primeter = calculated_primeter + 1;
                        //debug3 <= 0;
                    end
                    else if ({border[index_border + 2], border[index_border + 1], border[index_border]} == 4) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        col = col - 1;
                        calculated_primeter = calculated_primeter + 1;
                        //debug4 <= 0;
                    end
                    else if ({border[index_border + 2], border[index_border + 1], border[index_border]} == 5) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        row = row + 1;
                        col = col - 1;
                        calculated_primeter = calculated_primeter + 1;
                      //  debug5 <= 0;
                    end
                    else if ({border[index_border + 2], border[index_border + 1], border[index_border]} == 6) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        row = row + 1;
                        calculated_primeter = calculated_primeter + 1;
                       // debug6 <= 0;
                    end
                    else if ({border[index_border + 2], border[index_border + 1], border[index_border]} == 7) begin
                        update_index_border3 <= ~update_index_border3;
                        ram[row][col] = 1;
                        row = row + 1;
                        col = col + 1;
                        calculated_primeter = calculated_primeter + 1;
                        //debug7 <= 0;
                    end
                    
                end
                s4:begin
                    if (calculated_primeter != recived_primeter) begin
                        error <= 1;
                    end


                    debug0 <= ram[0];
                    debug1 <= ram[1];
                    debug2 <= ram[2];
                    debug3 <= ram[3];
                    debug4 <= ram[4];
                    debug5 <= ram[5];
                    debug6 <= ram[6];
                    debug7 <= ram[7];
                    debug8 <= ram[8];
                    debug9 <= ram[9];
                    debug10 <= ram[10];
                    debug11 <= ram[11];
                    debug12 <= ram[12];
                    debug13 <= ram[13];
                    debug14 <= ram[14];
                    debug15 <= ram[15];
                    debug16 <= ram[16];
                    debug17 <= ram[17];
                    debug18 <= ram[18];
                    debug19 <= ram[19];
                    debug20 <= ram[20];
                    debug21 <= ram[21];
                    debug22 <= ram[22];
                    debug23 <= ram[23];
                    debug24 <= ram[24];
                    debug25 <= ram[25];
                    debug26 <= ram[26];
                    debug27 <= ram[27];
                    debug28 <= ram[28];
                    debug29 <= ram[29];
                    debug30 <= ram[30];
                    debug31 <= ram[31];
                    debug32 <= ram[32];
                    debug33 <= ram[33];
                    debug34 <= ram[34];
                    debug35 <= ram[35];
                    debug36 <= ram[36];
                    debug37 <= ram[37];
                    debug38 <= ram[38];
                    debug39 <= ram[39];
                    debug40 <= ram[40];
                    debug41 <= ram[41];
                    debug42 <= ram[42];
                    debug43 <= ram[43];
                    debug44 <= ram[44];
                    debug45 <= ram[45];
                    debug46 <= ram[46];
                    debug47 <= ram[47];
                    debug48 <= ram[48];
                    debug49 <= ram[49];
                    debug50 <= ram[50];
                    debug51 <= ram[51];
                    debug52 <= ram[52];
                    debug53 <= ram[53];
                    debug54 <= ram[54];
                    debug55 <= ram[55];
                    debug56 <= ram[56];
                    debug57 <= ram[57];
                    debug58 <= ram[58];
                    debug59 <= ram[59];
                    debug60 <= ram[60];
                    debug61 <= ram[61];
                    debug62 <= ram[62];
                    debug63 <= ram[63];
                end

                default:$display("FSM Unknown State");
            endcase
        end
         
    end

    always @(update_index_border8) begin
        index_border <= index_border + 8;
    end
    always @(update_index_border3) begin
        index_border <= index_border + 8;
    end

endmodule