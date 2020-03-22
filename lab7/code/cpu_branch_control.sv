

module cpu_branch_ctrl (
    input clk,
    input reset,

    input [15:0] i_ir,
    input i_N, 
    input i_Z,
    input [15:0] i_G,

    output logic o_br_en,   // branch enable
    output logic [15:0] o_br_pc
);

    logic [3:0] instruction;
    assign instruction = i_ir[3:0];
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

    assign o_br_pc = i_G;
    always_comb begin
        o_br_en = 0;
        case(instruction)
            i_jr_: o_br_en = 1;
            i_jzr_: o_br_en = i_Z;
            i_jnr_: o_br_en = i_N;
            i_callr_: o_br_en = 1;
            default: o_br_en = 0;
        endcase
    end
    
endmodule