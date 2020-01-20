// REVIEW testbench SAM

`timescale  1ns / 1ps

module tb_signed_array_multiplier;

// signed_array_multiplier Parameters
parameter PERIOD = 10;
parameter N  = 8;

// signed_array_multiplier Inputs
reg   [N - 1: 0]  i_m                      = 0 ;
reg   [N - 1: 0]  i_q                      = 0 ;

// signed_array_multiplier Outputs
wire  [2 * N - 1: 0]  o_p                  ;

signed_array_multiplier #(
    .N ( N ))
 u_signed_array_multiplier (
    .i_m                     ( i_m  [N - 1: 0]     ),
    .i_q                     ( i_q  [N - 1: 0]     ),

    .o_p                     ( o_p  [2 * N - 1: 0] )
);

initial
begin
    i_m = 8'd1;
    i_q = 8'd1;
    #10;
    $display("M: %d, Q: %d, Result: %d", i_m, i_q, o_p);

    // $finish;
end

endmodule