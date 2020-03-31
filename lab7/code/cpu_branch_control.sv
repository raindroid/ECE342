

module cpu_branch_ctrl (
    input clk,
    input reset,

    input [15:0] r7_data,
    input [15:0] i_s2_ir,
    input [15:0] i_s2_pc,
    input [15:0] i_s2_A,
    input [15:0] i_s2_B,
    input i_s2_N,
    input i_s2_Z,

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
    
    logic br_en, br_en_fast, br_record;
    logic [15:0] br_pc, br_pc_fast;

    assign o_invalid_s2 = br_en;  // TODO
    assign o_br_en = br_en | br_en_fast;
    assign o_br_pc = br_en ? br_pc : br_pc_fast;

    cpu_reg_n #(1) reg_record (clk, reset, '1, ~br_en & br_en_fast, br_record);

    // REVIEW branch from stage 3
    logic [3:0] instruction3;
    assign instruction3 = i_s3_ir[3:0];
    assign imm_mode3 = i_s3_ir[4];

    logic [15:0] A, B;
    assign A = (i_forward_ctrl[1]) ? i_forward_data : i_s3_A;
    assign B = (i_forward_ctrl[0]) ? i_forward_data : i_s3_B;
    assign br_pc = A + B;
    always_comb begin
        br_en = 0;
        case(instruction3)
            i_jr_: br_en = ~br_record;
            i_jzr_: br_en = ~br_record & i_s3_Z;
            i_jnr_: br_en = ~br_record & i_s3_N;
            i_callr_: br_en = ~br_record;
            default: br_en = 0;
        endcase
    end
    
    // REVIEW Faster branch from stage 2
    logic [3:0] instruction2;
    wire [10:0] imm11;
    wire [15:0] s_ext_imm11x2;
    logic comparable;
    logic r7_valid, r7_predict;
    logic [2:0] s2_rx;
    assign s2_rx = i_s2_ir[7:5];

    assign r7_predict = ( s2_rx == 3'h7 && (instruction2 == i_mvhi || instruction2 == i_mv_ || instruction2 == i_add_ || instruction2 == i_sub_ || instruction2 == i_ld) );
    cpu_reg_n #(1) reg_r7_valid (clk, reset, '1, ~r7_predict, r7_valid);
    
    assign imm11 = i_s2_ir[15:5];
    assign s_ext_imm11x2 = { {4{imm11[10]}}, imm11[10:0], 1'b0};
    assign instruction2 = i_s2_ir[3:0];
    assign imm_mode2 = i_s2_ir[4];
    // assign comparable = ( instruction3 == i_add_ || instruction3 == i_sub_ || instruction3 == i_cmp_);
    // assign br_en_fast = imm_mode2 & (instruction2[3] & ~instruction2[1] & ~instruction2[0]); // i_jr_ or i_callr_
    wire s2_Z = i_s2_Z;
    wire s2_N = i_s2_N;
    logic use_r7;
    always_comb begin
        br_en_fast = 0;
        case(instruction2)
            i_jr_: br_en_fast = imm_mode2 || (s2_rx == 3'h7 && r7_valid);
            i_jzr_: br_en_fast = s2_Z & (imm_mode2 || (s2_rx == 3'h7 && r7_valid));
            i_jnr_: br_en_fast = s2_N & (imm_mode2 || (s2_rx == 3'h7 && r7_valid));
            i_callr_: br_en_fast = imm_mode2 || (s2_rx == 3'h7 && r7_valid);
            default: br_en_fast = 0;
        endcase
    end
    // assign br_en_fast = 0;
    assign br_pc_fast = imm_mode2 ? i_s2_A : r7_data;
    
endmodule