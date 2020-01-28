module reg_en_n #
(
	parameter WIDTH = 1
)
(
	input i_clk,
	input i_en,
	input [WIDTH-1:0] i_data,

	output logic [WIDTH-1:0] o_data
);
	always_ff @(posedge i_clk) begin
		if(i_en)
			o_data <= i_data;
	end

endmodule : reg_en_n