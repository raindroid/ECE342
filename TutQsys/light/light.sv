module lights (
    input CLOCK_50,
    input [7:0] SW,
    input [0:0] KEY,
    output [7:0] LEDR
);
    nios_system NiosII (
        .clk_clk(CLOCK_50),         //      clk.clk
        .leds_export(LEDR),     //     leds.export
        .reset_reset_n(KEY),   //    reset.reset_n
        .switches_export(SW)  // switches.export
    );
endmodule