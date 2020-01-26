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
            assign C[i + 1] = g[i] | p[i] & C[i];   // NOTE this is not exactly the same as CLA during the lecture
            assign S[i] =  A[i] ^ B[i] ^ C[i];
        end
    endgenerate

    // NOTE hard coded
    // assign C[1] = g[0] | p[0] & C[0];
    // assign C[2] = g[1] | p[1] & (g[0] | p[0] & C[0]);
    // assign C[3] = g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & C[0]));
    // assign C[4] = g[3] | p[3] & (g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & C[0])));
    // assign C[5] = g[4] | p[4] & (g[3] | p[3] & (g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & C[0]))));
    // assign C[6] = g[5] | p[5] & (g[4] | p[4] & (g[3] | p[3] & (g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & C[0])))));
    // assign C[7] = g[6] | p[6] & (g[5] | p[5] & (g[4] | p[4] & (g[3] | p[3] & (g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & C[0]))))));
    // assign C[8] = g[7] | p[7] & (g[6] | p[6] & (g[5] | p[5] & (g[4] | p[4] & (g[3] | p[3] & (g[2] | p[2] & (g[1] | p[1] & (g[0] | p[0] & C[0])))))));

    
endmodule