/**
 * REVIEW 
 * testbench Booth encoder
 */

`timescale  1ns / 1ps

module tb_booth_encoder;

// booth_encoder Parameters
parameter PERIOD  = 10;


// booth_encoder Inputs
reg   i_Qi                                 = 0 ;
reg   i_Qi_1                               = 0 ;

// booth_encoder Outputs
wire  logic o_plus                         ;    
wire  logic o_minus                        ;    

booth_encoder  u_booth_encoder (
    .i_Qi                    ( i_Qi            ),
    .i_Qi_1                  ( i_Qi_1          ),

    .o_plus            (  o_plus    ),
    .o_minus           (  o_minus   )
);

initial
begin
    // NOTE check all input combinations
    
    i_Qi = 0;
    i_Qi_1 = 0;
    #10;
    $display("Q_i: %d,\tQ_i_1: %d,\tplus: %d,\tminus: %d\t%s", i_Qi, i_Qi_1, o_plus, o_minus, (o_plus==0 && o_minus==0) ? "Correct" : "Wrong");
    
    i_Qi = 0;
    i_Qi_1 = 1;
    #10;
    $display("Q_i: %d,\tQ_i_1: %d,\tplus: %d,\tminus: %d\t%s", i_Qi, i_Qi_1, o_plus, o_minus, (o_plus==1 && o_minus==0) ? "Correct" : "Wrong");
    
    i_Qi = 1;
    i_Qi_1 = 0;
    #10;
    $display("Q_i: %d,\tQ_i_1: %d,\tplus: %d,\tminus: %d\t%s", i_Qi, i_Qi_1, o_plus, o_minus, (o_plus==0 && o_minus==1) ? "Correct" : "Wrong");
    
    i_Qi = 1;
    i_Qi_1 = 1;
    #10;
    $display("Q_i: %d,\tQ_i_1: %d,\tplus: %d,\tminus: %d\t%s", i_Qi, i_Qi_1, o_plus, o_minus, (o_plus==0 && o_minus==0) ? "Correct" : "Wrong");

    // $finish;
end

endmodule