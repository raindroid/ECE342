// REVIEW reg template

module reg_n #
(
	parameter N = 16
)
(
	input i_clk,
	input i_reset,
	input i_in,
	input [N-1:0] i_din,

	output logic [N-1:0] o_dout
);
	always_ff @(posedge i_clk) begin
		if (i_reset) o_dout <= '0;
		else if(i_in) o_dout <= i_din;
	end
endmodule

// REVIEW General-Purpose Register for CPU
module gpr_n #(
    parameter N = 16
) (
    input i_clk,
    input i_reset,
    input i_in,
    input i_hin,
    input [N-1:0] i_din,

    output logic [N-1:0] o_dout
);

    wire [N-1: 0] din;
    assign din = i_hin ? {i_din[N/2-1:0], o_dout[N/2-1:0]} : i_din;
    reg_n #(N) gpr (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_in(i_in | i_hin),
        .i_din( din ),

        .o_dout(o_dout)        
    );
endmodule

// REVIEW PC reg
module pc_n #(
    parameter N = 16
) (
    input i_clk, 
    input i_reset,
    input i_in,
    input i_incr,
    input i_offset,
    input [N-1: 0] i_din,

    output logic [N-1: 0] o_dout
);

    wire [N-1: 0] din;
    assign din = i_incr ? o_dout + 16'b10 : 
                (i_offset ? o_dout + i_din : i_din);
    reg_n #(N) pc_reg (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_in(i_in | i_incr),
        .i_din(din & (~16'b1)),

        .o_dout(o_dout)
    );

endmodule