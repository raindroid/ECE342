module alu(
	input i_op_sel, //0 as add and 1 as sub 
	input [15:0] i_op_a,
	input [15:0] i_op_b,
	output logic [15:0] o_alu_out,
	output o_n,
	output o_z
);
	
	assign o_n = o_alu_out[15];//0 represent positive
	assign o_z = ~|o_alu_out;//nor gate
	
	always_comb begin
		case (i_op_sel)
			0: o_alu_out = i_op_a + i_op_b;
			1: o_alu_out = i_op_a - i_op_b;
			default: o_alu_out = '0;
		endcase
	end

endmodule
