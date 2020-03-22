// Review write back stage

module cpu_writeback (
    input clk,
    input reset,

    input [15:0] i_pc,
    input [15:0] i_ir,
    input [15:0] i_G,
    input [15:0] i_mem_rddata,

    output logic o_rw_en,
    output logic [2:0] o_rw,
    output logic [15:0] o_rw_data
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

    // en = all except jxx and st
    assign o_rw_en = (instruction == i_mv_) || (instruction == i_mvhi) || (instruction == i_mvhi) || (instruction == i_add_) || 
                     (instruction == i_sub_) || (instruction == i_ld) || (instruction == i_callr_);

    logic [2:0] rx;
    assign rx = i_ir[7:5];

    always_comb begin
        o_rw = '0;
        o_rw_data = '0;
        case(instruction)
            i_ld: begin
                o_rw = rx;
                o_rw_data = i_mem_rddata;
            end
            i_callr_: begin
                o_rw = 3'h7;
                o_rw_data = i_pc;
            end
            default: begin
                o_rw = rx;
                o_rw_data = i_G;
            end
        endcase
    end
    
endmodule