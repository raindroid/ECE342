module game 
(
	input clk,
	input reset,
	
	input [7:0] i_guess,
	input i_enter,
	
	output o_under,
	output o_over,
	output o_equal,
	output o_update_leds
);
	// Datapath
	logic dp_inc_actual;
	logic dp_over;
	logic dp_under;
	logic dp_equal;
	datapath the_datapath
	(
		.clk(clk),
		.reset(reset),
		.i_guess(i_guess),
		.i_inc_actual(dp_inc_actual),
		.o_over(dp_over),
		.o_under(dp_under),
		.o_equal(dp_equal)
	);
	
	// State Machine
	control the_control
	(
		.clk(clk),
		.reset(reset),
		.i_enter(i_enter),
		.o_inc_actual(dp_inc_actual),
		.i_over(dp_over),
		.i_under(dp_under),
		.i_equal(dp_equal),
		.o_update_leds(o_update_leds)
	);
	
	assign o_under = dp_under;
	assign o_over = dp_over;
	assign o_equal = dp_equal;
endmodule