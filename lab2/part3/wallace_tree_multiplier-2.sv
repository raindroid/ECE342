/**
 * REVIEW 
 * module wallace_tree_multiplier
 */

module wallace_tree_multiplier_
(
    input [7: 0] i_m,
    input [7: 0] i_q,

    output [15: 0] o_p
);

    logic [7:0] p [7:0];  // stage 0 input
    logic [20:0] s0, c0;
    logic [12:0] s1, c1;
    logic [9:0] s2, c2;
    logic [10:0] s3, c3;

    logic [16: 0] pout; // final result

    genvar i, j;
    // NOTE generate p0
    generate
        for (i = 0; i < 8; i++) begin: p0_rows
            for (j = 0; j < 8; j++) begin: p0_cells
                assign p[i][j] = i_m[i] & i_q[j];                
            end
        end
    endgenerate 
    
        // REVIEW stage 0
    // NOTE half adders 0
    full_adder  Stage0_HA_0 (.A(p[0][1]), .B(p[1][0]), .Cin(1'b0), .S(s0[0]), .Cout(c0[0]));
    full_adder  Stage0_HA_1 (.A(p[3][1]), .B(p[4][0]), .Cin(1'b0), .S(s0[1]), .Cout(c0[1]));
    full_adder  Stage0_HA_2 (.A(p[6][1]), .B(p[7][0]), .Cin(1'b0), .S(s0[2]), .Cout(c0[2]));
    full_adder  Stage0_HA_3 (.A(p[6][4]), .B(p[7][3]), .Cin(1'b0), .S(s0[3]), .Cout(c0[3]));
    full_adder  Stage0_HA_4 (.A(p[6][7]), .B(p[7][6]), .Cin(1'b0), .S(s0[4]), .Cout(c0[4]));
    // NOTE full adders 0
    full_adder  Stage0_FA_0 (.A(p[0][2]), .B(p[1][1]), .Cin(p[2][0]), .S(s0[5]), .Cout(c0[5]));
    full_adder  Stage0_FA_1 (.A(p[0][3]), .B(p[1][2]), .Cin(p[2][1]), .S(s0[6]), .Cout(c0[6]));
    full_adder  Stage0_FA_2 (.A(p[0][4]), .B(p[1][3]), .Cin(p[2][2]), .S(s0[7]), .Cout(c0[7]));
    full_adder  Stage0_FA_3 (.A(p[0][5]), .B(p[1][4]), .Cin(p[2][3]), .S(s0[8]), .Cout(c0[8]));
    full_adder  Stage0_FA_4 (.A(p[0][6]), .B(p[1][5]), .Cin(p[2][4]), .S(s0[9]), .Cout(c0[9]));
    full_adder  Stage0_FA_5 (.A(p[0][7]), .B(p[1][6]), .Cin(p[2][5]), .S(s0[10]), .Cout(c0[10]));
    full_adder  Stage0_FA_6 (.A(p[1][7]), .B(p[2][6]), .Cin(p[3][5]), .S(s0[11]), .Cout(c0[11]));
    full_adder  Stage0_FA_7 (.A(p[2][7]), .B(p[3][6]), .Cin(p[4][5]), .S(s0[12]), .Cout(c0[12]));
    full_adder  Stage0_FA_8 (.A(p[3][7]), .B(p[4][6]), .Cin(p[5][5]), .S(s0[13]), .Cout(c0[13]));
    full_adder  Stage0_FA_9 (.A(p[4][7]), .B(p[5][6]), .Cin(p[6][5]), .S(s0[14]), .Cout(c0[14]));
    full_adder  Stage0_FA_10 (.A(p[5][7]), .B(p[6][6]), .Cin(p[7][5]), .S(s0[15]), .Cout(c0[15]));
    full_adder  Stage0_FA_11 (.A(p[3][2]), .B(p[4][1]), .Cin(p[5][0]), .S(s0[16]), .Cout(c0[16]));
    full_adder  Stage0_FA_12 (.A(p[3][3]), .B(p[4][2]), .Cin(p[5][1]), .S(s0[17]), .Cout(c0[17]));
    full_adder  Stage0_FA_13 (.A(p[3][4]), .B(p[4][3]), .Cin(p[5][2]), .S(s0[18]), .Cout(c0[18]));
    full_adder  Stage0_FA_14 (.A(p[4][4]), .B(p[5][3]), .Cin(p[6][2]), .S(s0[19]), .Cout(c0[19]));
    full_adder  Stage0_FA_15 (.A(p[5][4]), .B(p[6][3]), .Cin(p[7][2]), .S(s0[20]), .Cout(c0[20]));

    // REVIEW stage 1
    // NOTE half adders 1
    full_adder  Stage1_HA_0 (.A(s0[5]), .B(c0[0]), .Cin(1'b0), .S(s1[0]), .Cout(c1[0]));
    full_adder  Stage1_HA_1 (.A(p[6][0]), .B(c0[16]), .Cin(1'b0), .S(s1[1]), .Cout(c1[1]));
    full_adder  Stage1_HA_2 (.A(s0[2]), .B(c0[17]), .Cin(1'b0), .S(s1[2]), .Cout(c1[2]));
    // NOTE full adders 1
    full_adder  Stage1_FA_0 (.A(s0[6]), .B(c0[5]), .Cin(p[3][0]), .S(s1[3]), .Cout(c1[3]));
    full_adder  Stage1_FA_1 (.A(s0[7]), .B(c0[6]), .Cin(s0[1]), .S(s1[4]), .Cout(c1[4]));
    full_adder  Stage1_FA_2 (.A(s0[8]), .B(c0[7]), .Cin(s0[16]), .S(s1[5]), .Cout(c1[5]));
    full_adder  Stage1_FA_3 (.A(s0[9]), .B(c0[8]), .Cin(s0[17]), .S(s1[6]), .Cout(c1[6]));
    full_adder  Stage1_FA_4 (.A(s0[10]), .B(c0[9]), .Cin(s0[18]), .S(s1[7]), .Cout(c1[7]));
    full_adder  Stage1_FA_5 (.A(s0[11]), .B(c0[10]), .Cin(s0[19]), .S(s1[8]), .Cout(c1[8]));
    full_adder  Stage1_FA_6 (.A(s0[20]), .B(c0[19]), .Cin(s0[12]), .S(s1[9]), .Cout(c1[9]));
    full_adder  Stage1_FA_7 (.A(s0[13]), .B(c0[20]), .Cin(s0[3]), .S(s1[10]), .Cout(c1[10]));
    full_adder  Stage1_FA_8 (.A(s0[14]), .B(c0[13]), .Cin(c0[3]), .S(s1[11]), .Cout(c1[11]));
    full_adder  Stage1_FA_9 (.A(c0[18]), .B(c0[2]), .Cin(p[7][1]), .S(s1[12]), .Cout(c1[12]));

    // REVIEW stage 2
    // NOTE half adders 2
    full_adder  Stage2_HA_0 (.A(s1[3]), .B(c1[0]), .Cin(1'b0), .S(s2[0]), .Cout(c2[0]));
    full_adder  Stage2_HA_1 (.A(s1[4]), .B(c1[3]), .Cin(1'b0), .S(s2[1]), .Cout(c2[1]));
    // NOTE full adders 2
    full_adder  Stage2_FA_0 (.A(s1[5]), .B(c1[4]), .Cin(c0[1]), .S(s2[2]), .Cout(c2[2]));
    full_adder  Stage2_FA_1 (.A(s1[6]), .B(c1[5]), .Cin(s1[1]), .S(s2[3]), .Cout(c2[3]));
    full_adder  Stage2_FA_2 (.A(s1[7]), .B(c1[6]), .Cin(s1[2]), .S(s2[4]), .Cout(c2[4]));
    full_adder  Stage2_FA_3 (.A(s1[8]), .B(c1[7]), .Cin(s1[12]), .S(s2[5]), .Cout(c2[5]));
    full_adder  Stage2_FA_4 (.A(s1[9]), .B(c1[8]), .Cin(c1[12]), .S(s2[6]), .Cout(c2[6]));
    full_adder  Stage2_FA_5 (.A(s1[10]), .B(c1[9]), .Cin(c0[12]), .S(s2[7]), .Cout(c2[7]));
    full_adder  Stage2_FA_6 (.A(s1[11]), .B(c1[10]), .Cin(p[7][4]), .S(s2[8]), .Cout(c2[8]));
    full_adder  Stage2_FA_7 (.A(c1[11]), .B(s0[15]), .Cin(c0[14]), .S(s2[9]), .Cout(c2[9]));

    // REVIEW stage 3
    // NOTE half adders 3
    full_adder  Stage3_HA_0 (.A(s2[1]), .B(c2[0]), .Cin(1'b0), .S(s3[0]), .Cout(c3[0]));
    full_adder  Stage3_HA_1 (.A(s2[2]), .B(c2[1]), .Cin(1'b0), .S(s3[1]), .Cout(c3[1]));
    full_adder  Stage3_HA_2 (.A(s2[3]), .B(c2[2]), .Cin(1'b0), .S(s3[2]), .Cout(c3[2]));
    full_adder  Stage3_HA_3 (.A(s2[7]), .B(c2[6]), .Cin(1'b0), .S(s3[6]), .Cout(c3[6]));
    full_adder  Stage3_HA_4 (.A(s2[8]), .B(c2[7]), .Cin(1'b0), .S(s3[7]), .Cout(c3[7]));
    full_adder  Stage3_HA_5 (.A(s2[9]), .B(c2[8]), .Cin(1'b0), .S(s3[8]), .Cout(c3[8]));
    full_adder  Stage3_HA_6 (.A(c0[4]), .B(p[7][7]), .Cin(1'b0), .S(s3[10]), .Cout(c3[10]));
    // NOTE full adders 3
    full_adder  Stage3_FA_0 (.A(s2[4]), .B(c2[3]), .Cin(c1[1]), .S(s3[3]), .Cout(c3[3]));
    full_adder  Stage3_FA_1 (.A(s2[5]), .B(c2[4]), .Cin(c1[2]), .S(s3[4]), .Cout(c3[4]));
    full_adder  Stage3_FA_2 (.A(s2[6]), .B(c2[5]), .Cin(c0[11]), .S(s3[5]), .Cout(c3[5]));
    full_adder  Stage3_FA_3 (.A(s0[4]), .B(c0[15]), .Cin(c2[9]), .S(s3[9]), .Cout(c3[9]));

    // REVIEW generate the final result
    // OPTION 2
    fast_adder #(11)
    fa (
        .A   ( {1'b0, s3[10:1]} ),
        .B   ( c3[10:0] ),
        .Cin ( 1'b0 ),

        .S ( pout[15:5] ),
        .Cout    ( pout[16] )
    );


    assign o_p = {pout[15:5], s3[0], s2[0], s1[0], s0[0], p[0][0]};
    
endmodule