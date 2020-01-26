/**
 * REVIEW 
 * module multiplier_cell
 */

module multiplier_cell (
    input i_pin,
    input i_m,

    input i_plus,
    input i_minus,

    input i_Cin,

    output logic o_Cout,
    output logic o_Sign,
    output logic o_pout
);

    assign o_Sign = (i_m & i_plus) | (~ i_m & i_minus);

    full_adder FA(
        .A(i_pin),
        .B(o_Sign),
        .Cin(i_Cin),

        .Cout(o_Cout),
        .S(o_pout)
    );
    
endmodule