// REVIEW LDA control module

module lda_control (
    input clk,
    input reset,

    input i_start,
    input i_clear_done,
    input i_line_done,

    output logic o_done,
    output logic o_data_reset,
    output logic o_start_draw_line,
    output logic o_clear_canvas,
    output logic o_draw_line
);

    enum int unsigned { 
        // NOTE states
        S_Start,
        S_Clear,
        S_Start_draw,
        S_Draw
    } state, next_state;

    always_ff @ (posedge clk or posedge reset) begin
        if (reset) state <= S_Start;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        o_done = 0;
        o_data_reset = 0;
        o_clear_canvas = 0;
        o_start_draw_line = 0;
        o_draw_line = 0;

        case(state)
            S_Start: // NOTE wait for draw signal and clear reg in datapath
            begin
                o_data_reset = 1;
                if (i_start) next_state = S_Start_draw;
            end
            // S_Clear: // NOTE clear the cavas (draw all pixels to black)  NOT REQUIRED !!!!!!!
            // begin
            //     o_clear_canvas = 1;
            //     if (i_clear_done) next_state = S_Start_draw;
            // end
            S_Start_draw:   // NOTE prepare to draw (set up start x, y)
            begin
                o_start_draw_line = 1;
                next_state = S_Draw;
            end
            S_Draw:
            begin
                o_draw_line = 1;
                if (i_line_done) begin
                    o_done = 1;
                    next_state = S_Start;
                end
            end
        endcase
    end
    
endmodule