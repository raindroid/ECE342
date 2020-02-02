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

// VGA adapter and signals
logic [8:0] vga_x;
logic [7:0] vga_y;
logic [2:0] vga_color;
logic vga_plot;

vga_adapter #
(
	.BITS_PER_CHANNEL(1)
)
vga_inst
(
	.CLOCK_50(CLOCK_50),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_SYNC_N(VGA_SYNC_N),
	.VGA_BLANK_N(VGA_BLANK_N),
	.VGA_CLK(VGA_CLK),
	.x(vga_x),
	.y(vga_y),
	.color(vga_color),
	.plot(vga_plot)
);

// This generates a one-time active-high asynchronous reset
// signal on powerup. You can use it if you need it.
// All the KEY inputs are occupied, so we can't use one as a reset.
logic reset;
logic [1:0] reset_reg;
always_ff @ (posedge CLOCK_50) begin
	reset <= ~reset_reg[0];
	reset_reg <= {1'b1, reset_reg[1]};
end

//
// PUT YOUR UI AND LDA MODULE INSTANTIATIONS HERE
//


logic setX, setY, set_col, go;
logic [8:0] val;

assign val = SW[8:0];
assign {go, set_col, setY, setX} = ~KEY;

logic done, start;
logic [2:0] color;
logic [8:0] x0, x1;
logic [7:0] y0, y1;

user_interface  u_user_interface (
    .clk          (CLOCK_50),
    .reset        (reset | SW[9]  ),
    .i_setX       (setX   ),
    .i_setY       (setY   ),
    .i_set_col    (set_col),
    .i_go         (go     ),
    .i_val        (val    ),
    .i_done       (done   ),

    .o_start     ( start  ),
    .o_color     ( color  ),
    .o_x0        ( x0     ),
    .o_y0        ( y0     ),
    .o_x1        ( x1     ),
    .o_y1        ( y1     )
);

line_drawing_algo  u_line_drawing_algo (
    .clk                     ( CLOCK_50     ),
    .reset                   ( reset    | SW[9]    ),
    .i_start                 ( start        ),
    .i_x0                    ( x0     [8:0] ),
    .i_y0                    ( y0     [7:0] ),
    .i_x1                    ( x1     [8:0] ),
    .i_y1                    ( y1     [7:0] ),
    .i_color                 ( color  [2:0] ),

    .o_x                     ( vga_x            ),
    .o_y                     ( vga_y           ),
    .o_plot                  ( vga_plot         ),
    .o_color                 ( vga_color       ),
    .o_done                  ( done       )
);

// Hex Decoders
hex_decoder h0
(
    .hex_digit(x1[3:0]),
    .segments(HEX0)
);

hex_decoder h1
(
    .hex_digit(x1[7:4]),
    .segments(HEX1)
);

hex_decoder h2
(
    .hex_digit(y1[3:0]),
    .segments(HEX2)
);

hex_decoder h3
(
    .hex_digit(y1[7:4]),
    .segments(HEX3)
);

hex_decoder h4
(
    .hex_digit(val[3:0]),
    .segments(HEX4)
);

hex_decoder h5
(
    .hex_digit(val[7:4]),
    .segments(HEX5)
);

endmodule