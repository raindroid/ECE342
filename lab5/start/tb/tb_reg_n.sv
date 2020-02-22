`timescale  1ns / 1ps

module tb_reg_n;

// reg_n Parameters
parameter PERIOD = 10;
parameter N  = 16;

// reg_n Inputs
reg   clk                                = 0 ;
reg   rst_n                              = 0;
reg   i_in                                 = 0 ;
reg   i_hin                                 = 0 ;
reg   i_incr                                 = 0 ;
reg   [N-1:0]  i_din                       = 0 ;

// reg_n Outputs
wire  logic [N-1:0] o_dout                 ;    


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

// gpr_n #(
//     .N ( N ))
//  u_reg_n (
//     .i_clk                   ( clk                         ),
//     .i_reset                 ( ~rst_n                       ),
//     .i_in                    ( i_in                          ),
//     .i_hin                   (i_hin),
//     .i_din                   ( i_din      ),

//     .o_dout    ( o_dout          )
// );

pc_n #(
    .N ( N ))
 u_reg_n (
    .i_clk                   ( clk                         ),
    .i_reset                 ( ~rst_n                       ),
    .i_in                    ( i_in                          ),
    .i_incr                   (i_incr),
    .i_din                   ( i_din      ),

    .o_dout    ( o_dout          )
);

initial
begin
    #20;
    i_in = 1;
    i_din = 0'h7f_bd;
    #20;
    i_in = 0;
    i_din = 0'h90_aa;
    #100
    i_hin = 1;
    i_incr = 1;
    #100;
    $stop;
end

endmodule