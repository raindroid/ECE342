module de1soc_top 
(
	// These are the board inputs/outputs required for all the ECE342 labs.
	// Each lab can use the subset it needs -- unused pins will be ignored.
	
    // Clock pins
    input                     CLOCK_50,

    // Seven Segment Displays
    output      [6:0]         HEX0,
    output      [6:0]         HEX1,
    output      [6:0]         HEX2,
    output      [6:0]         HEX3,
    output      [6:0]         HEX4,
    output      [6:0]         HEX5,

    // Pushbuttons
    input       [3:0]         KEY,

    // LEDs
    output      [9:0]         LEDR,

    // Slider Switches
    input       [9:0]         SW,

    // VGA
    output      [7:0]         VGA_B,
    output                    VGA_BLANK_N,
    output                    VGA_CLK,
    output      [7:0]         VGA_G,
    output                    VGA_HS,
    output      [7:0]         VGA_R,
    output                    VGA_SYNC_N,
    output                    VGA_VS
);

// This generates a one-time ACTIVE-LOW asynchronous reset
// signal on powerup. You can use it for the Qsys system.
logic reset_n;
logic [1:0] reset_reg = 2'b00;
always_ff @ (posedge CLOCK_50) begin
	reset_n <= reset_reg[0];
	reset_reg <= {1'b1, reset_reg[1]};
end

    logic [9:0] test;
	processor u0 (
		.clk_clk          (CLOCK_50),          //       clk.clk
		.reset_reset_n    (reset_n & KEY[0]),    //     reset.reset_n
		.sw_i_export      (SW),      //      sw_i.export
		.led_o_export     (LEDR),     //     led_o.export
		.quad_hex3_export (HEX3), // quad_hex3.export
		.quad_hex2_export (HEX2), // quad_hex2.export
		.quad_hex1_export (HEX1), // quad_hex1.export
		.quad_hex0_export (HEX0)  // quad_hex0.export
	);



endmodule