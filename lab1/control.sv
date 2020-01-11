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
	output logic o_update_leds
);

// Declare two objects, 'state' and 'nextstate'
// that are of enum type.
enum int unsigned
{
	// TODO: declare states here
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
	if (reset) state <= S_A;// TODO: choose initial reset state
	else state <= nextstate;
end

// always_comb replaces always @* and gives compile-time errors instead of warnings
// if you accidentally infer a latch
always_comb begin
	// Set default values for signals here, to avoid having to explicitly
	// set a value for every possible control path through this always block
	nextstate = state;
	o_inc_actual = 1'b0;
	o_update_leds = 1'b0;
	
	case (state)
		// TODO: complete this
		S_A: // NOTE Generate Random Number
		begin
			o_inc_actual = 1'b1;
			nextstate = (!i_enter) ? S_A : S_B;
		end
		S_B: // NOTE Stop generating random number
		begin
			nextstate = i_enter ? S_B : S_C;
		end
		S_C: // NOTE Wait for compare result
		begin
			nextstate = S_D;
		end
		S_D: // Display the result
		begin
			// TODO Part 2 remain attempts - 1
			o_update_leds = 1'b1;
			nextstate = i_equal ? S_E : (/* TODO Step 2 test if remain attempts == 0*/ S_F);
		end
		S_E: // WON
		begin	
			nextstate = S_E;
		end
		S_F: // Wait for next enter
		begin
			nextstate = (!i_enter) ? S_F : S_B;
		end
		S_G: // Failed
		begin
			nextstate = S_G;
		end
	endcase
end

endmodule
