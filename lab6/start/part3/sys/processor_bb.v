
module processor (
	clk_clk,
	lda_vga_b_export,
	lda_vga_blank_n_export,
	lda_vga_clk_export,
	lda_vga_g_export,
	lda_vga_hs_export,
	lda_vga_r_export,
	lda_vga_sync_n_export,
	lda_vga_vs_export,
	led_o_export,
	quad_hex0_export,
	quad_hex1_export,
	quad_hex2_export,
	quad_hex3_export,
	reset_reset_n,
	sw_i_export);	

	input		clk_clk;
	output	[7:0]	lda_vga_b_export;
	output		lda_vga_blank_n_export;
	output		lda_vga_clk_export;
	output	[7:0]	lda_vga_g_export;
	output		lda_vga_hs_export;
	output	[7:0]	lda_vga_r_export;
	output		lda_vga_sync_n_export;
	output		lda_vga_vs_export;
	output	[9:0]	led_o_export;
	output	[6:0]	quad_hex0_export;
	output	[6:0]	quad_hex1_export;
	output	[6:0]	quad_hex2_export;
	output	[6:0]	quad_hex3_export;
	input		reset_reset_n;
	input	[9:0]	sw_i_export;
endmodule
