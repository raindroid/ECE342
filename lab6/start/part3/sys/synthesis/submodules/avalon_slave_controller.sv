module avalon_slave_controller (
    input clk,
    input reset,

    // with top
    input [2:0]         s_address,
    input               s_read,
    output [31:0]       s_readdata,    // master read from us
    output              s_waitrequest,
    input               s_write,   
    input [31:0]        s_writedata,   // master write to us
    
    input [3:0]         s_byteenable, // NOTE added

    // with LDA
    input               i_done,
    output logic        o_start,
    output logic [8:0]  o_x0,
    output logic [7:0]  o_y0,
    output logic [8:0]  o_x1,
    output logic [7:0]  o_y1,
    output logic [2:0]  o_color
);

    localparam  address_mode_reg    = 3'b000,
                address_status_res  = 3'b001,
                address_go_reg      = 3'b010,
                address_line_start  = 3'b011,
                address_line_end    = 3'b100,
                address_line_color  = 3'b101;
    localparam  MODE_STALL  = 1'b0,
                MODE_POLL   = 1'b1;

    logic s_mode, s_status, s_go;
    logic [8:0] s_x0, s_x1;
    logic [7:0] s_y0, s_y1;
    logic [2:0] s_color;

    logic [31:0] s_reg_map [7:0];   // in case over flow
    logic waiting;
    logic status_update, status;
    logic drawing;
    logic idle;

    // NOTE connect inputs
    assign s_readdata = s_reg_map[s_address];
    
    // NOTE connect outputs
    assign s_waitrequest = (drawing || s_go) && (s_mode == MODE_STALL);
    assign o_x0 = s_x0;
    assign o_y0 = s_y0;
    assign o_x1 = s_x1;
    assign o_y1 = s_y1;
    assign o_color = s_color;
    // assign o_start = s_go;

    lda_reg_n #(32) reg_mode (
        .i_clk(clk), 
        .i_reset(reset), 
        .i_en(s_address==address_mode_reg && s_write), 
        .i_in(s_writedata & 32'b1), 
        .o_data(s_reg_map[address_mode_reg]));
    assign s_mode = s_reg_map[address_mode_reg][0];
    
    lda_reg_n #(32) reg_status (
        .i_clk(clk), 
        .i_reset(reset), 
        .i_en(1'b1), 
        .i_in((drawing || s_go) & 32'b1), 
        .o_data(s_reg_map[address_status_res]));
    assign s_status = s_reg_map[address_status_res][0];
    
    lda_reg_n #(32) reg_go (    // NOTE generating a pulse when go
        .i_clk(clk), 
        .i_reset(reset), 
        .i_en(1'b1), 
        .i_in((s_address==address_go_reg && s_write) & 32'b1), 
        .o_data(s_reg_map[address_go_reg]));
    assign s_go = ~s_reg_map[address_go_reg][0] && (s_address==address_go_reg && s_write);

    lda_reg_n #(32) reg_start (    // NOTE extend the go pulse to 1 cycle
        .i_clk(clk), 
        .i_reset(reset), 
        .i_en(1'b1), 
        .i_in(s_go), 
        .o_data(o_start));

    lda_reg_n #(16) reg_line_start_byte10 (
        .i_clk(clk), 
        .i_reset(reset), 
        // .i_en(s_address==address_line_start && s_write && s_byteenable==4'b11), 
        // .i_in(s_writedata[15:0]),   // select 16 bits 
        .i_en(1), 
        .i_in(16'h0),   // select 16 bits 
        .o_data(s_reg_map[address_line_start][15:0]));
    lda_reg_n #(16) reg_line_start_byte32 (
        .i_clk(clk), 
        .i_reset(reset), 
        // .i_en(s_address==address_line_start && s_write && s_byteenable==4'b1100), 
        // .i_in(s_writedata[31:16] & 16'b1),   // select last 1 bits 
        .i_en(1), 
        .i_in(16'h0),   // select last 1 bits 
        .o_data(s_reg_map[address_line_start][31:16]));
    assign s_x0 = s_reg_map[address_line_start][8:0];
    assign s_y0 = s_reg_map[address_line_start][16:9];
    
    lda_reg_n #(16) reg_line_end_byte10 (
        .i_clk(clk), 
        .i_reset(reset), 
        .i_en(1), 
        // .i_en(s_address==address_line_end && s_write && s_byteenable==4'b11), 
        .i_in(16'ha34f),   // select last 17 bits 
        // .i_in(s_writedata[15:0]),   // select last 17 bits 
        .o_data(s_reg_map[address_line_end][15:0]));
    lda_reg_n #(16) reg_line_end_byte32 (
        .i_clk(clk), 
        .i_reset(reset), 
        .i_en(s_address==address_line_end && s_write && s_byteenable==4'b1100), 
        .i_in(s_writedata[31:16] & 16'b1),   // select last 17 bits 
        .o_data(s_reg_map[address_line_end][31:16]));
    assign s_x1 = s_reg_map[address_line_end][8:0];
    assign s_y1 = s_reg_map[address_line_end][16:9];

    lda_reg_n #(32) reg_color (
        .i_clk(clk), 
        .i_reset(reset), 
        .i_en(1), 
        .i_in(32'b111),   // select last 3 bits
        // .i_en(s_address==address_line_color && s_write), 
        // .i_in(s_writedata & 32'b111),   // select last 3 bits
        .o_data(s_reg_map[address_line_color]));
    assign s_color = s_reg_map[address_line_color][2:0];

    // unused regs, in case input out of range
    assign s_reg_map[6] = 32'b0;
    assign s_reg_map[7] = 32'b0;

    always_ff @(posedge clk) begin
        if (reset) drawing = 1'b0;
        else if (s_go) drawing = 1'b1;
        else if (i_done) drawing = 1'b0;
    end


    // NOTE Wait control (STALL MODE)
    // enum int unsigned {
    //     S_Start,
    //     S_Write,
    //     S_Draw_Poll,
    //     S_Draw_Stall
    // } state, next_state;
    
    // always_ff @ (posedge clk or posedge reset) begin
    //     if (reset) state <= S_Start;
    //     else state <= next_state;
    // end

    // always_comb begin
    //     next_state = state;
    //     o_start = 0;
    //     waiting = 0;
    //     status_update = 0;
    //     status = 0;
    //     idle = 0;
    //     case(state)
    //         S_Start:
    //         begin
    //             idle = 1;
    //             // if (s_write && s_mode == MODE_STALL) begin
    //             //     next_state = S_Write;
    //             //     waiting = 1;
    //             // end
    //             if (s_go == 1 && s_mode == MODE_STALL) begin
    //                 next_state = S_Draw_Stall;
    //                 waiting = 1;
    //                 o_start = 1;
    //             end
    //             else if (s_go == 1 && s_mode == MODE_POLL) begin
    //                 next_state = S_Draw_Poll;
    //                 status_update = 1;
    //                 status = 1;
    //                 o_start = 1;
    //             end
    //         end
    //         S_Write:
    //         begin
    //             if (~s_write) next_state = S_Start;
    //         end
    //         S_Draw_Poll:
    //         begin
    //             if (i_done) begin
    //                 next_state = S_Start;
    //                 status_update = 1;
    //             end
    //         end
    //         S_Draw_Stall:
    //         begin
    //             waiting = 1;
    //             if (i_done) begin
    //                 next_state = S_Start;
    //                 waiting = 0;
    //             end
    //         end
    //     endcase
    // end

    
endmodule