module Top(
    input clk,
    input rstn
);

    localparam BW    = 11;   // TP word width: r1 is 11-bit (max 1020); output
                             //   stored as 11-bit (LSB dropped, padded at MEM_OUT)
    localparam ACC_W = 18;   // num_bin=6: max|acc2|=130560 < 2^17, 18-bit safe
    localparam SH1   = 5;    // 1-D quant  = num_bin-1
    localparam SH_DC = 6;    // 2-D DC store = acc2 >>> num_bin
    localparam SH_AC = 4;    // 2-D AC store = acc2 >>> (num_bin-2)

    reg [19:0] cnt;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) cnt <= 20'd0;
        else       cnt <= cnt + 20'd1;
    end

    wire        in_valid = 1'b1;
    wire [13:0] in_addr  = cnt[13:0];

    wire [127:0] mem_in_dout;
    reg  [9:0]   mem_in_ra;
    reg  [3:0]   mem_in_ca;
    reg          mem_in_nwrt, mem_in_nce;
    reg  [127:0] mem_in_din;

    always @(*) begin
        mem_in_din  = 128'd0;
        mem_in_ca   = in_addr[3:0];
        mem_in_ra   = in_addr[13:4];
        mem_in_nce  = in_valid ? 1'b0 : 1'b1;
        mem_in_nwrt = 1'b1;
    end

    rflp16384x128mx16 MEM_IN(
        .DO(mem_in_dout), .DIN(mem_in_din),
        .RA(mem_in_ra), .CA(mem_in_ca),
        .NWRT(mem_in_nwrt), .NCE(mem_in_nce), .CLK(clk)
    );

    wire [16*13-1:0] dct1_in;
    genvar p;
    generate
        for (p = 0; p < 16; p = p + 1) begin : G_PIX
            assign dct1_in[p*13 +: 13] = {5'b0, mem_in_dout[(15-p)*8 +: 8]};
        end
    endgenerate

    wire [16*ACC_W-1:0] dct1_acc;
    one_d_dct DCT_ROW(
        .i_x(dct1_in), .o_acc(dct1_acc)
    );

    wire [16*BW-1:0] r1_packed;
    generate
        for (p = 0; p < 16; p = p + 1) begin : G_R1
            wire signed [ACC_W-1:0] a = dct1_acc[p*ACC_W +: ACC_W];
            assign r1_packed[p*BW +: BW] = a[SH1 +: BW];
        end
    endgenerate

    reg [16*BW-1:0] tp_din;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) tp_din <= {16*BW{1'b0}};
        else       tp_din <= r1_packed;
    end

    wire [16*BW-1:0] tpin_dout;
    wire             tpin_oen;
    wire             tpin_en = (cnt >= 20'd2);

    TPmem_16x16_sb TP_IN(
        .i_data(tp_din), .i_enable(tpin_en), .i_clk(clk), .i_Reset(rstn),
        .o_data(tpin_dout), .o_en(tpin_oen)
    );

    wire [19:0] rc   = cnt - 20'd19;
    wire [3:0]  rcol = rc[3:0];

    wire [16*13-1:0] dct2_in;
    generate
        for (p = 0; p < 16; p = p + 1) begin : G_DCT2IN
            assign dct2_in[p*13 +: 13] =
                {{(13-BW){tpin_dout[p*BW+BW-1]}}, tpin_dout[p*BW +: BW]};
        end
    endgenerate

    wire [16*ACC_W-1:0] dct2_acc;
    one_d_dct DCT_COL(
        .i_x(dct2_in), .o_acc(dct2_acc)
    );

    wire is_dc_col = (rcol == 4'd0);
    wire [16*BW-1:0] trunc_flat;
    genvar te;
    generate
        for (te = 0; te < 16; te = te + 1) begin : G_TRUNC
            wire signed [ACC_W-1:0] a2t = dct2_acc[te*ACC_W +: ACC_W];
            wire signed [ACC_W-1:0] sdc = a2t >>> SH_DC;
            wire signed [ACC_W-1:0] sac = a2t >>> SH_AC;
            wire is_dc = is_dc_col && (te == 0);
            wire signed [11:0] ac_sat;
            GLITCH_HANDLER GH (.in(sac), .out(ac_sat));
            wire signed [11:0] coef12 = is_dc ? sdc[11:0] : ac_sat;
            assign trunc_flat[te*BW +: BW] = coef12[11:12-BW];  // drop low 12-BW bits
        end
    endgenerate

    reg [16*BW-1:0] oc_din;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) oc_din <= {16*BW{1'b0}};
        else       oc_din <= trunc_flat;
    end


    wire [11*BW-1:0] oc_din11 = oc_din[0 +: 11*BW];   // elements 0..10 (non-zero freqs)
    wire [11*BW-1:0] tpout_d11;
    wire             tpout_oen;
    wire             tpout_en = (cnt >= 20'd20);

    TPmem_11x11_sb TP_OUT(
        .i_data(oc_din11), .i_enable(tpout_en), .i_clk(clk), .i_Reset(rstn),
        .o_data(tpout_d11), .o_en(tpout_oen)
    );

    wire [16*BW-1:0] tpout_dout = { {5*BW{1'b0}}, tpout_d11 };

    wire [19:0] mc      = cnt - 20'd37;
    wire [9:0]  mblk    = mc[13:4];
    wire [3:0]  mrow    = mc[3:0];
    wire        m_valid = (cnt >= 20'd37);

    wire [191:0] m_word;
    generate
        for (te = 0; te < 16; te = te + 1) begin : G_MOUT
            assign m_word[(15-te)*12 +: 12] =
                {tpout_dout[te*BW +: BW], {(12-BW){1'b0}}};
        end
    endgenerate

    wire [13:0]  wr_addr = {mblk, mrow};

    wire [191:0] mem_out_dout;
    reg  [9:0]   mem_out_ra;
    reg  [3:0]   mem_out_ca;
    reg          mem_out_nwrt, mem_out_nce;
    reg  [191:0] mem_out_din;

    always @(*) begin
        mem_out_din  = m_word;
        mem_out_ca   = wr_addr[3:0];
        mem_out_ra   = wr_addr[13:4];
        mem_out_nce  = m_valid ? 1'b0 : 1'b1;
        mem_out_nwrt = m_valid ? 1'b0 : 1'b1;
    end

    rflp16384x192mx16 MEM_OUT(
        .DO(mem_out_dout), .DIN(mem_out_din),
        .RA(mem_out_ra), .CA(mem_out_ca),
        .NWRT(mem_out_nwrt), .NCE(mem_out_nce), .CLK(clk)
    );

endmodule

module GLITCH_HANDLER #(
    parameter W = 18
)(
    input  wire signed [W-1:0] in,
    output wire signed [11:0]  out
);
    assign out = (in >  2046) ?  12'sd2046 :
                 (in < -2048) ? -12'sd2048 :
                 in[11:0];
endmodule
