// Module for a 2048x16 bit RAM.
// This can both synthesize in Quartus and simulate in ModelSim.
// In Quartus, it will be inferred into an actual memory block that lives somewhere on the FPGA.

module mem4k #
(
	parameter HEX_FILE = "mem.hex" // You can change this here, or override it upon instantiation
)
(
	input clk,
	
	input [10:0] addr,		// 2048 words means 11 bits of address
	input [15:0] wrdata,	// Each word is 16 bits wide
	input wr,
	output logic [15:0] rddata
);

// The memory itself
logic [15:0] mem [0:2047];

// Initializes memory contents.
// Quartus will read the .hex file during compilation and include it in the output bitstream.
initial begin
	$readmemh(HEX_FILE, mem);
end

// Read/write to the memory on positive edges of the clock
always_ff @ (posedge clk) begin
	if (wr) mem[addr] <= wrdata;
	rddata <= mem[addr];
end

endmodule
