
// REVIEW testbench half adder
`timescale  1ns / 1ps

module tb_half_adder;

// half_adder Parameters
parameter PERIOD  = 10;


// half_adder Inputs
reg   A                                    = 0 ;
reg   B                                    = 0 ;

// half_adder Outputs
wire  logic Cout                           ;    
wire  logic S                              ;    


half_adder  u_half_adder (
    .A                       ( A            ),
    .B                       ( B            ),

    .Cout              (Cout   ),
    .S                 (S      )
);

initial
begin

    int i;
    int sum;

    // NOTE check them all
    for (i = 0; i < 4; i++) begin
        
        A = i % 2;
        B = (i >> 1) % 2;
        sum = A + B;
        #10;
        $display("A: %d, B: %d, S: %d Cout:%d - %s", A, B, S, Cout, (S==(sum % 2) && Cout== (sum >> 1)) ? "Correct" : "Wrong");
    end
    // $finish;
end

endmodule