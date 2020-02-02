// REVIEW line_drawing_algo module

module line_drawing_algo (
    input clk,
    input reset,

    input i_start,
    input [8:0] i_x0,
    input [7:0] i_y0,
    input [8:0] i_x1,
    input [7:0] i_y1,
    input [2:0] i_color,

    output logic [8:0] o_x,
    output logic [7:0] o_y,
    output logic o_plot,
    output logic [2:0] o_color,

    output logic o_done
);

    logic clear_done, line_done;
    logic data_reset, start_draw_line, clear_canvas, draw_line;

    lda_control  u_lda_control (
        .clk                     ( clk                ),
        .reset                   ( reset              ),
        .i_start                 ( i_start            ),
        .i_clear_done            ( clear_done         ),
        .i_line_done             ( line_done          ),

        .o_done                  ( o_done             ),
        .o_data_reset            ( data_reset         ),
        .o_start_draw_line       ( start_draw_line    ),
        .o_clear_canvas          ( clear_canvas       ),
        .o_draw_line             ( draw_line          )
    );

    lda_datapath  u_lda_datapath (
        .clk                     ( clk                    ),
        .reset                   ( reset                  ),
        .i_x0                    ( i_x0             [8:0] ),
        .i_y0                    ( i_y0             [7:0] ),
        .i_x1                    ( i_x1             [8:0] ),
        .i_y1                    ( i_y1             [7:0] ),
        .i_color                 ( i_color          [2:0] ),
        .i_data_reset            ( data_reset             ),
        .i_clear_canvas          ( clear_canvas           ),
        .i_start_draw_line       ( start_draw_line        ),
        .i_draw_line             ( draw_line              ),

        .o_clear_done            ( clear_done             ),
        .o_line_done             ( line_done              ),
        .o_x                     ( o_x                    ),
        .o_y                     ( o_y                    ),
        .o_plot                  ( o_plot                 ),
        .o_color                 ( o_color                )
    );
    
endmodule