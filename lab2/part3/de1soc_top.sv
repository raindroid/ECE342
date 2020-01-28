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
	
    logic [7:0] num;
    logic en;
    logic clk;

    assign num = SW[7:0];
    assign en = SW[9];
    assign clk = CLOCK_50;

    logic [7:0] x;
    logic [7:0] y;
    logic [15:0] w_out;
    logic [15:0] out;
    

    wallace_tree_multiplier mut (
        .i_m(x),
        .i_q(y),
        
        .o_p(w_out)
    );

    reg_n # (.N(8)) m_x (
        .i_clk (clk),
        .i_en  (en),
        .i_in(num),
        .o_data(x)
    );

    reg_n # (.N(8)) m_y (
        .i_clk (clk),
        .i_en  (~en),
        .i_in(num),
        .o_data(y)
    );

    reg_n # (.N(16)) m_out (
        .i_clk (clk),
        .i_en  (1'b1),
        .i_in(w_out),
        .o_data(out)
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
    
    // assign HEX4 = '1;
    // assign HEX5 = '1;

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