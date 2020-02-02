// REVIEW line drawing algo module
`timescale  1ns / 1ps

module tb_line_drawing_algo;

// line_drawing_algo Parameters
parameter PERIOD  = 10;


// line_drawing_algo Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
logic   i_start                            ;
logic   [8:0]  i_x0                        ;
logic   [7:0]  i_y0                        ;
logic   [8:0]  i_x1                        ;
logic   [7:0]  i_y1                        ;
logic   [2:0]  i_color                     ;

// line_drawing_algo Outputs
logic [8:0] o_x                      ;
logic [7:0] o_y                      ;
logic o_plot                         ;
logic [2:0] o_color                  ;
logic o_done                         ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

line_drawing_algo  u_line_drawing_algo (
    .clk                     ( clk            ),
    .reset                   ( ~rst_n         ),
    .i_start                 ( i_start        ),
    .i_x0                    ( i_x0     [8:0] ),
    .i_y0                    ( i_y0     [7:0] ),
    .i_x1                    ( i_x1     [8:0] ),
    .i_y1                    ( i_y1     [7:0] ),
    .i_color                 ( i_color  [2:0] ),

    .o_x                     ( o_x            ),
    .o_y                     ( o_y            ),
    .o_plot                  ( o_plot         ),
    .o_color                 ( o_color        ),
    .o_done                  ( o_done         )
);

initial
begin

    // NOTE init value
    i_x0 = 1;
    i_y0 = 1;
    i_x1 = 12;
    i_y1 = 5;
    i_color = 3'b111;   // white
    i_start = 0;

    // NOTE wait for reset
    #20;
    i_start = 1;
    #100;
    i_start = 0;

    wait (o_done == 1);
    // #10000;
    #20;

    // NOTE second line
    i_x0 = 0;
    i_y0 = 6;
    i_x1 = 2;
    i_y1 = 1;
    i_color = 3'b001;   // blue
    i_start = 1;
    #100;
    i_start = 0;

    wait (o_done == 1);
    #20;
    $stop;
end

endmodule