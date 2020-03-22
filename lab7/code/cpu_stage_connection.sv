// Review stage connection

module cpu_stage_connection #(parameter N = 1) (
    input clk,
    input reset,
    
    input i_valid,
    output logic o_valid,

    input [N:0] [15:0] i_data,
    output logic [N:0] [15:0] o_data

);
	logic [N:0] [15:0] data;

    cpu_reg_n #(N * 16) reg_data (clk, ~i_valid, '1, i_data, data);

    cpu_reg_n #(1) reg_V (clk, reset, '1, i_valid, o_valid);

	assign o_data = (o_valid) ? data : '1;
    
endmodule

/**
 example
 	cpu_stage_connection connection_s1_s2(
		.clk(),
		.reset(),
		.i_valid(),
		.o_valid(),
		.i_data0(),
		.o_data0(),
		.i_data1(),
		.o_data1(),
		.i_data2(),
		.o_data2(),
		.i_data3(),
		.o_data3()
	);
*/