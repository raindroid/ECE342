module cpu_execute (
    input clk,
    input reset,

    input [15:0] i_pc,
    input [15:0] i_ir,
    input [15:0] i_A,
    input [15:0] i_B,

    input [15:0] i_forward_data,
    input [1:0] i_forward_ctrl,

    output logic [15:0] o_pc,
    output logic [15:0] o_ir,
    output logic [15:0] o_G,
    output logic o_N,
    output logic o_Z,
    output logic [15:0] o_mem_data,
    output logic [15:0] o_mem_addr,
    output logic o_mem_wr,
    output logic o_mem_rd
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

    assign o_pc = i_pc;
    assign o_ir = i_ir;

    logic [15:0] A, B;
    assign A = (i_forward_ctrl[1]) ? i_forward_data : i_A;
    assign B = (i_forward_ctrl[0]) ? i_forward_data : i_B;

    logic sel_alu, sel_G;
    logic [15:0] result;
    logic N_in, Z_in;
    assign result = sel_alu ? (A - B) : (A + B);
    cpu_reg_n #(1) reg_N (clk, reset, N_in, result[15], o_N);
    cpu_reg_n #(1) reg_Z (clk, reset, Z_in, result == 16'b0, o_Z);
    assign sel_G = (instruction == i_add_) || (instruction == i_sub_) || (instruction == i_cmp_);
    assign {Z_in, N_in} = {sel_G, sel_G};
    assign sel_alu = (instruction == i_sub_) || (instruction == i_cmp_);
    assign o_G = sel_G ? result : A;

    // mem access
    assign o_mem_data = A;
    assign o_mem_addr = B;
    assign o_mem_wr = (instruction == i_st);
    assign o_mem_rd = (instruction == i_ld);
    
endmodule