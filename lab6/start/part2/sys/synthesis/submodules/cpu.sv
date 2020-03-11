module cpu(
	input i_clk,
	input i_reset,
	
	output [15:0] o_mem_addr,
	output o_mem_rd,
	input  [15:0] i_mem_rddata,
	output o_mem_wr,
	output [15:0] o_mem_wrdata,
	
	input i_mem_wait,
	input i_mem_rddatavalid
);

	logic mem_addr_sel;
	logic pc_ld;
	logic [1:0] pc_sel;
	logic ir_ld;
	logic [4:0] ir_instrcode;
	logic reg_write;
	logic reg_addr_w_sel;
	logic [2:0] reg_sel;
	logic alu_n_ld;
	logic alu_z_ld;
	logic alu_b_sel;
	logic alu_op_sel;
	logic alu_n;
	logic alu_z;

cpu_control control(
	.i_clk (i_clk),
	.i_reset (i_reset),
	
	.o_mem_rd (o_mem_rd),
	.o_mem_wr (o_mem_wr),
	.o_mem_addr_sel(mem_addr_sel),
	
	.o_pc_sel(pc_sel),
	.o_pc_ld(pc_ld),
	
	.i_ir(ir_instrcode),
	.o_ir_ld(ir_ld),
	
	.o_reg_sel(reg_sel),
	.o_reg_write(reg_write),
	.o_reg_addr_w_sel(reg_addr_w_sel),
	
	
	//signals for alu operation
	.i_alu_n(alu_n),
	.i_alu_z(alu_z),
	.o_alu_n_ld(alu_n_ld),
	.o_alu_z_ld(alu_z_ld),
	.o_alu_b_sel(alu_b_sel),//select imm or reg
	.o_alu_op(alu_op_sel),
	
	.i_mem_rddatavalid(i_mem_rddatavalid),
	.i_mem_wait(i_mem_wait)
);

cpu_datapath datapath(
	.i_clk(i_clk),
	.i_reset(i_reset),
	
	//signals
	.i_mem_addr_sel(mem_addr_sel),
	
	.i_pc_ld(pc_ld),
	.i_pc_sel(pc_sel), //incre by 2 | rx | 2*imm11
	
	.i_ir_ld(ir_ld),
	
	.i_reg_write(reg_write), 
	.i_reg_addrw_sel(reg_addr_w_sel),//choose from writing to r7 or rx
	.i_reg_sel(reg_sel),//select from different input to reg
	
	.i_alu_n_ld(alu_n_ld), 
	.i_alu_z_ld(alu_z_ld),
	.i_alu_b_sel(alu_b_sel), //choose from immediate value(0) or registers (1) for second op
	.i_alu_op_sel(alu_op_sel),
	
	//signals back to control
	.o_ir_instrcode(ir_instrcode),
	.o_alu_n(alu_n),
	.o_alu_z(alu_z),
	
	.i_mem_rddata(i_mem_rddata),
	
	.o_mem_addr(o_mem_addr),
	.o_mem_wrdata(o_mem_wrdata)
);

endmodule