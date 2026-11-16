module one_d_dct #(
    parameter IN_W  = 13,
    parameter ACC_W = 18
)(
    input  wire [16*IN_W-1:0]  i_x,
    output wire [16*ACC_W-1:0] o_acc
);

    wire signed [IN_W-1:0] x0  = i_x[ 0*IN_W +: IN_W];
    wire signed [IN_W-1:0] x1  = i_x[ 1*IN_W +: IN_W];
    wire signed [IN_W-1:0] x2  = i_x[ 2*IN_W +: IN_W];
    wire signed [IN_W-1:0] x3  = i_x[ 3*IN_W +: IN_W];
    wire signed [IN_W-1:0] x4  = i_x[ 4*IN_W +: IN_W];
    wire signed [IN_W-1:0] x5  = i_x[ 5*IN_W +: IN_W];
    wire signed [IN_W-1:0] x6  = i_x[ 6*IN_W +: IN_W];
    wire signed [IN_W-1:0] x7  = i_x[ 7*IN_W +: IN_W];
    wire signed [IN_W-1:0] x8  = i_x[ 8*IN_W +: IN_W];
    wire signed [IN_W-1:0] x9  = i_x[ 9*IN_W +: IN_W];
    wire signed [IN_W-1:0] x10 = i_x[10*IN_W +: IN_W];
    wire signed [IN_W-1:0] x11 = i_x[11*IN_W +: IN_W];
    wire signed [IN_W-1:0] x12 = i_x[12*IN_W +: IN_W];
    wire signed [IN_W-1:0] x13 = i_x[13*IN_W +: IN_W];
    wire signed [IN_W-1:0] x14 = i_x[14*IN_W +: IN_W];
    wire signed [IN_W-1:0] x15 = i_x[15*IN_W +: IN_W];

    wire signed [IN_W:0] xE0 = x0 + x15;
    wire signed [IN_W:0] xE1 = x1 + x14;
    wire signed [IN_W:0] xE2 = x2 + x13;
    wire signed [IN_W:0] xE3 = x3 + x12;
    wire signed [IN_W:0] xE4 = x4 + x11;
    wire signed [IN_W:0] xE5 = x5 + x10;
    wire signed [IN_W:0] xE6 = x6 + x9;
    wire signed [IN_W:0] xE7 = x7 + x8;

    wire signed [IN_W:0] xO0 = x0 - x15;
    wire signed [IN_W:0] xO1 = x1 - x14;
    wire signed [IN_W:0] xO2 = x2 - x13;
    wire signed [IN_W:0] xO3 = x3 - x12;
    wire signed [IN_W:0] xO4 = x4 - x11;
    wire signed [IN_W:0] xO5 = x5 - x10;
    wire signed [IN_W:0] xO6 = x6 - x9;
    wire signed [IN_W:0] xO7 = x7 - x8;

    wire signed [IN_W+1:0] ee0 = xE0 + xE7;
    wire signed [IN_W+1:0] ee1 = xE1 + xE6;
    wire signed [IN_W+1:0] ee2 = xE2 + xE5;
    wire signed [IN_W+1:0] ee3 = xE3 + xE4;
    wire signed [IN_W+1:0] eo0 = xE0 - xE7;
    wire signed [IN_W+1:0] eo1 = xE1 - xE6;
    wire signed [IN_W+1:0] eo2 = xE2 - xE5;
    wire signed [IN_W+1:0] eo3 = xE3 - xE4;

    wire signed [IN_W+3:0] sum_ee = ee0 + ee1 + ee2 + ee3;
    wire signed [IN_W+3:0] alt_ee = ee0 - ee1 - ee2 + ee3;
    wire signed [ACC_W-1:0] A4 = ee0 - ee3;
    wire signed [ACC_W-1:0] B4 = ee1 - ee2;


    wire signed [ACC_W-1:0] xO0_5=(xO0<<<2)+xO0, xO0_9=(xO0<<<3)+xO0;
    wire signed [ACC_W-1:0] xO1_5=(xO1<<<2)+xO1;
    wire signed [ACC_W-1:0] xO2_3=(xO2<<<2)-xO2, xO2_5=(xO2<<<2)+xO2, xO2_9=(xO2<<<3)+xO2;
    wire signed [ACC_W-1:0] xO3_5=(xO3<<<2)+xO3, xO3_9=(xO3<<<3)+xO3;
    wire signed [ACC_W-1:0] xO4_3=(xO4<<<2)-xO4, xO4_5=(xO4<<<2)+xO4;
    wire signed [ACC_W-1:0] xO5_3=(xO5<<<2)-xO5, xO5_5=(xO5<<<2)+xO5;
    wire signed [ACC_W-1:0] xO6_3=(xO6<<<2)-xO6, xO6_5=(xO6<<<2)+xO6, xO6_9=(xO6<<<3)+xO6;
    wire signed [ACC_W-1:0] xO7_3=(xO7<<<2)-xO7, xO7_5=(xO7<<<2)+xO7, xO7_9=(xO7<<<3)+xO7;

    wire signed [ACC_W-1:0] eo0_3=(eo0<<<2)-eo0, eo0_5=(eo0<<<2)+eo0, eo0_9=(eo0<<<3)+eo0;
    wire signed [ACC_W-1:0] eo1_5=(eo1<<<2)+eo1, eo1_9=(eo1<<<3)+eo1;
    wire signed [ACC_W-1:0] eo2_3=(eo2<<<2)-eo2, eo2_5=(eo2<<<2)+eo2;
    wire signed [ACC_W-1:0] eo3_3=(eo3<<<2)-eo3, eo3_9=(eo3<<<3)+eo3;

    wire signed [ACC_W-1:0] A4_5=(A4<<<2)+A4;


    assign o_acc[ 0*ACC_W +: ACC_W] = sum_ee <<< 3;
    assign o_acc[ 2*ACC_W +: ACC_W] = ((eo0<<<4)-eo0_5) + eo1_9 + (eo2_3<<<1) + (eo3<<<1);
    assign o_acc[ 4*ACC_W +: ACC_W] = (A4_5<<<1) + (B4<<<2);
    assign o_acc[ 6*ACC_W +: ACC_W] = eo0_9 - (eo1<<<1) - ((eo2<<<4)-eo2_5) - (eo3_3<<<1);
    assign o_acc[ 8*ACC_W +: ACC_W] = alt_ee <<< 3;
    assign o_acc[10*ACC_W +: ACC_W] = (eo0_3<<<1) - ((eo1<<<4)-eo1_5) + (eo2<<<1) + eo3_9;
    assign o_acc[12*ACC_W +: ACC_W] = {ACC_W{1'b0}};
    assign o_acc[14*ACC_W +: ACC_W] = {ACC_W{1'b0}};


    assign o_acc[ 1*ACC_W +: ACC_W] = ((xO0<<<4)-xO0_5) + ((xO1<<<4)-xO1_5) + (xO2_5<<<1)
                                    + xO3_9 + ((xO4<<<3)-xO4) + xO5_5 + xO6_3 + xO7;
    assign o_acc[ 3*ACC_W +: ACC_W] = ((xO0<<<4)-xO0_5) + ((xO1<<<3)-xO1) + xO2
                                    - xO3_5 - (xO4_5<<<1) - ((xO5<<<4)-xO5_5) - xO6_9 - xO7_3;
    assign o_acc[ 5*ACC_W +: ACC_W] = (xO0_5<<<1) + xO1 - xO2_9 - ((xO3<<<4)-xO3_5)
                                    - xO4_3 + ((xO5<<<3)-xO5) + ((xO6<<<4)-xO6_5) + xO7_5;
    assign o_acc[ 7*ACC_W +: ACC_W] = xO0_9 - xO1_5 - ((xO2<<<4)-xO2_5) + xO3
                                    + ((xO4<<<4)-xO4_5) + xO5_3 - (xO6_5<<<1) - ((xO7<<<3)-xO7);
    assign o_acc[ 9*ACC_W +: ACC_W] = ((xO0<<<3)-xO0) - (xO1_5<<<1) - xO2_3 + ((xO3<<<4)-xO3_5)
                                    - xO4 - ((xO5<<<4)-xO5_5) + xO6_5 + xO7_9;
    assign o_acc[11*ACC_W +: ACC_W] = {ACC_W{1'b0}};
    assign o_acc[13*ACC_W +: ACC_W] = {ACC_W{1'b0}};
    assign o_acc[15*ACC_W +: ACC_W] = {ACC_W{1'b0}};

endmodule
