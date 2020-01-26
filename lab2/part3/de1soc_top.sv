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
	
	// Design goes here
    // REVIEW 
    parameter N = 8;
    reg [N - 1:0] x, y;
    reg [2 * N - 1:0] out;

    wire en_X = SW[9];
    wire en_Y = ~SW[9];
    wire [2 * N - 1:0] w_out;

    wire [7:0] D_plus;
    wire [7:0] D_minus;

    always_ff @(posedge CLOCK_50) begin
        if (en_X) x <= SW[7:0];
        if (en_Y) y <= SW[7:0];
        out <= w_out;
    end

    wallace_tree_multiplier WTM (
        .i_m(x),
        .i_q(y),
        
        .o_p(w_out)
    );

    assign LEDR = '0;

    hex_decoder hex0
	(
		.hex_digit(out[3:0]),
		.segments(HEX0)
	);

    hex_decoder hex1
	(
		.hex_digit(out[7:4]),
		.segments(HEX1)
	);

    hex_decoder hex2
	(
		.hex_digit(out[11:8]),
		.segments(HEX2)
	);

    hex_decoder hex3
	(
		.hex_digit(out[15:12]),
		.segments(HEX3)
	);
    
    // assign HEX4 = '0;
    // assign HEX5 = '0;

    hex_decoder hex4
	(
		.hex_digit(SW[3:0]),
		.segments(HEX4)
	);

    hex_decoder hex5
	(
		.hex_digit(SW[7:4]),
		.segments(HEX5)
	);
	
endmodule