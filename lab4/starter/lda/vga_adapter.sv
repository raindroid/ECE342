module vga_adapter #
(
	parameter BITS_PER_CHANNEL = 1,
	parameter SCALE = 5,
	parameter WIDTH = 1680/SCALE,
	parameter HEIGHT = 1050/SCALE,
	parameter WIDTH2 = $clog2(WIDTH),
	parameter HEIGHT2 = $clog2(HEIGHT)
)
(
	input clk, // should be a 50MHz clock

	// User signals
	input [WIDTH2-1:0] x,
	input [HEIGHT2-1:0] y,
	input [2:0][BITS_PER_CHANNEL-1:0] color,
	input plot,
	
	// Connect directly to top-level
    output [7:0] VGA_B,
    output VGA_BLANK_N,
    output VGA_CLK,
    output [7:0] VGA_G,
    output VGA_HS,
    output [7:0] VGA_R,
    output VGA_SYNC_N,
    output VGA_VS
);
localparam N_PIXELS = WIDTH*HEIGHT;
localparam N_PIXELS2 = $clog2(N_PIXELS);

// 50MHz board clock
wire clk50 = clk;

// Internal async reset generator.
// The 'reset' register has set_false_path on it
logic reset;
logic [1:0] reset_reg;
initial reset_reg = '0;

always_ff @ (posedge clk50) begin
	reset <= ~reset_reg[0];
	reset_reg <= {1'b1, reset_reg[1]};
end


// 147.14MHz VGA clock from PLL
logic clk147;
(* keep *) wire vga_reset = 1'b0;
vgapll vgapll_inst
(
	.refclk(clk50),
	.outclk_0(clk147),
	.rst(vga_reset)
);

// VGA memory
logic [N_PIXELS2-1:0] read_addr;
logic [2:0][BITS_PER_CHANNEL-1:0] read_data;
logic [N_PIXELS2-1:0] write_addr;
logic [2:0][BITS_PER_CHANNEL-1:0] write_data;
logic write_enable;

vga_memory #
(
	.N_PIXELS(N_PIXELS),
	.BITS_PER_CHANNEL(BITS_PER_CHANNEL)
)
vga_mem_inst
(
	.clk50(clk50),
	.clk147(clk147),
	.write_addr(write_addr),
	.write_data(write_data),
	.write_enable(write_enable),
	.read_addr(read_addr),
	.read_data(read_data)
);

// Write side
vga_input #
(
	.SCALE(SCALE),
	.BITS_PER_CHANNEL(BITS_PER_CHANNEL)
)
vga_in_inst
(
	.clk50(clk50),
	.reset(reset),
	.x(x),
	.y(y),
	.plot(plot),
	.color(color),
	.write_addr(write_addr),
	.write_data(write_data),
	.write_enable(write_enable)
);

// Read side
vga_output #
(
	.SCALE(SCALE),
	.BITS_PER_CHANNEL(BITS_PER_CHANNEL)
)
vga_out_inst
(
	.clk147(clk147),
	.reset(reset),
	.o_addr(read_addr),
	.i_pixel(read_data),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_BLANK_N(VGA_BLANK_N),
	.VGA_SYNC_N(VGA_SYNC_N),
	.VGA_CLK(VGA_CLK)
);



endmodule
