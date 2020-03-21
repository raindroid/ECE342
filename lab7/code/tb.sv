module tb();

localparam string PROGRAMS[] = 
{
	"0_basic.hex",
	"1_arithdep.hex",
	"2_branch_nottaken.hex",
	"3_branch_taken.hex",
	"4_memdep.hex",
	"5_capital.hex"
};

// Create a 100MHz clock
logic clk;
initial clk = '0;
always #5 clk = ~clk;

// Create the reset signal 
logic reset;


// Declare the bus signals, using the CPU's names for them
logic [15:0] o_pc_addr;
logic o_pc_rd;
logic [15:0] i_pc_rddata;
logic [15:0] o_ldst_addr;
logic o_ldst_rd;
logic o_ldst_wr;
logic [15:0] i_ldst_rddata;
logic [15:0] o_ldst_wrdata;
logic [7:0][15:0] o_tb_regs;

// Instantiate the processor and hook up signals.
// Since the cpu's ports have the same names as the signals
// in the testbench, we can use the .* shorthand to automatically match them up
cpu dut(.*);

// Create a 16KB memory, dual-ported
logic [15:0] mem [0:8191];

// Define memory functionality.
always_ff @ (posedge clk) begin
	//
	// PORT 1 (pc read)
	//

	// Read logic.
	// For extra compliance, fill readdata with garbage unless
	// rd enable is actually used.
	if (o_pc_rd) begin
		i_pc_rddata <= mem[o_pc_addr[15:1]];
	end
	else begin 
		i_pc_rddata <= 16'bx;
	end
	
	//
	// PORT 2 (loads and stores)
	//
	
	// Read logic.
	if (o_ldst_rd) begin
		i_ldst_rddata <= mem[o_ldst_addr[15:1]];
	end
	else begin 
		i_ldst_rddata <= 16'bx;
	end
	
	// Write logic
	if (o_ldst_wr) begin
		case (o_ldst_addr)
		16'h1000: begin
			// Writing a number to 0x1000 will display it
			$display("Integer result: %h", o_ldst_wrdata);
		end
		
		16'h1002: begin
			// Writing an address to 0x1002 will print the null-terminated string
			// at that address, as long as it's up to 512 characters long.
			int rd_addr;
			string str;
			int str_len;
			
			// Allocate a verilog string with 512 characters (we can't expand strings apparently).
			// rd_addr points to the string to print out, and the CPU gave this to us
			str = {512{" "}};
			str_len = 0;
			rd_addr = o_ldst_wrdata;

			while (str_len < 512) begin
				logic [15:0] rd_val;
				rd_val = mem[rd_addr >> 1];
				
				if (rd_val == 16'hxxxx) begin
					$display("Bad string result: got xxxx at address %h",
						rd_addr);
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
		end
		
		// All other addresses: just write to memory
		default: begin
			mem[o_ldst_addr[15:1]] <= o_ldst_wrdata;
		end
		endcase
	end
end

// Test State
struct
{
	// Starting and ending PCs (inclusive) of IPC measurement region
	bit [15:0] measure_start;
	bit [15:0] measure_end;
	// Number of instructions in test (manually entered)
	integer n_instrs;
	// Minimum expected IPC
	real min_ipc;
	// Bitmask of which registers need validation
	bit [7:0] check_regs;
	// The expected valid values of said registers
	bit [15:0] reg_vals[8];
	
	// Cycle counters for measurement
	bit measure_enable;
	integer measure_cycles;
	//integer measure_instrs; // used for verification
} tstate;

// Snoop on the CPU's instruction fetching.
always_ff @ (posedge clk) begin
	// Once it fetches the instruction at the measure_start address,
	// then this testbench is now in measuring mode.
	if (o_pc_rd && o_pc_addr == tstate.measure_start) begin
		tstate.measure_enable = '1;
	end
	
	// Count every cycle in which we're in measuring mode.
	if (tstate.measure_enable) begin
		tstate.measure_cycles++;
		
		//if (o_pc_rd) tstate.measure_instrs++;
		//if (dut.ctrl.br_taken_3 && dut.dp.valid_3) tstate.measure_instrs -= 2;
	end
	
	// Once the CPU fetches the instruction at PC=measure_end,
	// that's the last instruction in the measurement region.
	// Turn off measuring mode now.
	if (o_pc_rd && o_pc_addr == tstate.measure_end) begin
		tstate.measure_enable = '0;
	end
end

task reset_cpu();
	reset = '1;
	@(posedge clk);
	@(posedge clk);
	reset = '0;
endtask

// Load the test metadata section from byte address 0x1000
task load_metadata();
	tstate.measure_start = mem[16'h800];
	tstate.measure_end = mem[16'h801];
	tstate.n_instrs = mem[16'h802];
	tstate.min_ipc = real'(mem[16'h803]) / 128.0;
	tstate.check_regs = mem[16'h804][7:0];
	for (integer i = 0; i < 8; i++) begin
		tstate.reg_vals[i] = mem[16'h805 + i];
	end
endtask

// Validate correctness of benchmark
task check_regs();
	bit all_passed;
	string detailed_info;
	all_passed = '1;
	
	// Benchmark has no correctness conditions? Exit quietly
	if (tstate.check_regs == '0)
		return;
	
	// First, check the registers
	detailed_info = "REG\tEXPECTD\tACTUAL\tRESULT\n";
	for (integer i = 0; i < 8; i++) begin
		logic [15:0] expected;
		logic [15:0] actual;
		bit pass;
		string detailed_line;
		
		// Does the benchmark care about this register?
		if (!tstate.check_regs[i]) continue;
		
		expected = tstate.reg_vals[i];
		actual = o_tb_regs[i];
		pass = expected == actual;
		
		detailed_line = $sformatf("R%0d\t0x%4x\t0x%4x\t%s\n",
			i,
			expected,
			actual,
			pass? "Pass" : "FAIL"
		);
		
		detailed_info = {detailed_info, detailed_line};
		all_passed &= pass;
	end
	
	$display("Functional correctness: %s",
		all_passed? "Pass" : "FAIL");
	
	if (!all_passed)
		$display(detailed_info);
endtask

// Validate performance of benchmark
task check_ipc();
	real ipc;
	
	ipc = tstate.measure_cycles > 0 ?
		real'(tstate.n_instrs) / real'(tstate.measure_cycles) : 0;
	
	$display("Instructions/cycles: %0d/%0d",
		tstate.n_instrs,
		tstate.measure_cycles
	);
	
	$display("IPC expected/achieved: %02f/%02f",
		tstate.min_ipc, ipc);
		
	$display("Performance result: %s",
		ipc >= tstate.min_ipc ? "Pass" : "FAIL");
endtask

task do_test(integer test_no);
	string hex_file;
	integer fp;

	// Reset the CPU
	reset_cpu();
	
	// Load the program
	hex_file = PROGRAMS[test_no];
	$display("================================");
	$display("Starting test %0d (%s)", test_no, hex_file);
	// Extra check to see if file exists
	fp = $fopen(hex_file, "r");
	if (fp == 0) begin
		$error("Couldn't open %s", hex_file);
		$stop;
	end
	$fclose(fp);
	$readmemh(hex_file, mem);
	
	// Parse metadata section
	load_metadata();
	
	// Init test counters
	tstate.measure_enable = 0;
	tstate.measure_cycles = 0;
	//tstate.measure_instrs = 0;
	
	// Wait for the program to do its thing and for
	// measurement to be done
	wait(tstate.measure_enable == 1);
	$display("Entered test region PC=%0x", tstate.measure_start);
	wait(tstate.measure_enable == 0);
	$display("Exited test region PC=%0x", tstate.measure_end);
	
	// Let the pipeline settle
	@(posedge clk);	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Check results
	check_regs();	
	check_ipc();
	//$display("Measured instrs: %0d", tstate.measure_instrs);
	$display("================================");
endtask

initial begin
	// Comment these out to run only certain tests.
	do_test(0);
	do_test(1);
	do_test(2);
	do_test(3);
	do_test(4);
	do_test(5);
	
	$stop;
end

endmodule
