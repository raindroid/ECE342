// ,Review all gpr

module cpu_register_file (
    input clk,
    input reset,
    
    input [2:0] i_rx,
    input [2:0] i_ry,
    input [2:0] i_rw,
    input [15:0] i_rw_data,
    input i_rw_en,

    output logic [15:0] o_rx_data,
    output logic [15:0] o_ry_data,
    output logic [7:0][15:0] GPR_data
);

    genvar i, j;

    // NOTE General Purpose Registers
    // logic [15:0] GPR_data [7:0];
    logic  [7:0] GPR_in;

    generate
        for (i = 0; i < 8; i++) begin: gprs
            cpu_reg_n reg_gpr (
                .clk(clk),
                .reset(reset),
                .i_in(GPR_in[i]),
                .i_din(i_rw_data),
                .o_dout(GPR_data[i])
            );
        end
    endgenerate

    always_comb begin
        GPR_in = '0;
        GPR_in[i_rw] = i_rw_en;
    end
    
    assign o_rx_data = (i_rw_en && i_rw == i_rx) ? i_rw_data : GPR_data[i_rx];
    assign o_ry_data = (i_rw_en && i_rw == i_ry) ? i_rw_data : GPR_data[i_ry];
    
endmodule