// Review fetch stage

module cpu_fetch (
    input clk,
    input reset,

    output logic [15:0] o_pc,
    output logic o_pc_rd
);

    logic pc_en;
    logic [15:0] pc;
    logic [15:0] pc_incr;
    assign pc_incr = pc + 2;
    assign pc_din = pc_incr & (~16'b1);
    assign pc_en = '1;

    cpu_reg_n reg_PC (
        clk,
        reset,
        pc_en,
        pc_incr,
        pc
    );

    assign o_pc = pc;
    assign o_pc_rd = 1;
    
endmodule