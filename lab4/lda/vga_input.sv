module vga_input #
(
	parameter SCALE,
	parameter BITS_PER_CHANNEL,
	parameter WIDTH = 1680/SCALE,
	parameter HEIGHT = 1050/SCALE,
	parameter WIDTH2 = $clog2(WIDTH),
	parameter HEIGHT2 = $clog2(HEIGHT),
	parameter N_PIXELS2 = $clog2(WIDTH*HEIGHT)
)
(
	input clk50,
	input reset,
	
	// User-facing
	input [WIDTH2-1:0] x,
	input [HEIGHT2-1:0] y,
	input plot,
	input [2:0][BITS_PER_CHANNEL-1:0] color,
	
	output logic [N_PIXELS2-1:0] write_addr,
	output logic [2:0][BITS_PER_CHANNEL-1:0] write_data,
	output logic write_enable
);

// Register inputs to make multiplier less painful.
// Hopefully the number of '1' bits in WIDTH is small.

always_ff @ (posedge clk50 or posedge reset) begin
	if (reset) begin
		write_enable <= '0;
	end
	else begin
		write_data <= color;
		write_enable <= plot;
		write_addr <= y * (* multstyle = "logic" *) WIDTH + x;
	end
end

endmodule