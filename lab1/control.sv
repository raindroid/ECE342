module control
(
	input clk,
	input reset,
	
	// Button input
	input i_enter,
	
	// Datapath
	output logic o_inc_actual,
	input i_over,
	input i_under,
	input i_equal,
	
	// LED Control: Setting this to 1 will copy the current
	// values of over/under/equal to the 3 LEDs. Setting this to 0
	// will cause the LEDs to hold their current values.
	output logic o_update_leds,
	output logic [3:0] o_remaining_attempts // REVIEW the remaining attempts
);

localparam MAX_ATTEMPTS = 4'd7;	// REVIEW the max attempts in part 2
logic less_remaining_attemps;

// Declare two objects, 'state' and 'nextstate'
// that are of enum type.
enum int unsigned
{
	// TODO: declare states here
	// REVIEW: states
	// NOTE: See extra notes
	S_A,
	S_B,
	S_C,
	S_D,
	S_E,
	S_F,
	S_G
} state, nextstate;

// Clocked always block for making state registers
always_ff @ (posedge clk or posedge reset) begin
	/* REVIEW initial states S_A */
	if (reset) state <= S_A	; // TODO: choose initial reset state 
	else state <= nextstate;
end

// REVIEW update the remaining attempts counter
always_ff @ (posedge clk or posedge reset) begin
	if (reset) o_remaining_attempts <= MAX_ATTEMPTS;
	else o_remaining_attempts <= o_remaining_attempts - less_remaining_attemps;
end

// always_comb replaces always @* and gives compile-time errors instead of warnings
// if you accidentally infer a latch
always_comb begin
	// Set default values for signals here, to avoid having to explicitly
	// set a value for every possible control path through this always block
	nextstate = state;
	o_inc_actual = 1'b0;
	o_update_leds = 1'b0;
	less_remaining_attemps = 1'b0;
	
	case (state)
		// TODO: complete this
		// REVIEW: control part
		S_A: // NOTE Generate Random Number
		begin
			o_inc_actual = 1'b1;
			// reset attempts
			nextstate = (!i_enter) ? S_A : S_B;
		end
		S_B: // NOTE Stop generating random number
		begin
			nextstate = i_enter ? S_B : S_C;
		end
		S_C: // NOTE Wait for compare result, this step is not necessary 
		begin
			nextstate = S_D;
		end
		S_D: // NOTE Display the result, and (for Part 2) update the remaining attempts
		begin
			o_update_leds = 1'b1;
			less_remaining_attemps = 1'b1;
			nextstate = i_equal ? S_E : (o_remaining_attempts == 0 ? S_G : S_F);
		end
		S_E: // NOTE WON the game
		begin	
			nextstate = S_E;
		end
		S_F: // NOTE Wait for next try (i_enter)
		begin
			nextstate = (!i_enter) ? S_F : S_B;
		end
		S_G: // NOTE Failed (try too many times)
		begin
			nextstate = S_G;
		end
	endcase
end

endmodule
