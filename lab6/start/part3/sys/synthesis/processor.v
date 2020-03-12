// processor.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module processor (
		input  wire       clk_clk,                //             clk.clk
		output wire [7:0] lda_vga_b_export,       //       lda_vga_b.export
		output wire       lda_vga_blank_n_export, // lda_vga_blank_n.export
		output wire       lda_vga_clk_export,     //     lda_vga_clk.export
		output wire [7:0] lda_vga_g_export,       //       lda_vga_g.export
		output wire       lda_vga_hs_export,      //      lda_vga_hs.export
		output wire [7:0] lda_vga_r_export,       //       lda_vga_r.export
		output wire       lda_vga_sync_n_export,  //  lda_vga_sync_n.export
		output wire       lda_vga_vs_export,      //      lda_vga_vs.export
		output wire [9:0] led_o_export,           //           led_o.export
		output wire [6:0] quad_hex0_export,       //       quad_hex0.export
		output wire [6:0] quad_hex1_export,       //       quad_hex1.export
		output wire [6:0] quad_hex2_export,       //       quad_hex2.export
		output wire [6:0] quad_hex3_export,       //       quad_hex3.export
		input  wire       reset_reset_n,          //           reset.reset_n
		input  wire [9:0] sw_i_export             //            sw_i.export
	);

	wire  [15:0] cpu_0_avalon_master_readdata;                               // mm_interconnect_0:cpu_0_avalon_master_readdata -> cpu_0:i_mem_rddata
	wire         cpu_0_avalon_master_waitrequest;                            // mm_interconnect_0:cpu_0_avalon_master_waitrequest -> cpu_0:i_mem_wait
	wire  [15:0] cpu_0_avalon_master_address;                                // cpu_0:o_mem_addr -> mm_interconnect_0:cpu_0_avalon_master_address
	wire         cpu_0_avalon_master_read;                                   // cpu_0:o_mem_rd -> mm_interconnect_0:cpu_0_avalon_master_read
	wire         cpu_0_avalon_master_readdatavalid;                          // mm_interconnect_0:cpu_0_avalon_master_readdatavalid -> cpu_0:i_mem_rddatavalid
	wire         cpu_0_avalon_master_write;                                  // cpu_0:o_mem_wr -> mm_interconnect_0:cpu_0_avalon_master_write
	wire  [15:0] cpu_0_avalon_master_writedata;                              // cpu_0:o_mem_wrdata -> mm_interconnect_0:cpu_0_avalon_master_writedata
	wire         mm_interconnect_0_quad_hex_decode_0_avalon_slave_write;     // mm_interconnect_0:quad_hex_decode_0_avalon_slave_write -> quad_hex_decode_0:write
	wire  [15:0] mm_interconnect_0_quad_hex_decode_0_avalon_slave_writedata; // mm_interconnect_0:quad_hex_decode_0_avalon_slave_writedata -> quad_hex_decode_0:writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect;           // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
	wire  [15:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;             // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
	wire  [10:0] mm_interconnect_0_onchip_memory2_0_s1_address;              // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
	wire   [1:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable;           // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
	wire         mm_interconnect_0_onchip_memory2_0_s1_write;                // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
	wire  [15:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;            // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_clken;                // mm_interconnect_0:onchip_memory2_0_s1_clken -> onchip_memory2_0:clken
	wire  [31:0] mm_interconnect_0_sw_io_s1_readdata;                        // sw_io:readdata -> mm_interconnect_0:sw_io_s1_readdata
	wire   [1:0] mm_interconnect_0_sw_io_s1_address;                         // mm_interconnect_0:sw_io_s1_address -> sw_io:address
	wire         mm_interconnect_0_led_io_s1_chipselect;                     // mm_interconnect_0:led_io_s1_chipselect -> led_io:chipselect
	wire  [31:0] mm_interconnect_0_led_io_s1_readdata;                       // led_io:readdata -> mm_interconnect_0:led_io_s1_readdata
	wire   [1:0] mm_interconnect_0_led_io_s1_address;                        // mm_interconnect_0:led_io_s1_address -> led_io:address
	wire         mm_interconnect_0_led_io_s1_write;                          // mm_interconnect_0:led_io_s1_write -> led_io:write_n
	wire  [31:0] mm_interconnect_0_led_io_s1_writedata;                      // mm_interconnect_0:led_io_s1_writedata -> led_io:writedata
	wire  [31:0] mm_interconnect_0_lda_0_s1_readdata;                        // LDA_0:avs_s1_readdata -> mm_interconnect_0:LDA_0_s1_readdata
	wire         mm_interconnect_0_lda_0_s1_waitrequest;                     // LDA_0:avs_s1_waitrequest -> mm_interconnect_0:LDA_0_s1_waitrequest
	wire   [2:0] mm_interconnect_0_lda_0_s1_address;                         // mm_interconnect_0:LDA_0_s1_address -> LDA_0:avs_s1_address
	wire         mm_interconnect_0_lda_0_s1_read;                            // mm_interconnect_0:LDA_0_s1_read -> LDA_0:avs_s1_read
	wire   [3:0] mm_interconnect_0_lda_0_s1_byteenable;                      // mm_interconnect_0:LDA_0_s1_byteenable -> LDA_0:avs_s1_byteenable
	wire         mm_interconnect_0_lda_0_s1_write;                           // mm_interconnect_0:LDA_0_s1_write -> LDA_0:avs_s1_write
	wire  [31:0] mm_interconnect_0_lda_0_s1_writedata;                       // mm_interconnect_0:LDA_0_s1_writedata -> LDA_0:avs_s1_writedata
	wire         rst_controller_reset_out_reset;                             // rst_controller:reset_out -> [LDA_0:reset, cpu_0:reset, led_io:reset_n, mm_interconnect_0:cpu_0_reset_reset_bridge_in_reset_reset, onchip_memory2_0:reset, quad_hex_decode_0:reset, rst_translator:in_reset, sw_io:reset_n]
	wire         rst_controller_reset_out_reset_req;                         // rst_controller:reset_req -> [onchip_memory2_0:reset_req, rst_translator:reset_req_in]

	lda_peripheral lda_0 (
		.clk                    (clk_clk),                                //       clock.clk
		.reset                  (rst_controller_reset_out_reset),         //       reset.reset
		.avs_s1_address         (mm_interconnect_0_lda_0_s1_address),     //          s1.address
		.avs_s1_read            (mm_interconnect_0_lda_0_s1_read),        //            .read
		.avs_s1_readdata        (mm_interconnect_0_lda_0_s1_readdata),    //            .readdata
		.avs_s1_waitrequest     (mm_interconnect_0_lda_0_s1_waitrequest), //            .waitrequest
		.avs_s1_write           (mm_interconnect_0_lda_0_s1_write),       //            .write
		.avs_s1_writedata       (mm_interconnect_0_lda_0_s1_writedata),   //            .writedata
		.avs_s1_byteenable      (mm_interconnect_0_lda_0_s1_byteenable),  //            .byteenable
		.coe_VGA_B_export       (lda_vga_b_export),                       //       vga_b.export
		.coe_VGA_BLANK_N_export (lda_vga_blank_n_export),                 // vga_blank_n.export
		.coe_VGA_CLK_export     (lda_vga_clk_export),                     //     vga_clk.export
		.coe_VGA_G_export       (lda_vga_g_export),                       //       vga_g.export
		.coe_VGA_HS_export      (lda_vga_hs_export),                      //      vga_hs.export
		.coe_VGA_R_export       (lda_vga_r_export),                       //       vga_r.export
		.coe_VGA_SYNC_N_export  (lda_vga_sync_n_export),                  //  vga_sync_n.export
		.coe_VGA_VS_export      (lda_vga_vs_export)                       //      vga_vs.export
	);

	cpu cpu_0 (
		.clk               (clk_clk),                           //         clock.clk
		.reset             (rst_controller_reset_out_reset),    //         reset.reset
		.o_mem_addr        (cpu_0_avalon_master_address),       // avalon_master.address
		.o_mem_rd          (cpu_0_avalon_master_read),          //              .read
		.i_mem_rddata      (cpu_0_avalon_master_readdata),      //              .readdata
		.o_mem_wr          (cpu_0_avalon_master_write),         //              .write
		.o_mem_wrdata      (cpu_0_avalon_master_writedata),     //              .writedata
		.i_mem_wait        (cpu_0_avalon_master_waitrequest),   //              .waitrequest
		.i_mem_rddatavalid (cpu_0_avalon_master_readdatavalid)  //              .readdatavalid
	);

	processor_led_io led_io (
		.clk        (clk_clk),                                //                 clk.clk
		.reset_n    (~rst_controller_reset_out_reset),        //               reset.reset_n
		.address    (mm_interconnect_0_led_io_s1_address),    //                  s1.address
		.write_n    (~mm_interconnect_0_led_io_s1_write),     //                    .write_n
		.writedata  (mm_interconnect_0_led_io_s1_writedata),  //                    .writedata
		.chipselect (mm_interconnect_0_led_io_s1_chipselect), //                    .chipselect
		.readdata   (mm_interconnect_0_led_io_s1_readdata),   //                    .readdata
		.out_port   (led_o_export)                            // external_connection.export
	);

	processor_onchip_memory2_0 onchip_memory2_0 (
		.clk        (clk_clk),                                          //   clk1.clk
		.address    (mm_interconnect_0_onchip_memory2_0_s1_address),    //     s1.address
		.clken      (mm_interconnect_0_onchip_memory2_0_s1_clken),      //       .clken
		.chipselect (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //       .chipselect
		.write      (mm_interconnect_0_onchip_memory2_0_s1_write),      //       .write
		.readdata   (mm_interconnect_0_onchip_memory2_0_s1_readdata),   //       .readdata
		.writedata  (mm_interconnect_0_onchip_memory2_0_s1_writedata),  //       .writedata
		.byteenable (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset),                   // reset1.reset
		.reset_req  (rst_controller_reset_out_reset_req),               //       .reset_req
		.freeze     (1'b0)                                              // (terminated)
	);

	quad_hex_decode quad_hex_decode_0 (
		.clk       (clk_clk),                                                    //        clock.clk
		.HEX0      (quad_hex0_export),                                           //         hex0.export
		.HEX1      (quad_hex1_export),                                           //         hex1.export
		.HEX2      (quad_hex2_export),                                           //         hex2.export
		.HEX3      (quad_hex3_export),                                           //         hex3.export
		.write     (mm_interconnect_0_quad_hex_decode_0_avalon_slave_write),     // avalon_slave.write
		.writedata (mm_interconnect_0_quad_hex_decode_0_avalon_slave_writedata), //             .writedata
		.reset     (rst_controller_reset_out_reset)                              //        reset.reset
	);

	processor_sw_io sw_io (
		.clk      (clk_clk),                             //                 clk.clk
		.reset_n  (~rst_controller_reset_out_reset),     //               reset.reset_n
		.address  (mm_interconnect_0_sw_io_s1_address),  //                  s1.address
		.readdata (mm_interconnect_0_sw_io_s1_readdata), //                    .readdata
		.in_port  (sw_i_export)                          // external_connection.export
	);

	processor_mm_interconnect_0 mm_interconnect_0 (
		.clk_0_clk_clk                            (clk_clk),                                                    //                         clk_0_clk.clk
		.cpu_0_reset_reset_bridge_in_reset_reset  (rst_controller_reset_out_reset),                             // cpu_0_reset_reset_bridge_in_reset.reset
		.cpu_0_avalon_master_address              (cpu_0_avalon_master_address),                                //               cpu_0_avalon_master.address
		.cpu_0_avalon_master_waitrequest          (cpu_0_avalon_master_waitrequest),                            //                                  .waitrequest
		.cpu_0_avalon_master_read                 (cpu_0_avalon_master_read),                                   //                                  .read
		.cpu_0_avalon_master_readdata             (cpu_0_avalon_master_readdata),                               //                                  .readdata
		.cpu_0_avalon_master_readdatavalid        (cpu_0_avalon_master_readdatavalid),                          //                                  .readdatavalid
		.cpu_0_avalon_master_write                (cpu_0_avalon_master_write),                                  //                                  .write
		.cpu_0_avalon_master_writedata            (cpu_0_avalon_master_writedata),                              //                                  .writedata
		.LDA_0_s1_address                         (mm_interconnect_0_lda_0_s1_address),                         //                          LDA_0_s1.address
		.LDA_0_s1_write                           (mm_interconnect_0_lda_0_s1_write),                           //                                  .write
		.LDA_0_s1_read                            (mm_interconnect_0_lda_0_s1_read),                            //                                  .read
		.LDA_0_s1_readdata                        (mm_interconnect_0_lda_0_s1_readdata),                        //                                  .readdata
		.LDA_0_s1_writedata                       (mm_interconnect_0_lda_0_s1_writedata),                       //                                  .writedata
		.LDA_0_s1_byteenable                      (mm_interconnect_0_lda_0_s1_byteenable),                      //                                  .byteenable
		.LDA_0_s1_waitrequest                     (mm_interconnect_0_lda_0_s1_waitrequest),                     //                                  .waitrequest
		.led_io_s1_address                        (mm_interconnect_0_led_io_s1_address),                        //                         led_io_s1.address
		.led_io_s1_write                          (mm_interconnect_0_led_io_s1_write),                          //                                  .write
		.led_io_s1_readdata                       (mm_interconnect_0_led_io_s1_readdata),                       //                                  .readdata
		.led_io_s1_writedata                      (mm_interconnect_0_led_io_s1_writedata),                      //                                  .writedata
		.led_io_s1_chipselect                     (mm_interconnect_0_led_io_s1_chipselect),                     //                                  .chipselect
		.onchip_memory2_0_s1_address              (mm_interconnect_0_onchip_memory2_0_s1_address),              //               onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_write                (mm_interconnect_0_onchip_memory2_0_s1_write),                //                                  .write
		.onchip_memory2_0_s1_readdata             (mm_interconnect_0_onchip_memory2_0_s1_readdata),             //                                  .readdata
		.onchip_memory2_0_s1_writedata            (mm_interconnect_0_onchip_memory2_0_s1_writedata),            //                                  .writedata
		.onchip_memory2_0_s1_byteenable           (mm_interconnect_0_onchip_memory2_0_s1_byteenable),           //                                  .byteenable
		.onchip_memory2_0_s1_chipselect           (mm_interconnect_0_onchip_memory2_0_s1_chipselect),           //                                  .chipselect
		.onchip_memory2_0_s1_clken                (mm_interconnect_0_onchip_memory2_0_s1_clken),                //                                  .clken
		.quad_hex_decode_0_avalon_slave_write     (mm_interconnect_0_quad_hex_decode_0_avalon_slave_write),     //    quad_hex_decode_0_avalon_slave.write
		.quad_hex_decode_0_avalon_slave_writedata (mm_interconnect_0_quad_hex_decode_0_avalon_slave_writedata), //                                  .writedata
		.sw_io_s1_address                         (mm_interconnect_0_sw_io_s1_address),                         //                          sw_io_s1.address
		.sw_io_s1_readdata                        (mm_interconnect_0_sw_io_s1_readdata)                         //                                  .readdata
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                     // reset_in0.reset
		.clk            (clk_clk),                            //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),     // reset_out.reset
		.reset_req      (rst_controller_reset_out_reset_req), //          .reset_req
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

endmodule
