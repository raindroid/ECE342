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
	
    logic [7:0] i_op_in;
    logic i_op_en;
    logic i_clk;

    assign i_op_in = SW[7:0];
    assign i_op_en = SW[9];
    assign i_clk = CLOCK_50;

    logic [7:0] reg_x;
    logic [7:0] reg_y;
    logic [15:0] mult_out;
    logic [15:0] reg_out;

    reg_en_n # (.WIDTH(8)) m_reg_x (
        .i_clk (i_clk),
        .i_en  (i_op_en),
        .i_data(i_op_in),

        .o_data(reg_x)
    );

    reg_en_n # (.WIDTH(8)) m_reg_y (
        .i_clk (i_clk),
        .i_en  (~i_op_en),
        .i_data(i_op_in),

        .o_data(reg_y)
    );

    reg_en_n # (.WIDTH(16)) m_reg_out (
        .i_clk (i_clk),
        .i_en  (1'b1),
        .i_data(mult_out),

        .o_data(reg_out)
    );

    wallace_tree_multiplier m_mult (
        .i_m(reg_x),
        .i_q(reg_y),

        .o_p(mult_out)
    );

    hex_decoder m_hex0 (
        .hex_digit(reg_out[3:0]),
        .segments (HEX0)
    );

    hex_decoder m_hex1 (
        .hex_digit(reg_out[7:4]),
        .segments (HEX1)
    );

    hex_decoder m_hex2 (
        .hex_digit(reg_out[11:8]),
        .segments (HEX2)
    );

    hex_decoder m_hex3 (
        .hex_digit(reg_out[15:12]),
        .segments (HEX3)
    );
	 
	 assign HEX4 = '1;
	 assign HEX5 = '1;
endmodule