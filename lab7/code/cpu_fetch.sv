// Review fetch stage

module cpu_fetch (
    input clk,
    input reset,

    input logic i_br_en,
    input logic [15:0] i_br_pc,

    output logic [15:0] o_pc_addr,  // provide to memory interface
    output logic [15:0] o_pc,   // give to next stage
    output logic o_pc_rd
);

    logic pc_en;
    logic [15:0] pc;
    logic [15:0] pc_incr;
    logic [15:0] pc_r;
    assign pc_incr = pc + 2;
    assign pc_din = pc_incr & (~16'b1);
    assign pc_en = '1;

    cpu_reg_n reg_PC (
        clk,
        reset,
        pc_en,
        pc_incr,
        pc_r
    );

    assign pc = (i_br_en) ? i_br_pc : pc_r;
    assign o_pc = pc_incr;

    // Instruction Memory interface
    assign o_pc_addr = pc;
    assign o_pc_rd = 1;
    
endmodule