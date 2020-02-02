// REVIEW ui_control module

module ui_control (
    input clk,
    input reset,

    input i_go,
    input i_done,

    output logic o_updateXY,
    output logic o_draw
);

    enum int unsigned { 
        // NOTE States
        S_Start,
        S_Waiting_key_release,
        S_Draw,
        S_Waiting_draw,
        S_UpdateXY
    } state, next_state;

    always_ff @ (posedge clk or posedge reset) begin
        if (reset) state <= S_Start;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        o_draw = 0;
        o_updateXY = 0;

        case(state)
            S_Start:    // NOTE wait for i_go to be pressed
            begin
                next_state = i_go ? S_UpdateXY : S_Start;
            end
            S_UpdateXY:     // NOTE update XY
            begin
                o_updateXY = 1;
                next_state = S_Waiting_key_release;
            end
            S_Waiting_key_release:     // NOTE wait for i_go to be released
            begin
                next_state = i_go ? S_Waiting_key_release : S_Draw;
            end
            S_Draw: // NOTE draw start
            begin
                o_draw = 1;
                next_state = S_Waiting_draw;
            end
            S_Waiting_draw: // NOTE wait for drawing done
            begin
                next_state = i_done ? S_Start : S_Waiting_draw;
            end

        endcase
    end
    
endmodule