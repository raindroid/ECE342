module tb();

// Change this to use a different program!
// localparam HEX_FILE = "sum10.hex";
// localparam HEX_FILE = "capital.hex";
// localparam HEX_FILE = "regjump.hex";
localparam HEX_FILE = "test.hex";

// Create a 100MHz clock
logic clk;
initial clk = '0;
always #5 clk = ~clk;

// Create the reset signal and assert it for a few cycles
logic reset;
initial begin
	reset = '1;
	@(posedge clk);
	@(posedge clk);
	reset = '0;
end

// Declare the bus signals, using the CPU's names for them
logic [15:0] o_mem_addr;
logic o_mem_rd;
logic [15:0] i_mem_rddata;
logic o_mem_wr;
logic [15:0] o_mem_wrdata;

// Instantiate the processor and hook up signals.
// Since the cpu's ports have the same names as the signals
// in the testbench, we can use the .* shorthand to automatically match them up
cpu dut(.*);

// Create a 64KB memory
logic [15:0] mem [0:32767];

always_ff @ (posedge clk) begin
	// Read logic.
	// For extra compliance, fill readdata with garbage unless
	// rd enable is actually used.
	if (o_mem_rd) i_mem_rddata <= mem[o_mem_addr[15:1]];
	else i_mem_rddata <= 16'bx;
	
	// Write logic
	if (o_mem_wr) mem[o_mem_addr[15:1]] <= o_mem_wrdata;
end

// Initialize memory
initial begin
	$display("Reading %s", HEX_FILE);
	$readmemh(HEX_FILE, mem);
end

// Writes to certain addresses will terminate the simulaton and print a result.
always_ff @ (posedge clk) begin
	if (o_mem_wr && o_mem_addr == 16'h1000) begin
		// Writing a number to 0x1000 will display it
		$display("Integer result: %h", o_mem_wrdata);
		$stop();
	end
	else if (o_mem_wr && o_mem_addr == 16'h1002) begin
		// Writing an address to 0x1002 will print the null-terminated string
		// at that address, as long as it's up to 512 characters long.
		int rd_addr;
		string str;
		int str_len;
		
		// Allocate a verilog string with 512 characters (we can't expand strings apparently).
		// rd_addr points to the string to print out, and the CPU gave this to us
		str = {512{" "}};
		str_len = 0;
		rd_addr = o_mem_wrdata;

		while (str_len < 512) begin
			logic [15:0] rd_val;
			rd_val = mem[rd_addr >> 1];
			
			if (rd_val == 16'hxxxx) begin
				$display("Bad string result: got xxxx at address %h",
					rd_addr);
				$stop();
			end
			
			// The lower 8 bits of the 16-bit word are an ASCII character to add to the string
			str.putc(str_len, rd_val[7:0]);
			
			// Got null terminator, we're done
			if (rd_val == 16'd0) 
				break;
			
			// Advance memory read position (by 1 word) and string write position
			rd_addr += 2;
			str_len++;
		end
		
		// Ran out of string room?
		if (str_len == 512) begin
			$display("Bad string result: no null terminator found after 512 chars");
			$stop();
		end
		
		// Got string, display it
		$display("String result: %s", str.substr(0, str_len-1));
		$stop();
	end
end

endmodule
