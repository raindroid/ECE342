
module nios_system (
	clk_clk,
	leds_export,
	reset_reset_n,
	switches_export,
	lda_vga_b_export,
	lda_vga_blank_n_export,
	lda_vga_clk_export,
	lda_vga_g_export,
	lda_vga_hs_export,
	lda_vga_r_export,
	lda_vga_sync_n_export,
	lda_vga_vs_export);	

	input		clk_clk;
	output	[7:0]	leds_export;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	output	[7:0]	lda_vga_b_export;
	output		lda_vga_blank_n_export;
	output		lda_vga_clk_export;
	output	[7:0]	lda_vga_g_export;
	output		lda_vga_hs_export;
	output	[7:0]	lda_vga_r_export;
	output		lda_vga_sync_n_export;
	output		lda_vga_vs_export;
endmodule
