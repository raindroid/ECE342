/**
 * REVIEW 
 * module half_adder
 */

module half_adder (
    input A,
    input B,

    output logic S,
    output logic Cout
);

    assign S = A ^ B;
    assign Cout = A & B;
    
endmodule