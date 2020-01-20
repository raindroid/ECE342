/**
 * REVIEW 
 * module Booth encoding
 */

module booth_encoder (
    input i_Qi,   // Q_{i}
    input i_Qi_1, // Q_{i-1}

    output logic o_plus,
    output logic o_minus
);

    assign o_plus   = (~ i_Qi) & (i_Qi_1);
    assign o_minus  = (i_Qi) & (~ i_Qi_1);
    
endmodule