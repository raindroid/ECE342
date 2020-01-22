// REVIEW tb_fast_adder
`timescale  1ns / 1ps

module tb_fast_adder;

// fast_adder Parameters
parameter PERIOD = 10;
parameter N  = 8;

// fast_adder Inputs
reg   [N-1:0]  A                           = 0 ;
reg   [N-1:0]  B                           = 0 ;
reg   Cin                                  = 0 ;

// fast_adder Outputs
wire  logic Cout                           ;    
wire  logic [N - 1: 0]S                    ;    



fast_adder #(
    .N ( N ))
 u_fast_adder (
    .A                       ( A [N-1:0] ),
    .B                       ( B [N-1:0] ),
    .Cin                     ( Cin ),

    .Cout              ( Cout        ),
    .S       ( S )
);

wire [N: 0] res;
assign res = {Cin, S};

initial
begin

    A = 8'd122;
    B = 8'd13;
    
    #10;

    $display("A: %d, B: %d, expected: %d, res: %d", A, B, A + B, res);

    // $finish;
end

endmodule