module quad_hex_decode
(
	input clk,
	input reset,
	
	input [15:0] writedata,
	input write,
	
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
);

logic [15:0] in;

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		in <= '0;
	end
	else if (write) begin
		in <= writedata;
	end
end

hex_decode dec0(in[3:0], HEX0);
hex_decode dec1(in[7:4], HEX1);
hex_decode dec2(in[11:8], HEX2);
hex_decode dec3(in[15:12], HEX3);

endmodule
