// REVIEW UI module

module user_interface (
    input clk,
    input reset,

    input i_setX,
    input i_setY,
    input i_set_col,
    input i_go,
    input [8:0] i_val,

    input i_done,

    output logic o_start,
    output logic [2:0] o_color,
    output logic [8:0] o_x0,
    output logic [7:0] o_y0,
    output logic [8:0] o_x1,
    output logic [7:0] o_y1
);

    logic updateXY;

    ui_control  u_ui_control (
        .clk       ( clk       ),
        .reset     ( reset     ),
        .i_go      ( i_go      ),
        .i_done    ( i_done    ),

        .o_updateXY( updateXY),
        .o_draw    ( o_start    )
    );

    ui_datapath  u_ui_datapath (
        .clk         ( clk        ),
        .reset       ( reset      ),
        .i_setX      ( i_setX     ),
        .i_setY      ( i_setY     ),
        .i_set_col   ( i_set_col  ),
        .i_updateXY  ( updateXY ),
        .i_val       ( i_val      ),

        .o_color     (o_color     ),
        .o_x0        (o_x0        ),
        .o_y0        (o_y0        ),
        .o_x1        (o_x1        ),
        .o_y1        (o_y1        )
    );

endmodule