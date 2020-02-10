module lda_peripheral (
    input clk,
    input reset,

    // NOTE Avalon slave signals
    input [2:0]     avs_s1_address,
    input           avs_s1_read,
    output [31:0]   avs_s1_readdata,    // master read from us
    output          avs_s1_waitrequest,
    input           avs_s1_write,   
    input [31:0]    avs_s1_writedata,   // master write to us

    // NOTE VGA signals
    output [7:0]    coe_VGA_B_export,
    output          coe_VGA_BLANK_N_export,
    output          coe_VGA_CLK_export,
    output [7:0]    coe_VGA_G_export,
    output          coe_VGA_HS_export,
    output [7:0]    coe_VGA_R_export,
    output          coe_VGA_SYNC_N_export,
    output          coe_VGA_VS_export
);

    // VGA adapter and signals
    logic [8:0] vga_x;
    logic [7:0] vga_y;
    logic [2:0] vga_color;
    logic vga_plot;

    vga_adapter #
    (
        .BITS_PER_CHANNEL(1)
    )
    vga_inst
    (
        .clk(clk),
        .VGA_R(coe_VGA_R_export),
        .VGA_G(coe_VGA_G_export),
        .VGA_B(coe_VGA_B_export),
        .VGA_HS(coe_VGA_HS_export),
        .VGA_VS(coe_VGA_VS_export),
        .VGA_SYNC_N(coe_VGA_SYNC_N_export),
        .VGA_BLANK_N(coe_VGA_BLANK_N_export),
        .VGA_CLK(coe_VGA_CLK_export),
        .x(vga_x),
        .y(vga_y),
        .color(vga_color),
        .plot(vga_plot)
    );

    
    logic [8:0] s_x0, s_x1;
    logic [7:0] s_y0, s_y1;
    logic [2:0] s_color;
    
    logic s_done, s_start;

    avalon_slave_controller  u_avalon_slave_controller (
        .clk                     ( clk                          ),
        .reset                   ( reset                        ),
        .s_address               ( avs_s1_address             [2:0]  ),
        .s_read                  ( avs_s1_read                       ),
        .s_write                 ( avs_s1_write                      ),
        .s_writedata             ( avs_s1_writedata           [31:0] ),
        .i_done                  ( s_done                       ),

        .s_readdata              ( avs_s1_readdata            [31:0] ),
        .s_waitrequest           ( avs_s1_waitrequest                ),
        .o_start                 ( s_start         ),
        .o_x0                    ( s_x0            ),
        .o_y0                    ( s_y0            ),
        .o_x1                    ( s_x1            ),
        .o_y1                    ( s_y1            ),
        .o_color                 ( s_color         )
    );

    line_drawing_algo  u_line_drawing_algo (
        .clk                     ( clk     ),
        .reset                   ( reset        ),
        .i_start                 ( s_start        ),
        .i_x0                    ( s_x0     [8:0] ),
        .i_y0                    ( s_y0     [7:0] ),
        .i_x1                    ( s_x1     [8:0] ),
        .i_y1                    ( s_y1     [7:0] ),
        .i_color                 ( s_color  [2:0] ),

        .o_x                     ( vga_x            ),
        .o_y                     ( vga_y           ),
        .o_plot                  ( vga_plot         ),
        .o_color                 ( vga_color       ),
        .o_done                  ( s_done       )
    );


    
endmodule