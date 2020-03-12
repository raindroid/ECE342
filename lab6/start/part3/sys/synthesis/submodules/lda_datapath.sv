// REVIEW  lda datapath module

module lda_datapath (
    input clk,
    input reset,

    input [8:0] i_x0,
    input [7:0] i_y0,
    input [8:0] i_x1,
    input [7:0] i_y1,
    input [2:0] i_color,

    input i_data_reset,
    input i_clear_canvas,
    input i_start_draw_line,
    input i_draw_line,
    
    output logic o_clear_done,
    output logic o_line_done,

    output logic [8:0] o_x,
    output logic [7:0] o_y,
    output logic o_plot,
    // output logic [2:0] o_color
    output logic [2:0][0:0] o_color
);
    // parameter W = 9'd335;
    // parameter H = 8'd210;
    // parameter W = 9'd15; // DEBUG only
    // parameter H = 8'd10;

    // FIXME !!!!! NOT REQUIRED !!!!!!!
    // REVIEW clearing part
    logic [12:0] clear_i; // NOTE range from 0 ~ 70559
    logic [8:0] clear_x;
    logic [7:0] clear_y;
    logic clear_plot;
    logic [2:0] clear_color = '0;   // set all pixels to black (default)

    // NOTE increment clear_i when clearing
    // Stop increment when clear is done
    lda_reg_n #(13) clear_i_reg (clk, i_data_reset | reset, i_clear_canvas, o_clear_done ? clear_i : clear_i + 1'b1, clear_i); 
    // x: 0 -> 335 and then go back to 0
    lda_reg_n #(9) clear_x_reg (clk, i_data_reset | reset, i_clear_canvas, (clear_x == W) ? '0 : clear_x + 1'b1, clear_x);
    // y increments when x reaches 335 (the end of the row)
    lda_reg_n #(8) clera_y_reg (clk, i_data_reset | reset, (clear_x == W) & i_clear_canvas, clear_y + 1'b1, clear_y);
    assign clear_plot = i_clear_canvas;
    // assign o_clear_done = clear_i >= (W + 1) * (H + 1) - 1;
    assign o_clear_done = 1;

    // REVIEW line drawing part
    
    // NOTE preprocessing data
    logic [8:0] after_steep_x0, after_steep_x1, draw_x0, draw_x1;
    // In case we need to switch x and y
    logic [8:0] after_steep_y0, after_steep_y1, draw_y0, draw_y1;

    wire [8:0] abs_dX = (i_x1 - i_x0) * (((i_x1 > i_x0) << 1) - 1);   // <=> abs(x1 - x0)
    wire [8:0] abs_dY = (i_y1 - i_y0) * (((i_y1 > i_y0) << 1) - 1);   // <=> abs(y1 - y0)
    wire steep = abs_dY > abs_dX;
    assign {after_steep_x0, after_steep_y0, after_steep_x1, after_steep_y1} = (steep) ? 
            {1'b0, i_y0, i_x0, 1'b0, i_y1, i_x1} : {i_x0, 1'b0, i_y0, i_x1, 1'b0, i_y1};

    // NOTE set up (x0, y0) and (x1, y1) 
    assign {draw_x0, draw_x1, draw_y0, draw_y1} = (after_steep_x0 > after_steep_x1) ? 
            {after_steep_x1, after_steep_x0, after_steep_y1, after_steep_y0} :
            {after_steep_x0, after_steep_x1, after_steep_y0, after_steep_y1};

    // NOTE set up local vars, extra bit for the sign
    wire signed [9:0] deltaX = draw_x1 - draw_x0;
    wire signed [9:0] deltaY = (draw_y1 - draw_y0) * (((draw_y1 > draw_y0) << 1) - 1); // <=> abs(y1 - y0)

    logic [8:0] loop_x, loop_y;
    reg signed [9:0] error;
    logic [8:0] draw_x, draw_y;
    logic draw_plot;
    wire [2:0] draw_color = i_color;
    wire signed [9:0] error_temp = error + deltaY;

    always_ff @(posedge clk) begin
        if (reset) begin
            draw_plot <= 0;
        end
        else if (i_start_draw_line) begin
            loop_x <= draw_x0;
            loop_y <= draw_y0;
            error <= - (deltaX >> 1);
            draw_plot <= 0;
            o_line_done <= 0;
        end
        else if (i_draw_line && loop_x <= draw_x1) begin
            draw_plot <= (loop_x <= draw_x1);
            loop_x <= loop_x + 1;
            {draw_x, draw_y} <= (steep) ? {loop_y, loop_x} : {loop_x, loop_y};
            if (error_temp > 0) begin
                loop_y <= draw_y0 < draw_y1 ? loop_y + 1 : (draw_y0 > draw_y1 ? loop_y - 1 : loop_y);
                error <= error + deltaY - deltaX;
            end
            else begin
                error <= error + deltaY;
            end
            // NOTE check for ending conditino
            if (loop_x == draw_x1 && loop_y == draw_y1) o_line_done <= 1;
        end
    end
    
    
    // REVIEW mux part
    assign {o_x, o_y, o_plot, o_color} = (clear_plot) ? {clear_x, clear_y, clear_plot, clear_color} : 
                                         (i_draw_line ? {draw_x, draw_y[7:0], draw_plot, draw_color} : '0);
    
endmodule