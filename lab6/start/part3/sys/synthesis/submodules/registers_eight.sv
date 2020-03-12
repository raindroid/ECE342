module register_single(
	input i_clk,
	input i_reset,
	input i_write,
	
	input [2:0] i_addr_write,
	input [2:0] i_reg_num,
	
	input [15:0] i_in_data,
	output logic [15:0] o_out_data
);

	always_ff @ (posedge i_clk or posedge i_reset) begin
		if (i_reset) o_out_data <= '0;
		else if (i_write) begin
				if (i_addr_write == i_reg_num)
					o_out_data <= i_in_data;
				else
					o_out_data <= o_out_data;	
			end
			else
				o_out_data <= o_out_data;
	end
endmodule

module all_eight_regs(
	input i_clk,
	input i_reset,
	
	input i_write,
	input [2:0] i_addrw,
	input [2:0] i_addrx,
	input [2:0] i_addry,
	input [15:0] i_data_in,
	output logic [15:0] o_data_x_out,
	output logic [15:0] o_data_y_out
);
	logic [15:0] o_reg0;
	logic [15:0] o_reg1;
	logic [15:0] o_reg2;
	logic [15:0] o_reg3;
	logic [15:0] o_reg4;
	logic [15:0] o_reg5;
	logic [15:0] o_reg6;
	logic [15:0] o_reg7;

	register_single reg0 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd0),.i_in_data(i_data_in),.o_out_data(o_reg0));
	register_single reg1 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd1),.i_in_data(i_data_in),.o_out_data(o_reg1));
	register_single reg2 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd2),.i_in_data(i_data_in),.o_out_data(o_reg2));
	register_single reg3 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd3),.i_in_data(i_data_in),.o_out_data(o_reg3));
	register_single reg4 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd4),.i_in_data(i_data_in),.o_out_data(o_reg4));
	register_single reg5 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd5),.i_in_data(i_data_in),.o_out_data(o_reg5));
	register_single reg6 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd6),.i_in_data(i_data_in),.o_out_data(o_reg6));
	register_single reg7 (.i_clk(i_clk),.i_reset(i_reset),.i_write(i_write),.i_addr_write(i_addrw),.i_reg_num(3'd7),.i_in_data(i_data_in),.o_out_data(o_reg7));
	always_comb begin
		case (i_addrx) 
			3'd0: o_data_x_out = o_reg0;
			3'd1: o_data_x_out = o_reg1;
			3'd2: o_data_x_out = o_reg2;
			3'd3: o_data_x_out = o_reg3;
			3'd4: o_data_x_out = o_reg4;
			3'd5: o_data_x_out = o_reg5;
			3'd6: o_data_x_out = o_reg6;
			3'd7: o_data_x_out = o_reg7;
		endcase
		
		case (i_addry) 
			3'd0: o_data_y_out = o_reg0;
			3'd1: o_data_y_out = o_reg1;
			3'd2: o_data_y_out = o_reg2;
			3'd3: o_data_y_out = o_reg3;
			3'd4: o_data_y_out = o_reg4;
			3'd5: o_data_y_out = o_reg5;
			3'd6: o_data_y_out = o_reg6;
			3'd7: o_data_y_out = o_reg7;
		endcase
	end


endmodule