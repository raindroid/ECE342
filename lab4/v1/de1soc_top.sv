module de1soc_top 
(
	// These are the board inputs/outputs required for all the ECE342 labs.
	// Each lab can use the subset it needs -- unused pins will be ignored.
	
    // Clock pins
    input                     CLOCK_50,

    // Seven Segment Displays
    output      [6:0]         HEX0,
    output      [6:0]         HEX1,
    output      [6:0]         HEX2,
    output      [6:0]         HEX3,
    output      [6:0]         HEX4,
    output      [6:0]         HEX5,

    // Pushbuttons
    input       [3:0]         KEY,

    // LEDs
    output      [9:0]         LEDR,

    // Slider Switches
    input       [9:0]         SW,

    // VGA
    output      [7:0]         VGA_B,
    output                    VGA_BLANK_N,
    output                    VGA_CLK,
    output      [7:0]         VGA_G,
    output                    VGA_HS,
    output      [7:0]         VGA_R,
    output                    VGA_SYNC_N,
    output                    VGA_VS
);

// This generates a one-time ACTIVE-LOW asynchronous reset
// signal on powerup. You can use it for the Qsys system.
logic reset_n;
logic [1:0] reset_reg;
always_ff @ (posedge CLOCK_50) begin
	reset_n <= reset_reg[0];
	reset_reg <= {1'b1, reset_reg[1]};
end

//
// INSTANTIATE QSYS SYSTEM HERE
//


    nios_system NiosII (
        .clk_clk(CLOCK_50),         //      clk.clk
        .leds_export(LEDR[7:0]),     //     leds.export
        .reset_reset_n(KEY[0:0]),   //    reset.reset_n
        .switches_export(SW[7:0]),  // switches.export
		.lda_vga_b_export       (VGA_B),       //       lda_vga_b.export
		.lda_vga_blank_n_export (VGA_BLANK_N), // lda_vga_blank_n.export
		.lda_vga_clk_export     (VGA_CLK),     //     lda_vga_clk.export
		.lda_vga_g_export       (VGA_G),       //       lda_vga_g.export
		.lda_vga_hs_export      (VGA_HS),      //      lda_vga_hs.export
		.lda_vga_r_export       (VGA_R),       //       lda_vga_r.export
		.lda_vga_sync_n_export  (VGA_SYNC_N),  //  lda_vga_sync_n.export
		.lda_vga_vs_export      (VGA_VS)       //      lda_vga_vs.export
    );


endmodule