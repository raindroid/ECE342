module wallace_tree_multiplier_s
(
	input [7:0] i_m,
	input [7:0] i_q,

	output [15:0] o_p
);
	
	logic [7:0][7:0] p;

	genvar row;
	genvar col;

	generate
		for (row = 0; row < 8; row++) begin : partial_product_rows
			for (col = 0; col < 8; col ++) begin : partial_product_cols
				assign p[row][col] = i_m[row] & i_q[col];
			end
		end
	endgenerate

	// Stage 0
	logic [20:0] s0;
	logic [20:0] c0;
	// Stage 1
	logic [12:0] s1;
	logic [12:0] c1;
	// Stage 2
	logic [9:0] s2;
	logic [9:0] c2;
	// Stage 3
	logic [10:0] s3;
	logic [10:0] c3;

	full_adder full_adder0_0 (p[0][1], p[1][0], 0, s0[0], c0[0]); 
	full_adder full_adder0_1 (p[0][2], p[1][1], p[2][0], s0[1], c0[1]);
	full_adder full_adder0_2 (p[0][3], p[1][2], p[2][1], s0[2], c0[2]);
	full_adder full_adder0_3 (p[0][4], p[1][3], p[2][2], s0[3], c0[3]);
	full_adder full_adder0_4 (p[3][1], p[4][0], 0, s0[4], c0[4]);
	full_adder full_adder0_5 (p[0][5], p[1][4], p[2][3], s0[5], c0[5]);
	full_adder full_adder0_6 (p[3][2], p[4][1], p[5][0], s0[6], c0[6]); 
	full_adder full_adder0_7 (p[0][6], p[1][5], p[2][4], s0[7], c0[7]); 
	full_adder full_adder0_8 (p[3][3], p[4][2], p[5][1], s0[8], c0[8]); 
	full_adder full_adder0_9 (p[0][7], p[1][6], p[2][5], s0[9], c0[9]); 
	full_adder full_adder0_10 (p[3][4], p[4][3], p[5][2], s0[10], c0[10]); 
	full_adder full_adder0_11 (p[6][1], p[7][0], 0, s0[11], c0[11]); 
	full_adder full_adder0_12 (p[1][7], p[2][6], p[3][5], s0[12], c0[12]); 
	full_adder full_adder0_13 (p[4][4], p[5][3], p[6][2], s0[13], c0[13]); 
	full_adder full_adder0_14 (p[2][7], p[3][6], p[4][5], s0[14], c0[14]); 
	full_adder full_adder0_15 (p[5][4], p[6][3], p[7][2], s0[15], c0[15]); 
	full_adder full_adder0_16 (p[3][7], p[4][6], p[5][5], s0[16], c0[16]); 
	full_adder full_adder0_17 (p[6][4], p[7][3], 0, s0[17], c0[17]); 
	full_adder full_adder0_18 (p[4][7], p[5][6], p[6][5], s0[18], c0[18]); 
	full_adder full_adder0_19 (p[5][7], p[6][6], p[7][5], s0[19], c0[19]);
	full_adder full_adder0_20 (p[6][7], p[7][6], 0, s0[20], c0[20]);


	full_adder full_adder1_0(c0[0], s0[1], 0, s1[0], c1[0]); 
	full_adder full_adder1_1(c0[1], s0[2], p[3][0], s1[1], c1[1]); 
	full_adder full_adder1_2(c0[2], s0[3], s0[4], s1[2], c1[2]); 
	full_adder full_adder1_3(c0[3], c0[4], s0[5], s1[3], c1[3]); 
	full_adder full_adder1_4(c0[5], c0[6], s0[7], s1[4], c1[4]); 
	full_adder full_adder1_5(s0[8], p[6][0], 0, s1[5], c1[5]); 
	full_adder full_adder1_6(c0[7], c0[8], s0[9], s1[6], c1[6]); 
	full_adder full_adder1_7(s0[10], s0[11], 0, s1[7], c1[7]); 
	full_adder full_adder1_8(c0[9], c0[10], c0[11], s1[8], c1[8]); 
	full_adder full_adder1_9(s0[12], s0[13], p[7][1], s1[9], c1[9]); 
	full_adder full_adder1_10(c0[12], c0[13], s0[14], s1[10], c1[10]); 
	full_adder full_adder1_11(c0[14], c0[15], s0[16], s1[11], c1[11]); 
	full_adder full_adder1_12(c0[16], c0[17], s0[18], s1[12], c1[12]); 


	full_adder full_adder2_0(c1[0], s1[1], 0, s2[0], c2[0]); 
	full_adder full_adder2_1(c1[1], s1[2], 0, s2[1], c2[1]); 
	full_adder full_adder2_2(c1[2], s1[3], s0[6], s2[2], c2[2]); 
	full_adder full_adder2_3(c1[3], s1[4], s1[5], s2[3], c2[3]); 
	full_adder full_adder2_4(c1[4], c1[5], s1[6], s2[4], c2[4]); 
	full_adder full_adder2_5(c1[6], c1[7], s1[8], s2[5], c2[5]); 
	full_adder full_adder2_6(c1[8], c1[9], s1[10], s2[6], c2[6]); 
	full_adder full_adder2_7(c1[10], s1[11], s0[17], s2[7], c2[7]); 
	full_adder full_adder2_8(c1[11], s1[12], p[7][4], s2[8], c2[8]); 
	full_adder full_adder2_9(c1[12], c0[18], s0[19], s2[9], c2[9]);


	full_adder full_adder3_0(c2[0], s2[1], 0, s3[0], c3[0]); 
	full_adder full_adder3_1(c2[1], s2[2], 0, s3[1], c3[1]); 
	full_adder full_adder3_2(c2[2], s2[3], 0, s3[2], c3[2]); 
	full_adder full_adder3_3(c2[3], s2[4], s1[7], s3[3], c3[3]); 
	full_adder full_adder3_4(c2[4], s2[5], s1[9], s3[4], c3[4]); 
	full_adder full_adder3_5(c2[5], s2[6], s0[15], s3[5], c3[5]); 
	full_adder full_adder3_6(c2[6], s2[7], 0, s3[6], c3[6]); 
	full_adder full_adder3_7(c2[7], s2[8], 0, s3[7], c3[7]); 
	full_adder full_adder3_8(c2[8], s2[9], 0, s3[8], c3[8]); 
	full_adder full_adder3_9(c2[9], c0[19], s0[20], s3[9], c3[9]); 
	full_adder full_adder3_10(c0[20], p[7][7], 0, s3[10], c3[10]);

	// Stage 4
	logic [11:0] s_adder;
	fast_adder # (11) m_cla (
		.A   (c3[10:0]),
		.B   ({1'b0, s3[10:1]}),
		.Cin (1'b0),

		.S (s_adder[10:0]),
		.Cout(s_adder[11])
	);

	assign o_p = {s_adder[10:0], s3[0], s2[0], s1[0], s0[0], p[0][0]};

endmodule