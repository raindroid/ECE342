module vga_memory #
(
	parameter N_PIXELS,
	parameter BITS_PER_CHANNEL,
	parameter N_PIXELS2 = $clog2(N_PIXELS)
)
(
	input clk50,
	input clk147,
	
	input [N_PIXELS2-1:0] write_addr,
	input write_enable,
	input [2:0][BITS_PER_CHANNEL-1:0] write_data,
	
	input [N_PIXELS2-1:0] read_addr,
	output [2:0][BITS_PER_CHANNEL-1:0] read_data
);

// Keep the 3 channels in separate memories.
// This lets us use M20K blocks in 5-bit-wide mode, ensuring
// perfect packing and no wasted space.
//
// If we used a single memory that was 15 or 16 bits wide,
// it would natively be 20 bits wide, thus wasting space.

genvar i;
generate
for (i = 0; i < 3; i++) begin : channels
	wire [BITS_PER_CHANNEL-1:0] d = write_data[i];
	logic [BITS_PER_CHANNEL-1:0] q;
	assign read_data[i] = q;

	altsyncram #
	(
		.operation_mode("DUAL_PORT"),
		.width_a(BITS_PER_CHANNEL),
		.widthad_a(N_PIXELS2),
		.numwords_a(N_PIXELS),
		.width_b(BITS_PER_CHANNEL),
		.widthad_b(N_PIXELS2),
		.numwords_b(N_PIXELS),
		.outdata_reg_b("CLOCK1"),
		.maximum_depth(2048)
	)
	mem
	(
		.wren_a(write_enable),
		.data_a(d),
		.address_a(write_addr),
		.address_b(read_addr),
		.clock0(clk50),
		.clock1(clk147),
		.q_b(q)
	);
end
endgenerate


endmodule

