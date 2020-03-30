

module cpu_forward_ctrl (
    input clk,
    input reset,

    input [3:0] s2_rx,
    input [3:0] s2_ry,

    input [3:0] s3_rx,
    input [3:0] s3_ry,
    input s3_valid,

    input [2:0] rw,
    input [15:0] rw_data,
    input rw_en,

    output logic [1:0] o_forward_ctrl,
    output logic [15:0] o_forward_data
);

    assign o_forward_data = rw_data;

    // logic [3:0] r_s3_rx, r_s3_ry;
    // cpu_reg_n #(4) reg_rx (clk, reset, flag_en, s2_rx, r_s3_rx);
    // cpu_reg_n #(4) reg_ry (clk, reset, flag_en, s2_ry, r_s3_ry);
    // check if rx == rw
    assign o_forward_ctrl[1] = s3_valid && rw_en && (s3_rx == {1'b0, rw});
    assign o_forward_ctrl[0] = s3_valid && rw_en && (s3_ry == {1'b0, rw});
    
endmodule