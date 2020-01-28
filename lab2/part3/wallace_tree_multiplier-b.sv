/**
 * REVIEW 
 * module wallace_tree_multiplier
 */

module wallace_tree_multiplier_b
(
    input [7: 0] i_m,
    input [7: 0] i_q,

    output [15: 0] o_p
);

    logic [14:0] p0 [7:0];  // stage 0 input
    logic [14:0] p1 [5:0];  // stage 1 output
    logic [14:0] p2 [3:0];  // stage 2 output
    logic [14:0] p3 [2:0];  // stage 3 output
    logic [15:0] p4 [1:0];  // stage 4 output

    logic [16: 0] pout; // final result
    
    genvar i, j;


    // NOTE generate p0
    generate
        for (i = 0; i < 8; i++) begin: p0_rows
            for (j = 0; j < 8; j++) begin: p0_cells
                assign p0[i][j + i] = i_m[i] & i_q[j];                
            end
        end
    endgenerate 

    // REVIEW stage 1 generated p1 (code by wtm.py)
    // NOTE no adder involved
    assign p1[0][0] = p0[0][0]; // p1_0_0
    assign p1[0][9] = p0[2][9]; // p1_0_9
    assign p1[2][3] = p0[3][3]; // p1_2_3
    assign p1[2][12] = p0[5][12];       // p1_2_12
    assign p1[4][13:6] = p0[6][13:6];   // p1 row 4
    assign p1[5][14:7] = p0[7][14:7];   // p1 row 5
    // NOTE 4 HAs
    half_adder  ha_stage1_0 (.A(p0[0][1]), .B(p0[1][1]), .S(p1[0][1]), .Cout(p1[1][2]));
    half_adder  ha_stage1_1 (.A(p0[1][8]), .B(p0[2][8]), .S(p1[0][8]), .Cout(p1[1][9]));
    half_adder  ha_stage1_2 (.A(p0[3][4]), .B(p0[4][4]), .S(p1[2][4]), .Cout(p1[3][5]));
    half_adder  ha_stage1_3 (.A(p0[4][11]), .B(p0[5][11]), .S(p1[2][11]), .Cout(p1[3][12]));
    // NOTE 12 FAs
    full_adder  fa_stage1_0 (.A(p0[0][2]), .B(p0[1][2]), .Cin(p0[2][2]), .S(p1[0][2]), .Cout(p1[1][3]));
    full_adder  fa_stage1_1 (.A(p0[0][3]), .B(p0[1][3]), .Cin(p0[2][3]), .S(p1[0][3]), .Cout(p1[1][4]));
    full_adder  fa_stage1_2 (.A(p0[0][4]), .B(p0[1][4]), .Cin(p0[2][4]), .S(p1[0][4]), .Cout(p1[1][5]));
    full_adder  fa_stage1_3 (.A(p0[0][5]), .B(p0[1][5]), .Cin(p0[2][5]), .S(p1[0][5]), .Cout(p1[1][6]));
    full_adder  fa_stage1_4 (.A(p0[0][6]), .B(p0[1][6]), .Cin(p0[2][6]), .S(p1[0][6]), .Cout(p1[1][7]));
    full_adder  fa_stage1_5 (.A(p0[0][7]), .B(p0[1][7]), .Cin(p0[2][7]), .S(p1[0][7]), .Cout(p1[1][8]));
    full_adder  fa_stage1_6 (.A(p0[3][5]), .B(p0[4][5]), .Cin(p0[5][5]), .S(p1[2][5]), .Cout(p1[3][6]));
    full_adder  fa_stage1_7 (.A(p0[3][6]), .B(p0[4][6]), .Cin(p0[5][6]), .S(p1[2][6]), .Cout(p1[3][7]));
    full_adder  fa_stage1_8 (.A(p0[3][7]), .B(p0[4][7]), .Cin(p0[5][7]), .S(p1[2][7]), .Cout(p1[3][8]));
    full_adder  fa_stage1_9 (.A(p0[3][8]), .B(p0[4][8]), .Cin(p0[5][8]), .S(p1[2][8]), .Cout(p1[3][9]));
    full_adder  fa_stage1_10 (.A(p0[3][9]), .B(p0[4][9]), .Cin(p0[5][9]), .S(p1[2][9]), .Cout(p1[3][10]));
    full_adder  fa_stage1_11 (.A(p0[3][10]), .B(p0[4][10]), .Cin(p0[5][10]), .S(p1[2][10]), .Cout(p1[3][11]));

    // REVIEW stage 1 generated p1 (code by wtm.py)
    // NOTE no adder involved
    assign p2[0][1:0] = p1[0][1:0];
    assign p2[1][12:11] = p1[2][12:11];
    assign p2[0][10] = p1[2][10];
    assign p2[2][5] = p1[3][5];
    assign p2[2][14] = p1[5][14];
    // NOTE 3 HAs
    half_adder  ha_stage2_0 (.A(p1[0][2]), .B(p1[1][2]), .S(p2[0][2]), .Cout(p2[1][3]));
    half_adder  ha_stage2_1 (.A(p1[3][6]), .B(p1[4][6]), .S(p2[2][6]), .Cout(p2[3][7]));
    half_adder  ha_stage2_2 (.A(p1[4][13]), .B(p1[5][13]), .S(p2[2][13]), .Cout(p2[3][14]));
    // NOTE 13 FAs
    full_adder  fa_stage2_0 (.A(p1[0][3]), .B(p1[1][3]), .Cin(p1[2][3]), .S(p2[0][3]), .Cout(p2[1][4]));
    full_adder  fa_stage2_1 (.A(p1[0][4]), .B(p1[1][4]), .Cin(p1[2][4]), .S(p2[0][4]), .Cout(p2[1][5]));
    full_adder  fa_stage2_2 (.A(p1[0][5]), .B(p1[1][5]), .Cin(p1[2][5]), .S(p2[0][5]), .Cout(p2[1][6]));
    full_adder  fa_stage2_3 (.A(p1[0][6]), .B(p1[1][6]), .Cin(p1[2][6]), .S(p2[0][6]), .Cout(p2[1][7]));
    full_adder  fa_stage2_4 (.A(p1[0][7]), .B(p1[1][7]), .Cin(p1[2][7]), .S(p2[0][7]), .Cout(p2[1][8]));
    full_adder  fa_stage2_5 (.A(p1[0][8]), .B(p1[1][8]), .Cin(p1[2][8]), .S(p2[0][8]), .Cout(p2[1][9]));
    full_adder  fa_stage2_6 (.A(p1[0][9]), .B(p1[1][9]), .Cin(p1[2][9]), .S(p2[0][9]), .Cout(p2[1][10]));
    full_adder  fa_stage2_7 (.A(p1[3][7]), .B(p1[4][7]), .Cin(p1[5][7]), .S(p2[2][7]), .Cout(p2[3][8]));
    full_adder  fa_stage2_8 (.A(p1[3][8]), .B(p1[4][8]), .Cin(p1[5][8]), .S(p2[2][8]), .Cout(p2[3][9]));
    full_adder  fa_stage2_9 (.A(p1[3][9]), .B(p1[4][9]), .Cin(p1[5][9]), .S(p2[2][9]), .Cout(p2[3][10]));
    full_adder  fa_stage2_10 (.A(p1[3][10]), .B(p1[4][10]), .Cin(p1[5][10]), .S(p2[2][10]), .Cout(p2[3][11]));
    full_adder  fa_stage2_11 (.A(p1[3][11]), .B(p1[4][11]), .Cin(p1[5][11]), .S(p2[2][11]), .Cout(p2[3][12]));
    full_adder  fa_stage2_12 (.A(p1[3][12]), .B(p1[4][12]), .Cin(p1[5][12]), .S(p2[2][12]), .Cout(p2[3][13]));

    // REVIEW stage 3 generated p3 (code by wtm.py)
    // NOTE no adder involved
    assign p3[0][2:0] = p2[0][2:0];
    assign p3[0][13] = p2[2][13];
    assign p3[1][14] = p2[2][14];
    assign p3[2][14:7] = p2[3][14:7];
    // NOTE 4 HAs
    half_adder  ha_stage3_0 (.A(p2[0][3]), .B(p2[1][3]), .S(p3[0][3]), .Cout(p3[1][4]));
    half_adder  ha_stage3_1 (.A(p2[0][4]), .B(p2[1][4]), .S(p3[0][4]), .Cout(p3[1][5]));
    half_adder  ha_stage3_2 (.A(p2[1][11]), .B(p2[2][11]), .S(p3[0][11]), .Cout(p3[1][12]));
    half_adder  ha_stage3_3 (.A(p2[1][12]), .B(p2[2][12]), .S(p3[0][12]), .Cout(p3[1][13]));
    // NOTE 6 FAs
    full_adder  fa_stage3_0 (.A(p2[0][5]), .B(p2[1][5]), .Cin(p2[2][5]), .S(p3[0][5]), .Cout(p3[1][6]));
    full_adder  fa_stage3_1 (.A(p2[0][6]), .B(p2[1][6]), .Cin(p2[2][6]), .S(p3[0][6]), .Cout(p3[1][7]));
    full_adder  fa_stage3_2 (.A(p2[0][7]), .B(p2[1][7]), .Cin(p2[2][7]), .S(p3[0][7]), .Cout(p3[1][8]));
    full_adder  fa_stage3_3 (.A(p2[0][8]), .B(p2[1][8]), .Cin(p2[2][8]), .S(p3[0][8]), .Cout(p3[1][9]));
    full_adder  fa_stage3_4 (.A(p2[0][9]), .B(p2[1][9]), .Cin(p2[2][9]), .S(p3[0][9]), .Cout(p3[1][10]));
    full_adder  fa_stage3_5 (.A(p2[0][10]), .B(p2[1][10]), .Cin(p2[2][10]), .S(p3[0][10]), .Cout(p3[1][11]));

    // REVIEW stage 4 generated p4 (code by wtm.py)
    // NOTE no adder involved
    assign p4[0][3:0] = p3[0][3:0];
    // NOTE 4 HAs
    half_adder  ha_stage4_0 (.A(p3[0][4]), .B(p3[1][4]), .S(p4[0][4]), .Cout(p4[1][5]));
    half_adder  ha_stage4_1 (.A(p3[0][5]), .B(p3[1][5]), .S(p4[0][5]), .Cout(p4[1][6]));
    half_adder  ha_stage4_2 (.A(p3[0][6]), .B(p3[1][6]), .S(p4[0][6]), .Cout(p4[1][7]));
    half_adder  ha_stage4_3 (.A(p3[1][14]), .B(p3[2][14]), .S(p4[0][14]), .Cout(p4[1][15]));
    // NOTE 6 FAs
    full_adder  fa_stage4_0 (.A(p3[0][7]), .B(p3[1][7]), .Cin(p3[2][7]), .S(p4[0][7]), .Cout(p4[1][8]));
    full_adder  fa_stage4_1 (.A(p3[0][8]), .B(p3[1][8]), .Cin(p3[2][8]), .S(p4[0][8]), .Cout(p4[1][9]));
    full_adder  fa_stage4_2 (.A(p3[0][9]), .B(p3[1][9]), .Cin(p3[2][9]), .S(p4[0][9]), .Cout(p4[1][10]));
    full_adder  fa_stage4_3 (.A(p3[0][10]), .B(p3[1][10]), .Cin(p3[2][10]), .S(p4[0][10]), .Cout(p4[1][11]));
    full_adder  fa_stage4_4 (.A(p3[0][11]), .B(p3[1][11]), .Cin(p3[2][11]), .S(p4[0][11]), .Cout(p4[1][12]));
    full_adder  fa_stage4_5 (.A(p3[0][12]), .B(p3[1][12]), .Cin(p3[2][12]), .S(p4[0][12]), .Cout(p4[1][13]));
    full_adder  fa_stage4_6 (.A(p3[0][13]), .B(p3[1][13]), .Cin(p3[2][13]), .S(p4[0][13]), .Cout(p4[1][14]));


    // REVIEW generate the final result
    generate
        // NOTE filled the ending of pout (no adder needed)
        assign pout[4:0] = p4[0][4:0];
        assign p4[0][15] = 1'b0;

        // OPTION 2
        fast_adder #(11)
        fa (
            .A   ( p4[0][15:5] ),
            .B   ( p4[1][15:5] ),
            .Cin ( 1'b0 ),

            .S ( pout[15:5] ),
            .Cout    ( pout[16] )
        );

    endgenerate

    assign o_p = pout[15:0];
    
endmodule