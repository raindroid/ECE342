//REVIEW  CPU modules

module cpu (
    input clk,
    input reset,

    output logic [15:0] o_mem_addr,
    output logic        o_mem_rd,
    input[15:0]         i_mem_rddata,
    output logic        o_mem_wr,
    output logic [15:0] o_mem_wrdata,

    input i_mem_wait,
    input i_mem_rddatavalid
);

    // REVIEW Datapath
    genvar i, j;
    logic [15:0] BUS;

    // NOTE General Purpose Registers
    logic [15:0] GPR_data [7:0];
    logic  [7:0] GPR_in;
    logic  [7:0] GPR_hin;

    generate
        for (i = 0; i < 8; i++) begin: gprs
            gpr_n reg_gpr (
                .i_clk(clk),
                .i_reset(reset),
                .i_in(GPR_in[i]),
                .i_hin(GPR_hin[i]),
                .i_din(BUS),
                .o_dout(GPR_data[i])
            );
        end
    endgenerate

    // NOTE PC reg
    logic [15:0] PC_data;
    logic PC_in, PC_incr, PC_offset;
    
    pc_n reg_pc (
        .i_clk(clk),
        .i_reset(reset),
        .i_in(PC_in),
        .i_incr(PC_incr),
        .i_offset(PC_offset),
        .i_din(BUS),
        .o_dout(PC_data)
    );

    // NOTE Arithmatic parts
    logic [15:0] A_data;
    logic [15:0] G_data;
    logic N_data;
    logic Z_data;
    logic A_in, G_in, N_in, Z_in, ADD_SUB;
    cpu_reg_n reg_A (clk, reset, A_in, BUS, A_data);
    cpu_reg_n reg_G (clk, reset, G_in, (ADD_SUB ? BUS - A_data : BUS + A_data), G_data);
    cpu_reg_n #(1) reg_N (clk, reset, N_in, G_data[15], N_data);
    cpu_reg_n #(1) reg_Z (clk, reset, Z_in, G_data == 16'b0, Z_data);
    assign {N_in, Z_in} = 2'b11; // ALways 1

    // NOTE Input regs
    logic [15:0] IR_data;
    logic IR_in;
    logic [15:0] DIN;
    wire IMM_MODE;
    wire [7:0] imm8;
    wire [10:0] imm11;
    wire [15:0] s_ext_imm8, double_s_ext_imm11;
    wire [3:0] rX, rY;

    assign DIN = i_mem_rddata;
    cpu_reg_n reg_IR (clk, reset, IR_in, DIN, IR_data);
    assign IMM_MODE = IR_data[4];
    assign imm8 = IR_data[15:8];
    assign imm11 = IR_data[15:5];
    assign s_ext_imm8 = { {8{imm8[7]}}, imm8[7:0]};
    assign double_s_ext_imm11 = 2 * { {5{imm11[10]}}, imm11[10:0]};
    assign rX = {1'b0, IR_data[7:5]};
    assign rY = {1'b0, IR_data[10:8]};

    // NOTE Output regs
    logic ADDR_in, DOUT_in, W_in, R_in;
    logic WR, RD;
    logic [15:0] MEM_addr, MEM_wrdata;
    // cpu_reg_n reg_ADDR (clk, reset, ADDR_in, BUS, o_mem_addr);
    // cpu_reg_n #(1) reg_W (clk, reset, W_in, WR, o_mem_wr);
    // cpu_reg_n #(1) reg_R (clk, reset, R_in, RD, o_mem_rd);
    // assign {W_in, R_in} = 2'b11;
    // cpu_reg_n reg_DOUT (clk, reset, DOUT_in, BUS, o_mem_wrdata);
    
    assign o_mem_rd = RD;
    assign o_mem_wr = WR;
    assign o_mem_addr = MEM_addr;
    assign o_mem_wrdata = MEM_wrdata;

    // NOTE Main MUX
    localparam  sel_R0  = 4'h0,
                sel_R1  = 4'h1,
                sel_R2  = 4'h2,
                sel_R3  = 4'h3,
                sel_R4  = 4'h4,
                sel_R5  = 4'h5,
                sel_R6  = 4'h6,
                sel_R7  = 4'h7,

                sel_PC  = 4'h8,
                sel_PC_inc  = 4'hd,
                sel_G   = 4'h9,
                
                sel_i8  = 4'ha,    // s_ext imm8
                sel_i11 = 4'hb,    // double s_ext imm11
                sel_din = 4'hc;

    logic [15:0] MUX_inputs [8 + 3 + 3];
    assign MUX_inputs[sel_R0]   = GPR_data[sel_R0[2:0]];
    assign MUX_inputs[sel_R1]   = GPR_data[sel_R1[2:0]];
    assign MUX_inputs[sel_R2]   = GPR_data[sel_R2[2:0]];
    assign MUX_inputs[sel_R3]   = GPR_data[sel_R3[2:0]];
    assign MUX_inputs[sel_R4]   = GPR_data[sel_R4[2:0]];
    assign MUX_inputs[sel_R5]   = GPR_data[sel_R5[2:0]];
    assign MUX_inputs[sel_R6]   = GPR_data[sel_R6[2:0]];
    assign MUX_inputs[sel_R7]   = GPR_data[sel_R7[2:0]];

    assign MUX_inputs[sel_PC]   = PC_data;
    assign MUX_inputs[sel_PC_inc]   = PC_data + 16'h2;
    assign MUX_inputs[sel_G]    = G_data;
    assign MUX_inputs[sel_i8]   = s_ext_imm8;
    assign MUX_inputs[sel_i11]  = double_s_ext_imm11;
    assign MUX_inputs[sel_din]  = DIN;

    // NOTE select BUS
    logic [3:0] SELECT, SEL_MEM_ADDR, SEL_MEM_WRDATA;
    assign BUS = MUX_inputs[SELECT];
    assign MEM_addr = MUX_inputs[SEL_MEM_ADDR];
    assign MEM_wrdata = MUX_inputs[SEL_MEM_WRDATA];

    // REVIEW Control FSM
    enum int unsigned {
        S_T0, S_T1, S_T2, S_T3, S_T4, S_T5
    } state, next_state;

    always_ff @ (posedge clk or posedge reset) begin
        if (reset) state <= S_T0;
        else state <= next_state;
    end

    logic [3:0] instruction;
    assign instruction = IR_data[3:0];
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


    // NOTE GENERATED BY cpuT.py
    always_comb begin
        next_state = state;
        SELECT = sel_PC;
        SEL_MEM_ADDR = sel_PC;
        SEL_MEM_WRDATA = rX;
        {GPR_in, GPR_hin, PC_in, PC_incr, A_in, G_in, IR_in, ADDR_in, DOUT_in, RD, WR, ADD_SUB, PC_offset}  = '0;

        case(state)
            S_T0: begin // S_T0 Fetch
                next_state = i_mem_wait ? S_T0 : S_T1;  // NOTE mem wait
                SEL_MEM_ADDR = sel_PC;
                RD = 1'b1;
            end
            S_T1: begin // S_T1 Load instruction
                next_state = i_mem_rddatavalid ? S_T2 : S_T1;// NOTE mem valid
                IR_in = i_mem_rddatavalid;
            end
            S_T2: begin // S_T2
                PC_incr = 1'b1;
                next_state = S_T3;
                case(instruction)
                    i_mv_: begin // i_mv_
                        SELECT = IMM_MODE ? sel_i8 : rY;
                        GPR_in[rX & 3'b111] = 1'b1;
                        next_state = S_T0;
                    end
                    i_mvhi: begin // i_mvhi
                        SELECT = sel_i8;
                        GPR_hin[rX & 3'b111] = 1'b1;
                        next_state = S_T0;
                    end
                    i_add_: begin // i_add_
                        SELECT = IMM_MODE ? sel_i8 : rY;
                        A_in = 1'b1;
                    end
                    i_sub_: begin // i_sub_
                        SELECT = IMM_MODE ? sel_i8 : rY;
                        A_in = 1'b1;
                    end
                    i_cmp_: begin // i_cmp_
                        SELECT = IMM_MODE ? sel_i8 : rY;
                        A_in = 1'b1;
                    end
                    i_ld: begin // i_ld
                        next_state = i_mem_wait ? S_T2 : S_T3;
                        SEL_MEM_ADDR = rY;
                        RD = 1'b1;
                        PC_incr = ~i_mem_wait;
                    end
                    i_st: begin // i_st
                        next_state = i_mem_wait ? S_T2 : S_T0;
                        SEL_MEM_ADDR = rY;
                        WR = 1'b1;
                        PC_incr = ~i_mem_wait;
                    end
                    i_jr_: begin // i_jr_
                        SELECT = IMM_MODE ? sel_i11 : rX;
                        PC_in = 1'b1;
                        PC_offset = IMM_MODE;
                        next_state = S_T0;
                    end
                    i_jzr_: begin // i_jzr_
                        SELECT = IMM_MODE ? sel_i11 : rX;
                        PC_in = (Z_data==1);
                        PC_offset = IMM_MODE;
                        next_state = S_T0;
                    end
                    i_jnr_: begin // i_jnr_
                        SELECT = IMM_MODE ? sel_i11 : rX;
                        PC_in = (N_data==1);
                        PC_offset = IMM_MODE;
                        next_state = S_T0;
                    end
                    i_callr_: begin // i_callr_
                        SELECT = sel_PC_inc;
                        GPR_in[7] = 1'b1;
                        A_in = 1'b1;
                    end
                    default: begin // default
                        next_state = S_T0;
                    end
                endcase
            end
            S_T3: begin // S_T3
                next_state = S_T4;
                case(instruction)
                    i_add_: begin // i_add_
                        SELECT = rX;
                        G_in = 1'b1;
                    end
                    i_sub_: begin // i_sub_
                        SELECT = rX;
                        G_in = 1'b1;
                        ADD_SUB = 1'b1;
                    end
                    i_cmp_: begin // i_cmp_
                        SELECT = rX;
                        G_in = 1'b1;
                        ADD_SUB = 1'b1;
                        next_state = S_T0;
                    end
                    i_ld: begin // i_ld
                        next_state = i_mem_rddatavalid ? S_T0 : S_T3;  // NOTE mem valid
                        SEL_MEM_ADDR = rY;
                        SELECT = sel_din;
                        GPR_in[rX & 3'b111] = i_mem_rddatavalid;
                    end
                    i_st: begin // i_st unused
                    end
                    i_callr_: begin // i_callr_
                        SELECT = IMM_MODE ? sel_i11 : rX;
                        PC_offset = IMM_MODE;
                        PC_in = 1'b1;
                        next_state = S_T0;
                    end
                endcase
            end
            S_T4: begin // S_T4
                next_state = S_T0;
                case(instruction)
                    i_add_: begin // i_add_
                        SELECT = sel_G;
                        GPR_in[rX & 3'b111] = 1'b1;
                    end
                    i_sub_: begin // i_sub_
                        SELECT = sel_G;
                        GPR_in[rX & 3'b111] = 1'b1;
                    end
                endcase
            end
            S_T5: begin // S_T5
                next_state = S_T0;
            end
            default: begin // default
                next_state = S_T0;
            end
        endcase
    end


endmodule