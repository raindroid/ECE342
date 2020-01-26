/**
 * REVIEW 
 * module carry_save_multiplier
 */

module carry_save_multiplier #(
    parameter N = 8
)
(
    input [N - 1: 0] i_m,
    input [N - 1: 0] i_q,

    output [2 * N - 1: 0] o_p
);

    logic [2 * N - 1: 0] pout;

    logic [N - 1: 0] carry [N: 0];
    logic [N: 0] p [N: 0];
    logic [N - 1: 0] mq [N - 1: 0];

    genvar i, j;


    // NOTE the first N bits P are 0s
    assign p[0][N-1:0] = {(N){1'b0}};

    // NOTE the first N bits carry are 0s
    assign carry[0] = {(N){1'b0}};

    // NOTE generate the mulpilier arrays
    generate
        for (i = 0; i < N; i++) begin : multiplier
            assign p[i][N] = 1'b0;  // init value of the top bits
            for (j = 0; j < N; j++) begin : multiplier_cells
                assign mq[i][j] = i_m[i] & i_q[j];
                // REVIEW See the extra notes as an example (FA_0_0)
                full_adder mc(
                    .A(p[i][j+1]),      // p_0_1
                    .B(mq[i][j]),       // mq_0_0
                    .Cin(carry[i][j]),      // c_0_0

                    .Cout(carry[i+1][j]),   // c_1_0
                    .S(p[i+1][j])     // p_1_0
                );
            end

            // NOTE assign the last N-1 bits to the result
            assign pout[i] = p[i+1][0];
        end
    endgenerate

    // NOTE the fast adder at the bottom
    logic unused;
    fast_adder #(N) fa
    (
        .A({1'b0,p[N][N-1:1]}),    // p_8_8:1
        .B(carry[N][N-1:0]),
        .Cin(1'b0),
        .Cout(unused),
        .S(pout[2 * N-1:N])
    );

    assign o_p = pout;
    
endmodule