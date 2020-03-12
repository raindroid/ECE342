module cpu_datapath(
	input i_clk,
	input i_reset,
	
	//signals
	input i_mem_addr_sel,
	
	input i_pc_ld,
	input [1:0] i_pc_sel, //incre by 2 | rx | 2*imm11
	
	input i_ir_ld,
	
	input i_reg_write, 
	input i_reg_addrw_sel,//choose from writing to r7 or rx
	input [2:0] i_reg_sel,//select from different input to reg
	
	input i_alu_n_ld, 
	input i_alu_z_ld,
	input i_alu_b_sel, //choose from immediate value(0) or registers (1) for second op
	input i_alu_op_sel,
	
	//signals back to control
	output [4:0] o_ir_instrcode,
	output logic o_alu_n,
	output logic o_alu_z,
	
	input [15:0] i_mem_rddata,
	
	output logic [15:0] o_mem_addr,
	output logic [15:0] o_mem_wrdata
);

	
	logic [15:0] pc;
	logic [15:0] pc_next;
	logic [15:0] pc_plus_two;
	logic [15:0] pc_jump;
	
	logic [15:0] ir;

	logic [15:0] ir_imm8;
	logic [15:0] ir_imm11;
	
	logic [2:0] reg_addrw;
	logic [2:0] reg_addrx;
	logic [2:0] reg_addry;
	logic [15:0] reg_data_in;
	logic [15:0] reg_data_x_out;
	logic [15:0] reg_data_y_out;
	
	logic [15:0] alu_op_a;
	logic [15:0] alu_op_b;
	logic [15:0] alu_out;
	logic        alu_n;
	logic        alu_z;
	
	all_eight_regs regs_inst(
		.i_clk(i_clk),
		.i_reset(i_reset),
	
		.i_write(i_reg_write),
		.i_addrw(reg_addrw),
		.i_addrx(reg_addrx),
		.i_addry(reg_addry),
		.i_data_in(reg_data_in),
		.o_data_x_out(reg_data_x_out),
		.o_data_y_out(reg_data_y_out)
	);
	
	alu alu_inst(
		.i_op_sel(i_alu_op_sel), //0 as add and 1 as sub 
		.i_op_a(alu_op_a),
		.i_op_b(alu_op_b),
		.o_alu_out(alu_out),
		.o_n(alu_n),
		.o_z(alu_z)
	);
	
	always_ff @ (posedge i_clk)begin
		
		if (i_reset) begin
			pc <= '0;
			ir <= '0;
			o_alu_n <= '0;
			o_alu_z <= '0;
		end
		
		else begin
			if (i_pc_ld) pc <= pc_next;
			if (i_ir_ld) ir <= i_mem_rddata;
			if (i_alu_n_ld) o_alu_n <= alu_n;
			if (i_alu_z_ld) o_alu_z <= alu_z;
		end
	end
	
	assign o_mem_wrdata = reg_data_x_out;
	
	assign pc_plus_two = pc + 16'd2; //increment pc for each op
	assign pc_jump = pc_plus_two + (ir_imm11 * 2);
	
	//translate the machine code to all regs
	assign ir_imm11 = {{5{ir[15]}},ir[15:5]};
	assign ir_imm8 = {{8{ir[15]}},ir[15:8]};
	assign reg_addrx = ir[7:5];
	assign reg_addry = ir[10:8];
	assign o_ir_instrcode = ir[4:0];
	
	assign alu_op_a = reg_data_x_out;
	
	always_comb begin
	
		case (i_mem_addr_sel)
			0: o_mem_addr = pc; //for normal ops that dont require mem access, fetch machine code from that address
			1: o_mem_addr = reg_data_y_out; // address for store instruction
			default: o_mem_addr = '0;
		endcase
		
		case (i_pc_sel)
			0: pc_next = reg_data_x_out;//jump to a addr given by reg
			1: pc_next = pc_plus_two;//normal pc incre by 2
			2: pc_next = pc_jump;//jump to imm11 addr
			default: pc_next = '0;
		endcase
		
		case (i_reg_addrw_sel)
			0: reg_addrw = reg_addrx;//writeing to rx
			1: reg_addrw = 3'd7; // r7 <- pc
			default: reg_addrw = '0;
		endcase
		
		case (i_reg_sel) 
			0: reg_data_in = ir_imm8;
			1: reg_data_in = {ir_imm8[7:0],reg_data_x_out[7:0]};
			2: reg_data_in = alu_out;
			3: reg_data_in = pc_plus_two;
			4: reg_data_in = i_mem_rddata;
			5: reg_data_in = reg_data_y_out;
			default: reg_data_in = '0;
		endcase
		
		case (i_alu_b_sel)
			0: alu_op_b = ir_imm8;
			1: alu_op_b = reg_data_y_out;
			default: alu_op_b = '0;
		endcase
	end
endmodule