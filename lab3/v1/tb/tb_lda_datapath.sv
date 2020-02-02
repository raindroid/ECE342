//~ `New testbench
`timescale  1ns / 1ps

module tb_lda_datapath;

// lda_datapath Parameters
parameter PERIOD  = 10;


// lda_datapath Inputs
logic   clk              ;
logic   rst_n            ;
logic   [8:0]  i_x0      ;
logic   [7:0]  i_y0      ;
logic   [8:0]  i_x1      ;
logic   [7:0]  i_y1      ;
logic   [2:0]  i_color   ;
logic   i_start          ;
logic   i_clear_canvas   ;
logic   i_draw_line      ;
logic   i_start_draw_line;

// lda_datapath Outputs
logic  o_start                              ;
logic  o_clear_done                         ;
logic  o_line_done                          ;
logic  [8:0] o_x                      ;
logic  [7:0] o_y                      ;
logic  o_plot                         ;
logic  [2:0] o_color                  ;


initial
begin
    clk = 0;
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    rst_n = 0;
    #(PERIOD*2) rst_n  =  1;
end

lda_datapath  u_lda_datapath (
    .clk                     ( clk                        ),
    .reset                   ( ~rst_n                      ),
    .i_x0                    ( i_x0                 [8:0] ),
    .i_y0                    ( i_y0                 [7:0] ),
    .i_x1                    ( i_x1                 [8:0] ),
    .i_y1                    ( i_y1                 [7:0] ),
    .i_color                 ( i_color              [2:0] ),
    .i_start                 ( i_start                    ),
    .i_clear_canvas          ( i_clear_canvas             ),
    .i_start_draw_line       ( i_start_draw_line),
    .i_draw_line             ( i_draw_line                ),

    .o_clear_done            ( o_clear_done               ),
    .o_line_done             ( o_line_done                ),
    .o_x         ( o_x            ),
    .o_y         ( o_y            ),
    .o_plot            ( o_plot               ),
    .o_color     ( o_color        )
);

initial
begin

    i_start_draw_line = 0;
    i_clear_canvas = 0;

    // NOTE test clear
    i_start = 1;
    #100;
    i_start = 0;
    i_clear_canvas = 1;
    // #100000;
    #100;
    i_clear_canvas = 0;

    // NOTE test draw
    i_x0 = 1;
    i_y0 = 1;
    i_x1 = 12;
    i_y1 = 5;
    i_color = 3'b111;   // white
    i_start_draw_line = 1;
    #10;
    i_start_draw_line = 0;
    i_draw_line = 1;
    #2000;
    i_draw_line = 0;
    #100;
    $stop;
end

endmodule