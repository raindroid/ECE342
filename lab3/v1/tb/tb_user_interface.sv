// REVIEW tb_ui testbench sv
`timescale  1ns / 1ps

module tb_user_interface;

// user_interface Parameters
parameter PERIOD  = 10;


// user_interface Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
logic  i_setX;
logic  i_setY;
logic  i_set_col;
logic  i_go;
logic  [8:0]  i_val;
logic  i_done;

// user_interface Outputs
logic o_start      ;
logic [2:0] o_color;
logic [8:0] o_x0   ;
logic [7:0] o_y0   ;
logic [8:0] o_x1   ;
logic [7:0] o_y1   ;
logic [3:0] KEY;
logic [9:0] SW;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

user_interface  u_user_interface (
    .clk          (clk      ),
    .reset        (~rst_n    ),
    .i_setX       (i_setX   ),
    .i_setY       (i_setY   ),
    .i_set_col    (i_set_col),
    .i_go         (i_go     ),
    .i_val        (i_val    ),
    .i_done       (i_done   ),

    .o_start     ( o_start ),
    .o_color     (o_color  ),
    .o_x0        (o_x0     ),
    .o_y0        (o_y0     ),
    .o_x1        (o_x1     ),
    .o_y1        (o_y1     )
);


assign {i_go, i_set_col, i_setY, i_setX} = KEY;
assign i_val = SW[8:0];
int x0, y0, x1, y1;

initial
begin
    KEY = 4'b0;
    SW = 0;
    i_done = 0;
    #40;    // Wait for reseting
    
    // NOTE Set X0
    x0 = $urandom_range(0,335);
    SW = x0;
    KEY = 4'b1;
    #10;

    // NOTE Set Y0
    SW = $urandom_range(0,209);
    KEY = 4'b10;
    #10;

    // NOTE Set Color
    SW = $urandom_range(1,7);
    KEY = 4'b100;
    #10;

    // NOTE Draw
    KEY = 4'b1000; 
    #50
    KEY = '0;
    #100;
    i_done = 1;
    #10;
    i_done = 0;

    // NOTE Set X0
    SW = $urandom_range(0,335);
    KEY = 4'b1;
    #10;

    // NOTE Set Y0
    SW = $urandom_range(0,209);
    KEY = 4'b10;
    #10;

    // NOTE Set Color
    SW = $urandom_range(1,7);
    KEY = 4'b100;
    #10;

    // NOTE Draw
    KEY = 4'b1000; 
    #10;
    KEY = '0;
    #100;
    i_done = 1;
    #10;
    i_done = 0;
    #100;

    $display("tb done!");
    $stop;
end

endmodule