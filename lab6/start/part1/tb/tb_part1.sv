`timescale  1ns / 1ps

module tb_part1;

// part1 Parameters
parameter PERIOD    = 10       ;
parameter HEX_FILE  = "../mem.hex";

// part1 Inputs
reg   clk                                  = 0 ;
reg   reset                                = 1 ;
reg   [7:0]  i_SW                          = 0 ;

// part1 Outputs
wire  [7:0]  o_LEDR                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) reset  =  0;
end

part1 #(
    .HEX_FILE ( HEX_FILE ))
 u_part1 (
    .clk                     ( clk           ),
    .reset                   ( reset        ),
    .i_SW                    ( i_SW    [7:0] ),

    .o_LEDR                  ( o_LEDR  [7:0] )
);

initial
begin
    i_SW = 8'h0;
    #40
    i_SW = '1;
    #300
    i_SW = 8'b10101010;
    #300
    $stop;
end

endmodule