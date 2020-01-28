module carry_lookahead_adder_n #
(
	parameter WIDTH = 1
)
(
	input [WIDTH-1:0] i_a,
	input [WIDTH-1:0] i_b,
	input i_cin,

	output [WIDTH-1:0] o_sum,
	output o_cout
);
	logic [WIDTH:0] cin;
	assign cin[0] = i_cin;
	assign o_cout = cin[WIDTH];

	logic [WIDTH-1:0] g;
	logic [WIDTH-1:0] p;

	genvar i;
	generate
		for (i = 0; i < WIDTH; i++) begin : carry_lookahead_adder
			assign g[i] = i_a[i] & i_b[i];
			assign p[i] = i_a[i] | i_b[i];
			assign cin[i+1] = g[i] | (p[i] & cin[i]);
		end 

		for (i = 0; i < WIDTH; i++) begin : sum_assignment
			assign o_sum[i] = i_a[i] ^ i_b[i] ^ cin[i];
		end 
	endgenerate
endmodule : carry_lookahead_adder_n