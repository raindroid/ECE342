// REVIEW testbench multiplier_cell

`timescale  1ns / 1ps

module tb_multiplier_cell;

// multiplier_cell Parameters
parameter PERIOD  = 10;


// multiplier_cell Inputs
reg   i_pin                                = 0 ;
reg   i_m                                  = 0 ;
reg   i_plus                               = 0 ;
reg   i_minus                              = 0 ;
reg   i_Cin                                = 0 ;

// multiplier_cell Outputs
wire  logic o_Cout                         ;
wire  logic o_Sign                         ;
wire  logic o_pout                         ;


multiplier_cell  u_multiplier_cell (
    .i_pin                   ( i_pin          ),
    .i_m                     ( i_m            ),
    .i_plus                  ( i_plus         ),
    .i_minus                 ( i_minus        ),
    .i_Cin                   ( i_Cin          ),

    .o_Cout            ( o_Cout   ),
    .o_Sign            ( o_Sign   ),
    .o_pout            ( o_pout   )
);

initial
begin

    

    // $finish;
end

endmodule