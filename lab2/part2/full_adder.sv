/**
 * REVIEW 
 * module full_adder
 */

module full_adder (
    input A,
    input B,
    input Cin,

    output logic Cout,
    output logic S
);

    assign S = (A ^ B) ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
    
endmodule