module cpu
(
	input clk,
	input reset,
	
	output logic [15:0] o_pc_addr,
	output logic o_pc_rd,
	input [15:0] i_pc_rddata,
	
	output [15:0] o_ldst_addr,
	output o_ldst_rd,
	output o_ldst_wr,
	input  [15:0] i_ldst_rddata,
	output [15:0] o_ldst_wrdata,
	
	output [7:0][15:0] o_tb_regs
);

	logic [3:0] rx, ry;
	logic [2:0] rw;
	logic [15:0] rx_data, ry_data, rw_data;
	logic rw_en;
	// registers
	cpu_register_file registers (
		.clk(clk),
		.reset(reset),
		.i_rx(rx[2:0]),
		.i_ry(ry[2:0]),
		.i_rw(rw),
		.i_rw_data(rw_data),
		.i_rw_en(rw_en),

		.o_rx_data(rx_data),
		.o_ry_data(ry_data),
		.GPR_data(o_tb_regs)
	);

	// S1
	logic br_en;
	logic [15:0] br_pc;

	logic [15:0] o_s1_pc;
	logic o_s1_pc_rd;
	logic valid_1;
	cpu_fetch S1 (
		.clk(clk),
		.reset(reset),
		.i_br_en(br_en),
		.i_br_pc(br_pc),
		.o_pc_addr(o_pc_addr),
		.o_pc(o_s1_pc),
		.o_pc_rd(o_s1_pc_rd)
	);
	assign o_pc_rd = o_s1_pc_rd;
	assign valid_1 = ~reset;	// TODO

	// S2 and connection with S1
	logic [15:0] i_s2_pc;
	logic [15:0] i_s2_ir;
	logic valid_2;
	assign i_s2_ir = i_pc_rddata;
	cpu_stage_connection connection_s1_s2(
		.clk(clk),
		.reset(reset),
		.i_valid(valid_1),
		.o_valid(valid_2),
		.i_data(o_s1_pc),
		.o_data(i_s2_pc)
	);
	logic [15:0] o_s2_A, o_s2_B, o_s2_pc, o_s2_ir;
	logic [3:0] s2_rx, s2_ry;
	cpu_decode S2(
		.clk(clk), 
		.reset(reset),
		.i_pc(i_s2_pc),
		.i_ir(i_s2_ir), 
		.i_rx_data(rx_data),
		.i_ry_data(ry_data),
		.o_rx(s2_rx),
		.o_ry(s2_ry),
		.o_pc(o_s2_pc),
		.o_ir(o_s2_ir),
		.o_A(o_s2_A),
		.o_B(o_s2_B)
	);

	assign {rx, ry} = {s2_rx, s2_ry};

	// S3 and connection with S2
	logic [15:0] i_s3_pc, i_s3_ir, i_s3_A, i_s3_B;
	logic valid_3, invalid_s2;
	logic [3:0] s3_rx, s3_ry;
	cpu_stage_connection #(5) connection_s2_s3(
		.clk(clk),
		.reset(reset),
		.i_valid(valid_2 & ~invalid_s2),
		.o_valid(valid_3),
		.i_data({o_s2_pc, o_s2_ir, o_s2_A, o_s2_B, s2_rx, s2_ry}),
		.o_data({i_s3_pc, i_s3_ir, i_s3_A, i_s3_B, s3_rx, s3_ry})
	);
	logic [15:0] o_s3_pc, o_s3_ir, o_s3_G, i_forward_data;
	logic o_s3_N, o_s3_Z;
	logic [1:0] i_forward_ctrl;
	cpu_execute S3(
		.clk(clk),
		.reset(reset),

		.i_pc(i_s3_pc),
		.i_ir(i_s3_ir),
		.i_A(i_s3_A),
		.i_B(i_s3_B),

		.i_forward_data(i_forward_data),
		.i_forward_ctrl(i_forward_ctrl),

		.o_pc(o_s3_pc),
		.o_ir(o_s3_ir),
		.o_G(o_s3_G),
		.o_N(o_s3_N),
		.o_Z(o_s3_Z),
		.o_mem_data(o_ldst_wrdata),
		.o_mem_addr(o_ldst_addr),
		.o_mem_wr(o_ldst_wr),
		.o_mem_rd(o_ldst_rd)
	);

	// S4 and connection with S3
	logic [15:0] i_s4_pc, i_s4_ir, i_s4_G;
	logic valid_4;
 	cpu_stage_connection #(3) connection_s3_s4(
		.clk(clk),
		.reset(reset),
		.i_valid(valid_3),
		.o_valid(valid_4),
		.i_data({o_s3_pc, o_s3_ir, o_s3_G}),
		.o_data({i_s4_pc, i_s4_ir, i_s4_G})
	);
	cpu_writeback S4(
		.clk(clk),
		.reset(reset),

		.i_pc(i_s4_pc),
		.i_ir(i_s4_ir),
		.i_G(i_s4_G),
		.i_mem_rddata(i_ldst_rddata),

		.o_rw_en(rw_en),
		.o_rw(rw),
		.o_rw_data(rw_data)
	);

	// part 2 forward control logic
	cpu_forward_ctrl forward_control (
		.clk(clk),
		.reset(reset),
		.s2_rx(s2_rx),
		.s2_ry(s2_ry),
		.s3_rx(s3_rx),
		.s3_ry(s3_ry),
		.s3_valid(valid_3),
		.rw(rw),
		.rw_data(rw_data),
		.rw_en(rw_en),
		.o_forward_ctrl(i_forward_ctrl),
		.o_forward_data(i_forward_data)
	);

	// part 3 branch control logic
	cpu_branch_ctrl branch_control (
		.clk(clk),
		.reset(reset),

		.i_s2_ir(i_s2_ir),
		.i_s2_pc(i_s2_pc),
		// .i_s2_A('0),
		// .i_s2_B('0),
		.i_s2_A(o_s2_A),
		.i_s2_B(o_s2_B),

		.i_s3_ir(i_s3_ir),
		.i_s3_N(o_s3_N),
		.i_s3_Z(o_s3_Z),
		.i_s3_G('0),
		// .i_s3_G(o_s3_G),
		.i_s3_A(i_s3_A),
		.i_s3_B(i_s3_B),

		.i_forward_data(i_forward_data),
		.i_forward_ctrl(i_forward_ctrl),

		.o_invalid_s2(invalid_s2),
		.o_br_en(br_en),
		.o_br_pc(br_pc)
	);
endmodule

