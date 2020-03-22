

module cpu_forward_ctrl (
    input clk,
    input reset,

    input [3:0] s3_rx,
    input [3:0] s3_ry,
    input [2:0] rw,
    input [15:0] rw_data,
    input rw_en,

    output logic [1:0] o_forward_ctrl,
    output logic [15:0] o_forward_data
);

    assign o_forward_data = rw_data;

    // check if rx == rw
    assign o_forward_ctrl[1] = rw_en && (s3_rx == {1'b0, rw});
    assign o_forward_ctrl[0] = rw_en && (s3_ry == {1'b0, rw});
    
endmodule