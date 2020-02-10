//~ `New testbench
`timescale  1ns / 1ps

module tb_avalon_slave_controller;

// avalon_slave_controller Parameters
parameter PERIOD  = 10;


// avalon_slave_controller Inputs
logic   clk                                  = 0 ;
logic   reset                                ;
logic   rst_n                                = 0 ;
logic   [2:0]  s_address                     = 0 ;
logic   s_read                               = 0 ;
logic   s_write                              = 0 ;
logic   [31:0]  s_writedata                  = 0 ;
logic   i_done                               = 0 ;

// avalon_slave_controller Outputs
logic [31:0]  s_readdata                   ;
logic s_waitrequest                        ;
logic        o_start                 ;
logic [8:0]  o_x0                    ;
logic [7:0]  o_y0                    ;
logic [8:0]  o_x1                    ;
logic [7:0]  o_y1                    ;
logic [2:0]  o_color                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end
assign reset = ~rst_n;

avalon_slave_controller  u_avalon_slave_controller (
    .clk                     ( clk                          ),
    .reset                   ( reset                        ),
    .s_address               ( s_address             [2:0]  ),
    .s_read                  ( s_read                       ),
    .s_write                 ( s_write                      ),
    .s_writedata             ( s_writedata           [31:0] ),
    .i_done                  ( i_done                       ),

    .s_readdata              ( s_readdata            [31:0] ),
    .s_waitrequest           ( s_waitrequest                ),
    .o_start                 ( o_start         ),
    .o_x0                    ( o_x0            ),
    .o_y0                    ( o_y0            ),
    .o_x1                    ( o_x1            ),
    .o_y1                    ( o_y1            ),
    .o_color                 ( o_color         )
);

initial
begin
    #20;
    s_address = 3'b0;
    s_writedata = 1;
    s_write = 1;
    #10;
    s_write = 0;
    #10;
    s_address = 3'b011;
    s_write = 1;
    s_writedata = 32'b1000_0001_1101_1010;
    #10;
    s_write = 0;
    #20;
    s_address = 3'b010;
    s_write = 1;
    #100;
    i_done = 1;
    #10;
    i_done = 0;
    #100;
    s_write = 0;
    #10;
    i_done = 0;
    #100;
    $stop;
end

endmodule