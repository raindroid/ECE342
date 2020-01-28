/**
 * REVIEW 
 * module wallace_tree_multiplier
 */

module wallace_tree_multiplier_l
(
    input [7: 0] i_m,
    input [7: 0] i_q,

    output [15: 0] o_p
);

    logic [14:0] p0 [7:0];  // level 0 input
    logic [14:0] p1 [5:0];  // level 1 output
    logic [14:0] p2 [3:0];  // level 2 output
    logic [14:0] p3 [2:0];  // level 3 output
    logic [15:0] p4 [1:0];  // level 4 output

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

    // REVIEW level 1 generate p1
    generate
        // NOTE no adder involved
        assign p1[0][0] = p0[0][0];     // p1_0_0
        assign p1[0][9] = p0[2][9];     // p1_0_9
        assign p1[2][3] = p0[3][3];     // p1_2_3
        assign p1[2][12] = p0[5][12];   // p1_2_12
        assign p1[4][13:6] = p0[6][13:6];   // p1 row 4
        assign p1[5][14:7] = p0[7][14:7];   // p1 row 5
        // NOTE 4 HAs
        half_adder  ha_level1_0 ( 
            .A (p0[0][1]),
            .B (p0[1][1]),
            .S (p1[0][1]),
            .Cout    (p1[1][2])
        );
        half_adder  ha_level1_1 ( 
            .A (p0[1][8]),
            .B (p0[2][8]),
            .S (p1[0][8]),
            .Cout    (p1[1][9])
        );
        half_adder  ha_level1_2 ( 
            .A (p0[3][4]),
            .B (p0[4][4]),
            .S (p1[2][4]),
            .Cout    (p1[3][5])
        );
        half_adder  ha_level1_3 ( 
            .A (p0[4][11]),
            .B (p0[5][11]),
            .S (p1[2][11]),
            .Cout    (p1[3][12])
        );
        // NOTE 12 FAs
        for (i = 2; i <= 7; i++) begin: fa_level1_1st_half
            full_adder  fa (  // use the first HA at top right as an example
                .A   (p0[0][i]),  // p0_0_2
                .B   (p0[1][i]),  // p0_1_2
                .Cin (p0[2][i]),  // p0_2_2

                .S(p1[0][i]),  // p1_0_2
                .Cout   (p1[1][i+1])   // p1_1_3
            );
        end
        for (i = 5; i <= 10; i++) begin: fa_level1_2nd_half
            full_adder  fa (  // use the first HA at bottom right as an example
                .A   (p0[3][i]),  // p0_3_5
                .B   (p0[4][i]),  // p0_4_5
                .Cin (p0[5][i]),  // p0_5_5

                .S(p1[2][i]),  // p1_2_5
                .Cout   (p1[3][i+1])   // p1_3_6
            );
        end
    endgenerate

    // REVIEW level 2 generate p2
    generate
        // NOTE no adder used
        assign p2[0][1:0] = p1[0][1:0];
        assign p2[1][12:11] = p1[2][12:11];
        assign p2[0][10] = p1[2][10];
        assign p2[2][5] = p1[3][5];
        assign p2[2][14] = p1[5][14];
        // NOTE 3 HAs
        half_adder  ha_level2_0 ( 
            .A (p1[0][2]),    
            .B (p1[1][2]),
            .S (p2[0][2]),
            .Cout    (p2[1][3])
        );
        half_adder  ha_level2_1 ( 
            .A (p1[3][6]),
            .B (p1[4][6]),
            .S (p2[2][6]),
            .Cout    (p2[3][7])
        );
        half_adder  ha_level2_2 ( 
            .A (p1[4][13]),
            .B (p1[5][13]),
            .S (p2[2][13]),
            .Cout    (p2[3][14])
        );
        // NOTE 13 FAs
        for (i = 3; i <= 9; i++) begin: fa_level2_1st_half
            full_adder  fa (  // use the first HA on top right as an example
                .A   (p1[0][i]),  // p1_0_3
                .B   (p1[1][i]),  // p1_1_3
                .Cin (p1[2][i]),  // p1_2_3

                .S(p2[0][i]),  // p2_0_3
                .Cout   (p2[1][i+1])   // p2_1_4
            );
        end
        for (i = 7; i <= 12; i++) begin: fa_level2_2nd_half
            full_adder  fa (  // use the first HA at bottom right as an example
                .A   (p1[3][i]),  // p1_3_7
                .B   (p1[4][i]),  // p1_4_7
                .Cin (p1[5][i]),  // p1_5_7

                .S(p2[2][i]),  // p2_2_7
                .Cout   (p2[3][i+1])   // p2_3_8
            );
        end
    endgenerate

    // REVIEW level 3 generate p3
    generate
        // NOTE no adder used
        assign p3[0][2:0] = p2[0][2:0];
        assign p3[0][13] = p2[2][13];
        assign p3[1][14] = p2[2][14];
        assign p3[2][14:7] = p2[3][14:7];
        // NOTE 4 HAs
        for (i = 0; i < 2; i++) begin: ha_level3
            half_adder  ha_level3_01 ( // example ha_3_0
                .A (p2[0][i+3]), // p2_0_3
                .B (p2[1][i+3]), // p2_1_3
                .S (p3[0][i+3]),  // p3_0_3
                .Cout    (p3[1][i+4])   // p3_1_4
            );
            half_adder  ha_level3_23 ( // example ha_3_2
                .A (p2[1][i+11]), // p2_1_11
                .B (p2[2][i+11]), // p2_2_11
                .S (p3[0][i+11]),  // p3_0_11
                .Cout    (p3[1][i+12])   // p3_1_12
            );
        end
        // NOTE 6 FAs
        for (i = 5; i <= 10; i++) begin: fa_level3
            full_adder  fa (  // use the first HA at the right as an example
                .A   (p2[0][i]),  // p2_0_5
                .B   (p2[1][i]),  // p2_1_5
                .Cin (p2[2][i]),  // p2_2_5

                .S(p3[0][i]),  // p3_0_5
                .Cout   (p3[1][i+1])   // p3_1_6
            );
        end
    endgenerate

    // REVIEW level 4 generate p4
    generate
        // NOTE no adder used
        assign p4[0][3:0] = p3[0][3:0];
        // NOTE 4 HAs
        for (i = 4; i <= 6; i++) begin: ha_level4
            half_adder  ha_level4_012 ( // example ha_4_0
                .A (p3[0][i]), // p3_0_4
                .B (p3[1][i]), // p3_1_4
                .S (p4[0][i]),  // p4_0_4
                .Cout    (p4[1][i+1])   // p4_1_5
            );
        end
        half_adder  ha_level4_3 (
            .A (p3[1][14]), 
            .B (p3[2][14]), 
            .S (p4[0][14]),  
            .Cout    (p4[1][15])   
        );
        // NOTE 7 FAs
        for (i = 7; i <= 13; i++) begin: fa_level4
            full_adder  fa (  // use the first HA at the right as an example
                .A   (p3[0][i]),  // p3_0_7
                .B   (p3[1][i]),  // p3_1_7
                .Cin (p3[2][i]),  // p3_2_7

                .S(p4[0][i]),  // p4_0_7
                .Cout   (p4[1][i+1])   // p4_1_8
            );
        end
    endgenerate

    // REVIEW generate the final result
    generate
        // NOTE filled the ending of p4[1] with 0s
        assign p4[1][4:0] = 5'b0;
        assign p4[0][15] = 0;

        logic carry[16:0];
        assign carry[0] = 0;

        // OPTION 1
        // fast_adder #(8)
        // fa (
        //     .A   ( p4[0][7:0] ),
        //     .B   ( p4[1][7:0] ),
        //     .Cin ( carry[0] ),

        //     .S ( pout[7:0] ),
        //     .Cout    ( carry[1] )
        // );
        // fast_adder #(8)
        // fa2 (
        //     .A   ( p4[0][15:8] ),
        //     .B   ( p4[1][15:8] ),
        //     .Cin ( carry[1] ),

        //     .S ( pout[15:8] ),
        //     .Cout    ( carry[2] )
        // );

        // OPTION 2
        fast_adder #(16)
        fa (
            .A   ( p4[0] ),
            .B   ( p4[1] ),
            .Cin ( 1'b0 ),

            .S ( pout[15:0] ),
            .Cout    ( pout[16] )
        );

        // OPTION 3
        // for (i = 0; i <= 15; i++) begin: output_fas
        //     full_adder  fa (  // use the first HA at the right as an example
        //         .A   (p4[0][i]),  // p4_0_0
        //         .B   (p4[1][i]),  // p4_1_0
        //         .Cin (carry[i]),  // carry_0

        //         .S(pout[i]),  // p3_0_7
        //         .Cout   (carry[i+1])   // p3_1_8
        //     );
        // end

    endgenerate

    assign o_p = pout[15:0];
    
endmodule