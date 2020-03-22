// REVIEW reg template

module cpu_reg_n #
(
	parameter N = 16
)
(
	input clk,
	input reset,
	input i_in,
	input [N-1:0] i_din,

	output logic [N-1:0] o_dout
);
	always_ff @(posedge clk) begin
		if (reset) o_dout <= '0;
		else if(i_in) o_dout <= i_din;
	end
endmodule