

module cpu_branch_ctrl (
    input clk,
    input reset,

    input [15:0] i_s3_ir,
    input i_s3_N, 
    input i_s3_Z,
    input [15:0] i_s3_G,
    input [15:0] i_s3_A,
    input [15:0] i_s3_B,

    input [15:0] i_forward_data,
    input [1:0] i_forward_ctrl,

    output logic o_br_en,   // branch enable
    output logic o_invalid_s2,  // signal to invalidate stage 2
    output logic [15:0] o_br_pc
);

    logic [3:0] instruction;
    assign instruction = i_s3_ir[3:0];
    localparam  i_mv_   = 4'b0000,
                i_add_  = 4'b0001,
                i_sub_  = 4'b0010,
                i_cmp_  = 4'b0011,
                i_ld    = 4'b0100,
                i_st    = 4'b0101,
                i_mvhi  = 4'b0110,

                i_jr_   = 4'b1000,
                i_jzr_  = 4'b1001,
                i_jnr_  = 4'b1010,
                i_callr_= 4'b1100;

    assign o_invalid_s2 = o_br_en;

    logic [15:0] A, B;
    assign A = (i_forward_ctrl[1]) ? i_forward_data : i_s3_A;
    assign B = (i_forward_ctrl[0]) ? i_forward_data : i_s3_B;
    assign o_br_pc = A + B;
    always_comb begin
        o_br_en = 0;
        case(instruction)
            i_jr_: o_br_en = 1;
            i_jzr_: o_br_en = i_s3_Z;
            i_jnr_: o_br_en = i_s3_N;
            i_callr_: o_br_en = 1;
            default: o_br_en = 0;
        endcase
    end
    
endmodule