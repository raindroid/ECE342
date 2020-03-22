// Review stage connection

module cpu_stage_connection (
    input clk,
    input reset,
    
    input i_valid,
    output logic o_valid,

    input [15:0] i_data0,
    output logic [15:0] o_data0,

    input [15:0] i_data1,
    output logic [15:0] o_data1,

    input [15:0] i_data2,
    output logic [15:0] o_data2,

    input [15:0] i_data3,
    output logic [15:0] o_data3

);

    cpu_reg_n reg_data0 (clk, ~i_valid, '1, i_data0, o_data0);
    cpu_reg_n reg_data1 (clk, ~i_valid, '1, i_data1, o_data1);
    cpu_reg_n reg_data2 (clk, ~i_valid, '1, i_data2, o_data2);
    cpu_reg_n reg_data3 (clk, ~i_valid, '1, i_data3, o_data3);

    cpu_reg_n #(1) reg_V (clk, reset, '1, i_valid, o_valid);
    
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