/**
 * REVIEW 
 * module wallace_tree_multiplier
 */

module wallace_tree_multiplier 
(
    input [7: 0] i_m,
    input [7: 0] i_q,

    output [2 * 7: 0] o_p
);

    logic [2 * 7: 0] pout;

    logic [14:0] p0 [7:0];
    logic [14:0] p1 [5:0];
    logic [14:0] p2 [3:0];
    logic [14:0] p3 [2:0];
    logic [15:0] p4 [1:0];
    
    genvar i, j;

    // NOTE generate p0
    generate
        for (int i = 0; i < 8; i++) begin: 
    endgenerate 


    assign o_p = pout;
    
endmodule