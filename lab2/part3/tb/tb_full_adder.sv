
// REVIEW testbench full adder

`timescale  1ns / 1ps   

module tb_full_adder;   

// full_adder Parameters
parameter PERIOD  = 10; 


// full_adder Inputs    
reg   A                                    = 0 ;
reg   B                                    = 0 ;
reg   Cin                                  = 0 ;

// full_adder Outputs
wire  logic Cout                           ;
wire  logic S                              ;


full_adder  u_full_adder (
    .A                       ( A            ),
    .B                       ( B            ),
    .Cin                     ( Cin          ),

    .Cout              ( Cout   ),
    .S                 ( S      )
);

initial
begin

    int i;
    int sum;

    // NOTE check them all
    for (i = 0; i < 8; i++) begin
        
        A = i % 2;
        B = (i >> 1) % 2;
        Cin = (i >> 2) % 2;
        sum = A + B + Cin;
        #10;
        $display("A: %d, B: %d, Cin: %d, S: %d Cout:%d - %s", A, B, Cin, S, Cout, (S==(sum % 2) && Cout== (sum >> 1)) ? "Correct" : "Wrong");
    end
    // $finish;
end

endmodule