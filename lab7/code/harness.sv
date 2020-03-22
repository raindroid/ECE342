module harness
(
	input clk,
	input reset,
	
	output [15:0] o_pc_addr,
	output o_pc_rd,
	input [15:0] i_pc_rddata,
	
	output [15:0] o_ldst_addr,
	output o_ldst_rd,
	output o_ldst_wr,
	input [15:0] i_ldst_rddata,
	output [15:0] o_ldst_wrdata
);
	// Register inputs and outputs
	logic [15:0] o_pc_addr_r;
	logic o_pc_rd_r;
	logic [15:0] i_pc_rddata_r;
	logic [15:0] o_ldst_addr_r;
	logic o_ldst_rd_r;
	logic o_ldst_wr_r;
	logic [15:0] i_ldst_rddata_r;
	logic [15:0] o_ldst_wrdata_r;
	
	// always_ff @ (posedge clk) begin
	// 	o_pc_addr <= o_pc_addr_r;
	// 	o_pc_rd <= o_pc_rd_r;
	// 	i_pc_rddata_r <= i_pc_rddata;
	// 	o_ldst_addr <= o_ldst_addr_r;
	// 	o_ldst_rd <= o_ldst_rd_r;
	// 	o_ldst_wr <= o_ldst_wr_r;
	// 	i_ldst_rddata_r <= i_ldst_rddata;
	// 	o_ldst_wrdata <= o_ldst_wrdata_r;
	// end
	
	// Instantiate the thing
	cpu DUT
	(
		.clk(clk),
		.reset(reset),
		.o_pc_addr(o_pc_addr_r),
		.o_pc_rd(o_pc_rd_r),
		.i_pc_rddata(i_pc_rddata_r),
		.o_ldst_addr(o_ldst_addr_r),
		.o_ldst_rd(o_ldst_rd_r),
		.o_ldst_wr(o_ldst_wr_r),
		.i_ldst_rddata(i_ldst_rddata_r),
		.o_ldst_wrdata(o_ldst_wrdata_r),
		.o_tb_regs()	// leave unconnected
	);

endmodule
