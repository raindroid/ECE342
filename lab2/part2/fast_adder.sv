/**
 * REVIEW 
 * module fast_adder
 */

module fast_adder #
(
    parameter N = 8    
)
(
    input [N-1:0] A,
    input [N-1:0] B,
    input Cin,

    output logic Cout,
    output logic [N - 1: 0]S
);

    logic [N-1: 0] g, p;
    logic [N: 0] C;

    genvar i;

    assign C[0] = Cin;
    assign Cout = C[N];

    // NOTE Connect g_i, p_i
    generate 
        for (i = 0; i < N; i++) begin : adder_units
            assign g[i] = A[i] & B[i];
            assign p[i] = A[i] | B[i];
            assign C[i + 1] = g[i] | p[i] & C[i];
            assign S[i] =  A[i] ^ B[i] ^ C[i];
        end
    endgenerate

    
endmodule