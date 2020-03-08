module de1soc_top 
(
    // Clock pins
    input                       CLOCK_50,

    // Seven Segment Displays
    output      [ 6: 0]         HEX0,
    output      [ 6: 0]         HEX1,
    output      [ 6: 0]         HEX2,
    output      [ 6: 0]         HEX3,
    output      [ 6: 0]         HEX4,
    output      [ 6: 0]         HEX5,

    // Pushbuttons
    input       [ 3: 0]         KEY,

    // LEDs
    output      [ 9: 0]         LEDR,

    // Slider Switches
    input       [ 9: 0]         SW,

    // VGA
    output      [ 7: 0]         VGA_B,
    output                      VGA_BLANK_N,
    output                      VGA_CLK,
    output      [ 7: 0]         VGA_G,
    output                      VGA_HS,
    output      [ 7: 0]         VGA_R,
    output                      VGA_SYNC_N,
    output                      VGA_VS
);

part1 #(
    .HEX_FILE ( "mem.hex" ))
 u_part1 (
    .clk                     ( CLOCK_50           ),
    .reset                   ( ~KEY[0]        ),
    .i_SW                    ( SW),

    .o_LEDR                  ( LEDR )
);




endmodule
