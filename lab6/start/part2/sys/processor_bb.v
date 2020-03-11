
module processor (
	clk_clk,
	led_o_export,
	quad_hex0_export,
	quad_hex1_export,
	quad_hex2_export,
	quad_hex3_export,
	reset_reset_n,
	sw_i_export);	

	input		clk_clk;
	output	[9:0]	led_o_export;
	output	[6:0]	quad_hex0_export;
	output	[6:0]	quad_hex1_export;
	output	[6:0]	quad_hex2_export;
	output	[6:0]	quad_hex3_export;
	input		reset_reset_n;
	input	[9:0]	sw_i_export;
endmodule
