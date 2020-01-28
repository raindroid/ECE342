module wallace_tree_multiplier
(
	input [7:0] i_m,
	input [7:0] i_q,

	output [15:0] o_p
);
	
	logic [7:0][7:0] p_partial;

	genvar row;
	genvar col;

	generate
		for (row = 0; row < 8; row++) begin : partial_product_row
			for (col = 0; col < 8; col ++) begin : partial_product_col
				assign p_partial[row][col] = i_m[row] & i_q[col];
			end
		end
	endgenerate

	// Stage 0
	logic [20:0] s_s0;
	logic [20:0] cout_s0;

	full_adder full_adder0_0 (p_partial[0][1], p_partial[1][0], 0, s_s0[0], cout_s0[0]); 
	full_adder full_adder0_1 (p_partial[0][2], p_partial[1][1], p_partial[2][0], s_s0[1], cout_s0[1]);
	full_adder full_adder0_2 (p_partial[0][3], p_partial[1][2], p_partial[2][1], s_s0[2], cout_s0[2]);
	full_adder full_adder0_3 (p_partial[0][4], p_partial[1][3], p_partial[2][2], s_s0[3], cout_s0[3]);
	full_adder full_adder0_4 (p_partial[3][1], p_partial[4][0], 0, s_s0[4], cout_s0[4]);
	full_adder full_adder0_5 (p_partial[0][5], p_partial[1][4], p_partial[2][3], s_s0[5], cout_s0[5]);
	full_adder full_adder0_6 (p_partial[3][2], p_partial[4][1], p_partial[5][0], s_s0[6], cout_s0[6]); 
	full_adder full_adder0_7 (p_partial[0][6], p_partial[1][5], p_partial[2][4], s_s0[7], cout_s0[7]); 
	full_adder full_adder0_8 (p_partial[3][3], p_partial[4][2], p_partial[5][1], s_s0[8], cout_s0[8]); 
	full_adder full_adder0_9 (p_partial[0][7], p_partial[1][6], p_partial[2][5], s_s0[9], cout_s0[9]); 
	full_adder full_adder0_10 (p_partial[3][4], p_partial[4][3], p_partial[5][2], s_s0[10], cout_s0[10]); 
	full_adder full_adder0_11 (p_partial[6][1], p_partial[7][0], 0, s_s0[11], cout_s0[11]); 
	full_adder full_adder0_12 (p_partial[1][7], p_partial[2][6], p_partial[3][5], s_s0[12], cout_s0[12]); 
	full_adder full_adder0_13 (p_partial[4][4], p_partial[5][3], p_partial[6][2], s_s0[13], cout_s0[13]); 
	full_adder full_adder0_14 (p_partial[2][7], p_partial[3][6], p_partial[4][5], s_s0[14], cout_s0[14]); 
	full_adder full_adder0_15 (p_partial[5][4], p_partial[6][3], p_partial[7][2], s_s0[15], cout_s0[15]); 
	full_adder full_adder0_16 (p_partial[3][7], p_partial[4][6], p_partial[5][5], s_s0[16], cout_s0[16]); 
	full_adder full_adder0_17 (p_partial[6][4], p_partial[7][3], 0, s_s0[17], cout_s0[17]); 
	full_adder full_adder0_18 (p_partial[4][7], p_partial[5][6], p_partial[6][5], s_s0[18], cout_s0[18]); 
	full_adder full_adder0_19 (p_partial[5][7], p_partial[6][6], p_partial[7][5], s_s0[19], cout_s0[19]);
	full_adder full_adder0_20 (p_partial[6][7], p_partial[7][6], 0, s_s0[20], cout_s0[20]);

	// Stage 1
	logic [12:0] s_s1;
	logic [12:0] cout_s1;

	full_adder full_adder1_0(cout_s0[0], s_s0[1], 0, s_s1[0], cout_s1[0]); 
	full_adder full_adder1_1(cout_s0[1], s_s0[2], p_partial[3][0], s_s1[1], cout_s1[1]); 
	full_adder full_adder1_2(cout_s0[2], s_s0[3], s_s0[4], s_s1[2], cout_s1[2]); 
	full_adder full_adder1_3(cout_s0[3], cout_s0[4], s_s0[5], s_s1[3], cout_s1[3]); 
	full_adder full_adder1_4(cout_s0[5], cout_s0[6], s_s0[7], s_s1[4], cout_s1[4]); 
	full_adder full_adder1_5(s_s0[8], p_partial[6][0], 0, s_s1[5], cout_s1[5]); 
	full_adder full_adder1_6(cout_s0[7], cout_s0[8], s_s0[9], s_s1[6], cout_s1[6]); 
	full_adder full_adder1_7(s_s0[10], s_s0[11], 0, s_s1[7], cout_s1[7]); 
	full_adder full_adder1_8(cout_s0[9], cout_s0[10], cout_s0[11], s_s1[8], cout_s1[8]); 
	full_adder full_adder1_9(s_s0[12], s_s0[13], p_partial[7][1], s_s1[9], cout_s1[9]); 
	full_adder full_adder1_10(cout_s0[12], cout_s0[13], s_s0[14], s_s1[10], cout_s1[10]); 
	full_adder full_adder1_11(cout_s0[14], cout_s0[15], s_s0[16], s_s1[11], cout_s1[11]); 
	full_adder full_adder1_12(cout_s0[16], cout_s0[17], s_s0[18], s_s1[12], cout_s1[12]); 

	// Stage 2
	logic [9:0] s_s2;
	logic [9:0] cout_s2;

	full_adder full_adder2_0(cout_s1[0], s_s1[1], 0, s_s2[0], cout_s2[0]); 
	full_adder full_adder2_1(cout_s1[1], s_s1[2], 0, s_s2[1], cout_s2[1]); 
	full_adder full_adder2_2(cout_s1[2], s_s1[3], s_s0[6], s_s2[2], cout_s2[2]); 
	full_adder full_adder2_3(cout_s1[3], s_s1[4], s_s1[5], s_s2[3], cout_s2[3]); 
	full_adder full_adder2_4(cout_s1[4], cout_s1[5], s_s1[6], s_s2[4], cout_s2[4]); 
	full_adder full_adder2_5(cout_s1[6], cout_s1[7], s_s1[8], s_s2[5], cout_s2[5]); 
	full_adder full_adder2_6(cout_s1[8], cout_s1[9], s_s1[10], s_s2[6], cout_s2[6]); 
	full_adder full_adder2_7(cout_s1[10], s_s1[11], s_s0[17], s_s2[7], cout_s2[7]); 
	full_adder full_adder2_8(cout_s1[11], s_s1[12], p_partial[7][4], s_s2[8], cout_s2[8]); 
	full_adder full_adder2_9(cout_s1[12], cout_s0[18], s_s0[19], s_s2[9], cout_s2[9]);

	// Stage 3
	logic [10:0] s_s3;
	logic [10:0] cout_s3;

	full_adder full_adder3_0(cout_s2[0], s_s2[1], 0, s_s3[0], cout_s3[0]); 
	full_adder full_adder3_1(cout_s2[1], s_s2[2], 0, s_s3[1], cout_s3[1]); 
	full_adder full_adder3_2(cout_s2[2], s_s2[3], 0, s_s3[2], cout_s3[2]); 
	full_adder full_adder3_3(cout_s2[3], s_s2[4], s_s1[7], s_s3[3], cout_s3[3]); 
	full_adder full_adder3_4(cout_s2[4], s_s2[5], s_s1[9], s_s3[4], cout_s3[4]); 
	full_adder full_adder3_5(cout_s2[5], s_s2[6], s_s0[15], s_s3[5], cout_s3[5]); 
	full_adder full_adder3_6(cout_s2[6], s_s2[7], 0, s_s3[6], cout_s3[6]); 
	full_adder full_adder3_7(cout_s2[7], s_s2[8], 0, s_s3[7], cout_s3[7]); 
	full_adder full_adder3_8(cout_s2[8], s_s2[9], 0, s_s3[8], cout_s3[8]); 
	full_adder full_adder3_9(cout_s2[9], cout_s0[19], s_s0[20], s_s3[9], cout_s3[9]); 
	full_adder full_adder3_10(cout_s0[20], p_partial[7][7], 0, s_s3[10], cout_s3[10]);

	// Stage 4
	logic [11:0] s_adder;
	carry_lookahead_adder_n # (.WIDTH(11)) m_cla (
		.i_a   (cout_s3[10:0]),
		.i_b   ({1'b0, s_s3[10:1]}),
		.i_cin (1'b0),

		.o_sum (s_adder[10:0]),
		.o_cout(s_adder[11])
	);

	assign o_p = {s_adder[10:0], s_s3[0], s_s2[0], s_s1[0], s_s0[0], p_partial[0][0]};

endmodule : wallace_tree_multiplier