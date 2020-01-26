/**
 * REVIEW 
 * module half_adder
 */

module half_adder (
    input A,
    input B,

    output logic Cout,
    output logic S
);

    assign S = A ^ B;
    assign Cout = A & B;
    
endmodule