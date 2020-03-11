module cpu_control(
	input i_clk,
	input i_reset,
	
	output logic o_mem_rd,
	output logic o_mem_wr,
	output logic o_mem_addr_sel,
	
	output logic [1:0] o_pc_sel,
	output logic o_pc_ld,
	
	input [4:0] i_ir,
	output logic o_ir_ld,
	
	output logic [2:0] o_reg_sel,
	output logic o_reg_write,
	output logic o_reg_addr_w_sel,
	
	
	//signals for alu operation
	input i_alu_n,
	input i_alu_z,
	output logic o_alu_n_ld,
	output logic o_alu_z_ld,
	output logic o_alu_b_sel,//select imm or reg
	output logic o_alu_op,
	
	input i_mem_wait,
	input i_mem_rddatavalid
);

	// States
	enum int unsigned
	{
		S_FETCH,
		S_LOAD_INSTRUCTION,
		S_EXECUTE,
		S_MEM_LD//only for load opration
	} state, nextstate;

	// State regs
	always_ff @ (posedge i_clk or posedge i_reset) begin
		if (i_reset) state <= S_FETCH;
		else state <= nextstate;
	end
	
	// State table
	always_comb begin
		nextstate = state;
		
		//initialize signals
		o_mem_rd = 1'd0;
		o_mem_wr = 1'd0;
		o_mem_addr_sel = 1'd0;

		o_pc_sel = 2'd0;
		o_pc_ld = 1'd0;

		o_ir_ld = 1'd0;

		o_reg_sel = 3'd0;
		o_reg_write = 1'd0;
		o_reg_addr_w_sel = 1'd0;

		o_alu_n_ld = 1'd0;
		o_alu_z_ld = 1'd0;
		o_alu_b_sel = 1'd0;
		o_alu_op = 1'd0;
		
		case (state)
			S_FETCH:begin
				if (~i_mem_wait) nextstate = S_LOAD_INSTRUCTION;
				o_mem_rd = 1'b1;
				o_mem_addr_sel = 1'd0;
			end
			
			S_LOAD_INSTRUCTION:begin
				if (i_mem_rddatavalid) begin
					nextstate = S_EXECUTE;
					o_ir_ld = 1'b1;
				end
			end
			
			//19 instructions are listed here
			S_EXECUTE: begin
				case (i_ir[3:0])
					//mv and mvi
					4'b0000: begin
						nextstate = S_FETCH;
						
						o_pc_sel = 2'd1;
						o_pc_ld = 1'd1;
					
						o_reg_write = 1'd1;
						o_reg_addr_w_sel = 1'd0;

						if (~i_ir[4]) o_reg_sel = 3'd5;
						else o_reg_sel = 3'd0;
					end
					
					//add and addi
					4'b0001: begin
						nextstate = S_FETCH;
						
						o_pc_sel = 2'd1;
						o_pc_ld = 1'd1;
						
						o_reg_sel = 3'd2;//???
						o_reg_write = 1'd1;
						o_reg_addr_w_sel = 1'd0;
						
						o_alu_n_ld = 1'd1;
						o_alu_z_ld = 1'd1;
						o_alu_op = 1'd0;
						
						if (~i_ir[4]) o_alu_b_sel = 1'd1;
						else o_alu_b_sel = 1'd0;
					end
					
					//sub and subi
					4'b0010: begin
						nextstate = S_FETCH;
						
						o_pc_sel = 2'd1;
						o_pc_ld = 1'd1;
						
						o_reg_sel = 3'd2;
						o_reg_write = 1'd1;
						o_reg_addr_w_sel = 1'd0;
						
						o_alu_n_ld = 1'd1;
						o_alu_z_ld = 1'd1;
						o_alu_op = 1'd1;
						
						if (~i_ir[4]) o_alu_b_sel = 1'd1;
						else o_alu_b_sel = 1'd0;
					end
					
					//cmp and cmpi
					4'b0011: begin
						nextstate = S_FETCH;
						
						o_pc_sel = 2'd1;
						o_pc_ld = 1'd1;
						
						o_alu_n_ld = 1'd1;
						o_alu_z_ld = 1'd1;
						o_alu_op = 1'd1;
						
						if (~i_ir[4]) o_alu_b_sel = 1'd1;
						else o_alu_b_sel = 1'd0;
					end
					
					//ld
					4'b0100: begin
						if (~i_mem_wait) nextstate = S_MEM_LD;
						
						o_mem_rd = 1'd1;
						o_mem_addr_sel = 1'd1;
						if (~i_mem_wait) begin
							o_pc_sel = 2'd1;
							o_pc_ld = 1'd1;
						end
					end
					
					//st
					4'b0101: begin
						if (~i_mem_wait) nextstate = S_FETCH;
						
						o_mem_wr = 1'd1;
						o_mem_addr_sel = 1'd1;
						
						if (~i_mem_wait) begin
							o_pc_sel = 2'd1;
							o_pc_ld = 1'd1;
						end
					end
					
					//mvhi
					4'b0110: begin
						nextstate = S_FETCH;
						
						o_pc_sel = 2'd1;
						o_pc_ld = 1'd1;
						
						o_reg_sel = 3'd1;
						o_reg_write = 1'd1;
						o_reg_addr_w_sel = 1'd0;
					end
					
					//jr and j
					4'b1000: begin
						nextstate = S_FETCH;
						
						o_pc_ld = 1'd1;
						if (~i_ir[4]) o_pc_sel = 2'd0;
						else o_pc_sel = 2'd2;
					end
					
					//jzr and jzr
					4'b1001: begin
						nextstate = S_FETCH;
						
						o_pc_ld = 1'd1;
						if (i_alu_z) begin
							if (~i_ir[4]) begin
								o_pc_sel = 2'd0;
							end
							else begin
								o_pc_sel = 2'd2;
							end
						end
						else begin
							o_pc_sel = 2'd1;
						end
					end
					
					//jnr and jnr
					4'b1010: begin
						nextstate = S_FETCH;
						
						o_pc_ld = 1'd1;
						if (i_alu_n) begin
							if (~i_ir[4]) begin
								o_pc_sel = 2'd0;
							end
							else begin
								o_pc_sel = 2'd2;
							end
						end
						else begin
							o_pc_sel = 2'd1;
						end
					end
					
					//callr and callr
					4'b1100: begin
						nextstate = S_FETCH;
						
						o_pc_ld = 1'd1;
						
						o_reg_sel = 3'd3;
						o_reg_write = 1'd1;
						o_reg_addr_w_sel = 1'd1;
						
						if (~i_ir[4]) begin
							o_pc_sel = 2'd0;
						end
						else begin
							o_pc_sel = 2'd2;
						end
					end
					
					default: begin
						nextstate = S_FETCH;
						o_pc_ld = 1'd1;
					end
				endcase
			end
			
			S_MEM_LD: begin
				if (i_mem_rddatavalid) begin
					nextstate = S_FETCH;
				
					o_reg_sel = 3'd4;
					o_reg_write = 1'd1;
					o_reg_addr_w_sel = 1'd0;
				end
			end
			
		endcase
	end
endmodule