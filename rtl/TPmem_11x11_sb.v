module TPmem_11x11_sb #( parameter BW = 11 )
(  input      [11*BW-1:0] i_data,
   input                  i_enable,
   input                  i_clk,
   input                  i_Reset,
   output reg [11*BW-1:0] o_data,
   output reg             o_en
);

    reg  [4:0]        cnt;
    reg  [11*BW-1:0]  array [0:10];
    reg  [11*BW-1:0]  data_out;
    wire [11*BW-1:0]  col   [0:10];
    wire [3:0] index = cnt[3:0];
    wire       phase = cnt[4];

    always @(posedge i_clk or negedge i_Reset) begin
        if (!i_Reset)                     cnt <= 5'd0;
        else if (i_enable || cnt != 5'd0) cnt <= cnt + 5'd1;
    end

    assign col[ 0] = { array[10][0*BW+:BW], array[9][0*BW+:BW], array[8][0*BW+:BW], array[7][0*BW+:BW], array[6][0*BW+:BW], array[5][0*BW+:BW], array[4][0*BW+:BW], array[3][0*BW+:BW], array[2][0*BW+:BW], array[1][0*BW+:BW], array[0][0*BW+:BW] };
    assign col[ 1] = { array[10][1*BW+:BW], array[9][1*BW+:BW], array[8][1*BW+:BW], array[7][1*BW+:BW], array[6][1*BW+:BW], array[5][1*BW+:BW], array[4][1*BW+:BW], array[3][1*BW+:BW], array[2][1*BW+:BW], array[1][1*BW+:BW], array[0][1*BW+:BW] };
    assign col[ 2] = { array[10][2*BW+:BW], array[9][2*BW+:BW], array[8][2*BW+:BW], array[7][2*BW+:BW], array[6][2*BW+:BW], array[5][2*BW+:BW], array[4][2*BW+:BW], array[3][2*BW+:BW], array[2][2*BW+:BW], array[1][2*BW+:BW], array[0][2*BW+:BW] };
    assign col[ 3] = { array[10][3*BW+:BW], array[9][3*BW+:BW], array[8][3*BW+:BW], array[7][3*BW+:BW], array[6][3*BW+:BW], array[5][3*BW+:BW], array[4][3*BW+:BW], array[3][3*BW+:BW], array[2][3*BW+:BW], array[1][3*BW+:BW], array[0][3*BW+:BW] };
    assign col[ 4] = { array[10][4*BW+:BW], array[9][4*BW+:BW], array[8][4*BW+:BW], array[7][4*BW+:BW], array[6][4*BW+:BW], array[5][4*BW+:BW], array[4][4*BW+:BW], array[3][4*BW+:BW], array[2][4*BW+:BW], array[1][4*BW+:BW], array[0][4*BW+:BW] };
    assign col[ 5] = { array[10][5*BW+:BW], array[9][5*BW+:BW], array[8][5*BW+:BW], array[7][5*BW+:BW], array[6][5*BW+:BW], array[5][5*BW+:BW], array[4][5*BW+:BW], array[3][5*BW+:BW], array[2][5*BW+:BW], array[1][5*BW+:BW], array[0][5*BW+:BW] };
    assign col[ 6] = { array[10][6*BW+:BW], array[9][6*BW+:BW], array[8][6*BW+:BW], array[7][6*BW+:BW], array[6][6*BW+:BW], array[5][6*BW+:BW], array[4][6*BW+:BW], array[3][6*BW+:BW], array[2][6*BW+:BW], array[1][6*BW+:BW], array[0][6*BW+:BW] };
    assign col[ 7] = { array[10][7*BW+:BW], array[9][7*BW+:BW], array[8][7*BW+:BW], array[7][7*BW+:BW], array[6][7*BW+:BW], array[5][7*BW+:BW], array[4][7*BW+:BW], array[3][7*BW+:BW], array[2][7*BW+:BW], array[1][7*BW+:BW], array[0][7*BW+:BW] };
    assign col[ 8] = { array[10][8*BW+:BW], array[9][8*BW+:BW], array[8][8*BW+:BW], array[7][8*BW+:BW], array[6][8*BW+:BW], array[5][8*BW+:BW], array[4][8*BW+:BW], array[3][8*BW+:BW], array[2][8*BW+:BW], array[1][8*BW+:BW], array[0][8*BW+:BW] };
    assign col[ 9] = { array[10][9*BW+:BW], array[9][9*BW+:BW], array[8][9*BW+:BW], array[7][9*BW+:BW], array[6][9*BW+:BW], array[5][9*BW+:BW], array[4][9*BW+:BW], array[3][9*BW+:BW], array[2][9*BW+:BW], array[1][9*BW+:BW], array[0][9*BW+:BW] };
    assign col[10] = { array[10][10*BW+:BW], array[9][10*BW+:BW], array[8][10*BW+:BW], array[7][10*BW+:BW], array[6][10*BW+:BW], array[5][10*BW+:BW], array[4][10*BW+:BW], array[3][10*BW+:BW], array[2][10*BW+:BW], array[1][10*BW+:BW], array[0][10*BW+:BW] };

    always @(*) begin
        if (index >= 4'd11)  data_out = {11*BW{1'b0}};   // idle/high-freq
        else if (!phase)     data_out = array[index];      // row read
        else                 data_out = col[index];        // col read
    end

    always @(posedge i_clk) begin
        if (index < 4'd11) begin
            if (!phase) array[index] <= i_data;          // row write
            else case (index)                            // col write
                4'd0 : begin array[0][0*BW+:BW] <= i_data[0*BW+:BW]; array[1][0*BW+:BW] <= i_data[1*BW+:BW]; array[2][0*BW+:BW] <= i_data[2*BW+:BW]; array[3][0*BW+:BW] <= i_data[3*BW+:BW]; array[4][0*BW+:BW] <= i_data[4*BW+:BW]; array[5][0*BW+:BW] <= i_data[5*BW+:BW]; array[6][0*BW+:BW] <= i_data[6*BW+:BW]; array[7][0*BW+:BW] <= i_data[7*BW+:BW]; array[8][0*BW+:BW] <= i_data[8*BW+:BW]; array[9][0*BW+:BW] <= i_data[9*BW+:BW]; array[10][0*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd1 : begin array[0][1*BW+:BW] <= i_data[0*BW+:BW]; array[1][1*BW+:BW] <= i_data[1*BW+:BW]; array[2][1*BW+:BW] <= i_data[2*BW+:BW]; array[3][1*BW+:BW] <= i_data[3*BW+:BW]; array[4][1*BW+:BW] <= i_data[4*BW+:BW]; array[5][1*BW+:BW] <= i_data[5*BW+:BW]; array[6][1*BW+:BW] <= i_data[6*BW+:BW]; array[7][1*BW+:BW] <= i_data[7*BW+:BW]; array[8][1*BW+:BW] <= i_data[8*BW+:BW]; array[9][1*BW+:BW] <= i_data[9*BW+:BW]; array[10][1*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd2 : begin array[0][2*BW+:BW] <= i_data[0*BW+:BW]; array[1][2*BW+:BW] <= i_data[1*BW+:BW]; array[2][2*BW+:BW] <= i_data[2*BW+:BW]; array[3][2*BW+:BW] <= i_data[3*BW+:BW]; array[4][2*BW+:BW] <= i_data[4*BW+:BW]; array[5][2*BW+:BW] <= i_data[5*BW+:BW]; array[6][2*BW+:BW] <= i_data[6*BW+:BW]; array[7][2*BW+:BW] <= i_data[7*BW+:BW]; array[8][2*BW+:BW] <= i_data[8*BW+:BW]; array[9][2*BW+:BW] <= i_data[9*BW+:BW]; array[10][2*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd3 : begin array[0][3*BW+:BW] <= i_data[0*BW+:BW]; array[1][3*BW+:BW] <= i_data[1*BW+:BW]; array[2][3*BW+:BW] <= i_data[2*BW+:BW]; array[3][3*BW+:BW] <= i_data[3*BW+:BW]; array[4][3*BW+:BW] <= i_data[4*BW+:BW]; array[5][3*BW+:BW] <= i_data[5*BW+:BW]; array[6][3*BW+:BW] <= i_data[6*BW+:BW]; array[7][3*BW+:BW] <= i_data[7*BW+:BW]; array[8][3*BW+:BW] <= i_data[8*BW+:BW]; array[9][3*BW+:BW] <= i_data[9*BW+:BW]; array[10][3*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd4 : begin array[0][4*BW+:BW] <= i_data[0*BW+:BW]; array[1][4*BW+:BW] <= i_data[1*BW+:BW]; array[2][4*BW+:BW] <= i_data[2*BW+:BW]; array[3][4*BW+:BW] <= i_data[3*BW+:BW]; array[4][4*BW+:BW] <= i_data[4*BW+:BW]; array[5][4*BW+:BW] <= i_data[5*BW+:BW]; array[6][4*BW+:BW] <= i_data[6*BW+:BW]; array[7][4*BW+:BW] <= i_data[7*BW+:BW]; array[8][4*BW+:BW] <= i_data[8*BW+:BW]; array[9][4*BW+:BW] <= i_data[9*BW+:BW]; array[10][4*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd5 : begin array[0][5*BW+:BW] <= i_data[0*BW+:BW]; array[1][5*BW+:BW] <= i_data[1*BW+:BW]; array[2][5*BW+:BW] <= i_data[2*BW+:BW]; array[3][5*BW+:BW] <= i_data[3*BW+:BW]; array[4][5*BW+:BW] <= i_data[4*BW+:BW]; array[5][5*BW+:BW] <= i_data[5*BW+:BW]; array[6][5*BW+:BW] <= i_data[6*BW+:BW]; array[7][5*BW+:BW] <= i_data[7*BW+:BW]; array[8][5*BW+:BW] <= i_data[8*BW+:BW]; array[9][5*BW+:BW] <= i_data[9*BW+:BW]; array[10][5*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd6 : begin array[0][6*BW+:BW] <= i_data[0*BW+:BW]; array[1][6*BW+:BW] <= i_data[1*BW+:BW]; array[2][6*BW+:BW] <= i_data[2*BW+:BW]; array[3][6*BW+:BW] <= i_data[3*BW+:BW]; array[4][6*BW+:BW] <= i_data[4*BW+:BW]; array[5][6*BW+:BW] <= i_data[5*BW+:BW]; array[6][6*BW+:BW] <= i_data[6*BW+:BW]; array[7][6*BW+:BW] <= i_data[7*BW+:BW]; array[8][6*BW+:BW] <= i_data[8*BW+:BW]; array[9][6*BW+:BW] <= i_data[9*BW+:BW]; array[10][6*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd7 : begin array[0][7*BW+:BW] <= i_data[0*BW+:BW]; array[1][7*BW+:BW] <= i_data[1*BW+:BW]; array[2][7*BW+:BW] <= i_data[2*BW+:BW]; array[3][7*BW+:BW] <= i_data[3*BW+:BW]; array[4][7*BW+:BW] <= i_data[4*BW+:BW]; array[5][7*BW+:BW] <= i_data[5*BW+:BW]; array[6][7*BW+:BW] <= i_data[6*BW+:BW]; array[7][7*BW+:BW] <= i_data[7*BW+:BW]; array[8][7*BW+:BW] <= i_data[8*BW+:BW]; array[9][7*BW+:BW] <= i_data[9*BW+:BW]; array[10][7*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd8 : begin array[0][8*BW+:BW] <= i_data[0*BW+:BW]; array[1][8*BW+:BW] <= i_data[1*BW+:BW]; array[2][8*BW+:BW] <= i_data[2*BW+:BW]; array[3][8*BW+:BW] <= i_data[3*BW+:BW]; array[4][8*BW+:BW] <= i_data[4*BW+:BW]; array[5][8*BW+:BW] <= i_data[5*BW+:BW]; array[6][8*BW+:BW] <= i_data[6*BW+:BW]; array[7][8*BW+:BW] <= i_data[7*BW+:BW]; array[8][8*BW+:BW] <= i_data[8*BW+:BW]; array[9][8*BW+:BW] <= i_data[9*BW+:BW]; array[10][8*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd9 : begin array[0][9*BW+:BW] <= i_data[0*BW+:BW]; array[1][9*BW+:BW] <= i_data[1*BW+:BW]; array[2][9*BW+:BW] <= i_data[2*BW+:BW]; array[3][9*BW+:BW] <= i_data[3*BW+:BW]; array[4][9*BW+:BW] <= i_data[4*BW+:BW]; array[5][9*BW+:BW] <= i_data[5*BW+:BW]; array[6][9*BW+:BW] <= i_data[6*BW+:BW]; array[7][9*BW+:BW] <= i_data[7*BW+:BW]; array[8][9*BW+:BW] <= i_data[8*BW+:BW]; array[9][9*BW+:BW] <= i_data[9*BW+:BW]; array[10][9*BW+:BW] <= i_data[10*BW+:BW]; end
                4'd10: begin array[0][10*BW+:BW] <= i_data[0*BW+:BW]; array[1][10*BW+:BW] <= i_data[1*BW+:BW]; array[2][10*BW+:BW] <= i_data[2*BW+:BW]; array[3][10*BW+:BW] <= i_data[3*BW+:BW]; array[4][10*BW+:BW] <= i_data[4*BW+:BW]; array[5][10*BW+:BW] <= i_data[5*BW+:BW]; array[6][10*BW+:BW] <= i_data[6*BW+:BW]; array[7][10*BW+:BW] <= i_data[7*BW+:BW]; array[8][10*BW+:BW] <= i_data[8*BW+:BW]; array[9][10*BW+:BW] <= i_data[9*BW+:BW]; array[10][10*BW+:BW] <= i_data[10*BW+:BW]; end
            endcase
        end
    end

    always @(posedge i_clk or negedge i_Reset) begin
        if (!i_Reset) begin
            o_data <= {11*BW{1'b0}};
            o_en   <= 1'b0;
        end else begin
            o_data <= data_out;
            o_en   <= phase;
        end
    end

endmodule
