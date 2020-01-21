/**
 * REVIEW 
 * module signed_array_multiplier
 */

module signed_array_multiplier #(
    parameter N = 8
)
(
    input [N - 1: 0] i_m,
    input [N - 1: 0] i_q,

    output [2 * N - 2: 0] o_p
);

    logic [N - 1: 0] plus, minus;
    logic [2 * N - 1: 0] pout;

    genvar i, j;

    // NOTE generate BE modules
    generate
        for (i = 0; i < N; i ++) begin
            if (i == 0) begin
                booth_encoder  u_booth_encoder (
                    .i_Qi_1     (1'b0),
                    .i_Qi       (i_q[0]),
                    .o_plus     (plus[0]),
                    .o_minus    (minus[0])
                );
            end
            else begin
                booth_encoder  u_booth_encoder (
                    .i_Qi_1     (i_q[i-1]),
                    .i_Qi       (i_q[i]),
                    .o_plus     (plus[i]),
                    .o_minus    (minus[i])
                );
            end
        end
    endgenerate

    
    logic [2 * N - 1: 0] carry [N - 1: 0];
    logic [2 * N + 1: 0] p [N: 0];
    logic [N - 1: 0] sign [N - 1: 0];

    // NOTE the first N bits P are 0s
    assign p[0] = {(2 * N + 1){1'b0}};

    // NOTE connect C[x][0] to minus[x]
    generate
        for (i = 0; i < N; i++) begin
            assign carry[i][0] = minus[i];
        end
    endgenerate

    // NOTE generate the mulpilier arrays
    generate
        for (i = 0; i < N; i++) begin
            for (j = 0; j < N; j++) begin
                // REVIEW See the extra notes as an example (M_0_0)
                multiplier_cell mc(
                    .i_pin(p[i][j+1]),  // P_0_1
                    .i_m(i_m[j]),       // m_0

                    .i_plus(plus[i]),   // plus_0
                    .i_minus(minus[i]), // minus_0

                    .i_Cin(carry[i][j]),// c_0_0

                    .o_Cout(carry[i][j+1]), // c_0_1
                    .o_Sign(sign[i][j]),    // sign_0_0
                    .o_pout(p[i+1][j])      // P_1_0
                );
            end

            // REVIEW See the extra notes as an example 
            for (j = 0; j < N - i; j++) begin
                // NOTE (FA_00) as an example 
                full_adder fa(
                    .A(p[i][j + N + 1]),
                    .B(sign[i][N - 1]),     // Sign_0_7
                    .Cin(carry[i][j + N]),  // C_0_8

                    .Cout(carry[i][j + N + 1]), // C_0_9
                    .S(p[i+1][j + N])
                );
            end 

            // NOTE assign the last N-1 bits to the result
            assign pout[i] = p[i+1][0];

            // NOTE assign the middle bits
            assign pout[i + N] = p[N][i+1];
        end
    endgenerate

    assign o_p = pout[2 * N - 2: 0];
    
endmodule