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
	// Clock signal
	wire clk = CLOCK_50;
	
	// KEYs are active low, invert them here
	wire reset = ~KEY[0];
	wire enter = ~KEY[1];
	
	// Number guess input
	wire [7:0] guess = SW[7:0];
	
	// The actual game module
	wire under;
	wire over;
	wire equal;
	wire update_leds;
	wire [3:0] remaining_attempts;	// REVIEW display the remaining attempts
	game game_inst
	(
		.clk(clk),
		.reset(reset),
		.i_guess(guess),
		.i_enter(enter),
		.o_under(under),
		.o_over(over),
		.o_equal(equal),
		.o_update_leds(update_leds),
		.o_remaining_attempts(remaining_attempts) // REVIEW the remaining attempts
	);
	
	// LED controllers
	led_ctrl ledc_under(clk, reset, under, update_leds, LEDR[7]);
	led_ctrl ledc_over(clk, reset, over, update_leds, LEDR[0]);
	led_ctrl ledc_equal(clk, reset, equal, update_leds, LEDR[4]);
	
	// Hex Decoders
	hex_decoder hexdec_guess0
	(
		.hex_digit(guess[3:0]),
		.segments(HEX0)
	);
	
	hex_decoder hexdec_guess1
	(
		.hex_digit(guess[7:4]),
		.segments(HEX1)
	);
	
	// Turn off the other HEXes
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	// assign HEX5 = '1;

	// REVIEW HEX5 is used to display the remaining attempts
	hex_decoder hexdec_attempts
	(
		.hex_digit(remaining_attempts),
		.segments(HEX5)
	);
	
endmodule