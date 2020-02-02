// REVIEW ui_datapath module

module ui_datapath (
    input clk,
    input reset,

    input i_setX,
    input i_setY,
    input i_set_col,
    input i_updateXY,
    input [8:0] i_val,

    output logic [2:0] o_color,
    output logic [8:0] o_x0,
    output logic [7:0] o_y0,
    output logic [8:0] o_x1,
    output logic [7:0] o_y1
);

    logic [8:0] tempX;
    logic [7:0] tempY;

    reg_n #(9) tempX_reg(clk, reset, i_setX, i_val[8:0], tempX);
    reg_n #(8) tempY_reg(clk, reset, i_setY, i_val[7:0], tempY);
    reg_n #(3) color_reg(clk, reset, i_set_col, i_val[2:0], o_color);

    // NOTE output XY are  trigerred by updateXY signal
    reg_n #(9) outX1_reg(clk, reset, i_updateXY, tempX, o_x1);
    reg_n #(9) outX0_reg(clk, reset, i_updateXY, o_x1, o_x0);
    reg_n #(8) outY1_reg(clk, reset, i_updateXY, tempY, o_y1);
    reg_n #(8) outY0_reg(clk, reset, i_updateXY, o_y1, o_y0);

    
endmodule