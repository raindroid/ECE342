/**
 * REVIEW 
 * module full_adder
 */

module full_adder (
    input A,
    input B,
    input Cin,

    output logic S,
    output logic Cout
);

    assign S = (A ^ B) ^ Cin;
    assign Cout = (A & B) | (Cin & (A | B));
    
endmodule