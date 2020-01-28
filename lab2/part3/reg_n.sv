module reg_n #
(
	parameter N = 8
)
(
	input i_clk,
	input i_en,
	input [N-1:0] i_in,

	output logic [N-1:0] o_data
);
	always_ff @(posedge i_clk) begin
		if(i_en)
			o_data <= i_in;
	end

endmodule