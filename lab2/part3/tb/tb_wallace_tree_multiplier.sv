// REVIEW testbench SAM

`timescale  1ns / 1ps

module tb_wallace_tree_multiplier;

// wallace_tree_multiplier Parameters
parameter PERIOD = 10;
parameter N  = 8;

// wallace_tree_multiplier Inputs
reg   [N - 1: 0]  i_m                      = 0 ;
reg   [N - 1: 0]  i_q                      = 0 ;

// wallace_tree_multiplier Outputs
wire  [2 * N - 1: 0]  o_p                  ;

wallace_tree_multiplier u_wallace_tree_multiplier (
    .i_m                     ( i_m  [N - 1: 0]     ),
    .i_q                     ( i_q  [N - 1: 0]     ),

    .o_p                     ( o_p  [2 * N - 1: 0] )
);

initial
begin

    int m, q;
    int expected;

    int correct_cnt;
    int wrong_cnt;

    int limit = 256; // (2 << (N - 1));

    // NOTE Single Test
    // m = 15;
    // q = 16;
    // expected = m * q;
    // i_m = m;
    // i_q = q;
    // #1;
    
    // if (o_p == m * q) correct_cnt ++;
    // else wrong_cnt ++;
    // $display("M: %5d, Q: %5d, Expected: %5d, Result: %5d (0x%4x) - %s", m, q, expected, o_p, o_p, (o_p == m * q) ? "Correct" : "Wrong");

    // NOTE Test all values
    for (m = 0; m < limit; m++) begin
        for (q = 0; q < limit; q++) begin  
            i_m = m;
            i_q = q;
            #1;

            expected = m * q;
            if (o_p == m * q) correct_cnt ++;
            else wrong_cnt ++;
            $display("M: %5d, Q: %5d, Expected: %5d, Result: %5d (0x%4x) - %s", m, q, expected, o_p, o_p, (o_p == m * q) ? "Correct" : "Wrong");
        end
    end

    $display("\nCorrect: %5d, Wrong: %5d. DONE", correct_cnt, wrong_cnt);

    // $finish;
end

endmodule