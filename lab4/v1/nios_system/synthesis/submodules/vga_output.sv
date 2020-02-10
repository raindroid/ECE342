module vga_output #
(
	parameter SCALE,
	parameter BITS_PER_CHANNEL,
	parameter N_PIXELS = 1680*1050/SCALE/SCALE,
	parameter N_PIXELS2 = $clog2(N_PIXELS)
)
(
	input clk147,
	input reset,

	output [N_PIXELS2-1:0] o_addr,
	input [2:0][BITS_PER_CHANNEL-1:0] i_pixel,
	
    output [7:0] VGA_B,
    output VGA_BLANK_N,
    output VGA_CLK,
    output [7:0] VGA_G,
    output VGA_HS,
    output [7:0] VGA_R,
    output VGA_SYNC_N,
    output VGA_VS
);

//
// Native resolution counters
//

localparam X_VISIBLE = 1680;
localparam X_FRONT_PORCH = 104;
localparam X_SYNC = 184;
localparam X_BACK_PORCH = 288;
localparam X_TOTAL = X_VISIBLE + X_FRONT_PORCH + X_SYNC + X_BACK_PORCH;
localparam X_TOTAL2 = $clog2(X_TOTAL);

localparam Y_VISIBLE = 1050;
localparam Y_FRONT_PORCH = 1;
localparam Y_SYNC = 3;
localparam Y_BACK_PORCH = 33;
localparam Y_TOTAL = Y_VISIBLE + Y_FRONT_PORCH + Y_SYNC + Y_BACK_PORCH;
localparam Y_TOTAL2 = $clog2(Y_TOTAL);

logic [X_TOTAL2-1:0] x_native;
logic [Y_TOTAL2-1:0] y_native;

logic x_native_last;
wire y_native_inc = x_native_last;

// Sweep x_native/y_native counters over total native area
always_ff @ (posedge clk147 or posedge reset) begin
	if (reset) begin
		x_native <= '0;
		y_native <= '0;
		// synthesis translate_off
		x_native_last = '0;
		// synthesis translate_on
	end
	else begin
		x_native_last <= x_native == X_TOTAL - 2;
		x_native <= x_native_last ? '0 : x_native + 1;		
		
		if (y_native_inc) begin
			y_native <= y_native == Y_TOTAL-1 ? '0 : y_native + 1;
		end
	end
end	


//
// The native x/y counters are the start of a pipeline that fetches
// RGB data from on-chip memory, generates sync signals, and outputs
// them to the IOs.
//
// At the start is the blank_n signal which is a registered signal
// derived from the x/y counters being in the active display region.
//
// At the same pipeline depth as the blank_n signal is the address
// counter that fetches from RAM. When blank_n is active (low), this counter
// increments.
//
// The address counter goes to RAM, which returns RGB data for the pixel 2 cycles later.
//
// The RGB data goes straight into 3 R/G/B registers which are inside the IO banks.
// Thus, address->io is 4 registers deep. Everything else must synchronize with that.
//
// The BLANK_N signal itself also goes to the ADC and must arrive at the same time as
// the RGB signals.
//
// Now, the HSYNC/VSYNC signals _DO NOT_ go to the ADC. Rather, they go straight into
// the VGA cable. This means we have to add delay to them so, at the VGA cable, 
// all signals line up. The ADC adds 1 cycle of pipeline delay, and then another 7.5ns
// to the analog output. We invert the VGA clock before it leaves the chip, which adds
// another half-period of a 147.14MHz signal to the delay.
// In total, the required delay to be added to HS/VS is very close to 3 clock cycles, so
// we add 3 extra registers on the HS/VS pipeline for a total of 7.



// Derive HS/VS/BLANK_N from counters.
//
// 
logic [6:0] hsync;
logic [6:0] vsync;
logic [3:0] blank_n;

always_ff @ (posedge clk147) begin
	// Hsync polarity negative
	hsync[0] <= !(
		x_native >= (X_VISIBLE + X_FRONT_PORCH) &&
		x_native < (X_VISIBLE + X_FRONT_PORCH + X_SYNC));
	
	// Vsync polarity positive
	vsync[0] <=
		y_native >= (Y_VISIBLE + Y_FRONT_PORCH) &&
		y_native < (Y_VISIBLE + Y_FRONT_PORCH + Y_SYNC);
	
	// blank_n is 0 when outside visible area
	blank_n[0] <= x_native < X_VISIBLE && y_native < Y_VISIBLE;
	
	// Make pipeline shift regs
	hsync[6:1] <= hsync[5:0];
	vsync[6:1] <= vsync[5:0];
	blank_n[3:1] <= blank_n[2:0];
end

//
// This makes pixels bigger. We don't increment the address every native pixel, but rather
// every SCALE pixels, both in the X and Y direction. In the X direction is easy... we keep
// an x_blk counter that goes from 0->SCALE-1 and only increment the address when it's SCALE-1.
//
// In the Y direction, in order to repeat many horizontal lines SCALE number of times, we must
// remember the base_addr for that line and reset addr=base_addr every time we want to repeat
// that line again. A y_blk counter goes from 0->SCALE-1 to tell us when it's time to actually
// advance the base_addr to the next virtual line.
localparam SCALE2 = $clog2(SCALE);
logic [SCALE2-1:0] x_blk, y_blk;
logic x_blk_last, y_blk_last;
logic [N_PIXELS2-1:0] pix_line_addr;
logic end_of_visible_line;

always_ff @ (posedge clk147 or posedge reset) begin
	if (reset) begin
		x_blk <= '0;
		y_blk <= '0;
		x_blk_last <= '0;
		y_blk_last <= '0;
		pix_line_addr <= '0;
		end_of_visible_line <= '0;
	end
	else begin
		end_of_visible_line <= y_native < Y_VISIBLE && x_native == X_VISIBLE-1;
		
		// xblk changes on valid visible part of horizontal line
		if (blank_n[0]) begin
			x_blk <= x_blk_last ? '0 : x_blk + 1;
			x_blk_last <= x_blk == SCALE-2;
		end
		else begin
			// Reset in-between visible lines
			x_blk <= '0;
		end
		
		// yblk changes at the end of a visible native line.
		// This also means it's incremented right before the overscan
		// for the same native line starts.
		if (vsync[0]) begin
			// Reset in between frames, just in case
			y_blk <= '0;
		end
		else if (end_of_visible_line) begin
			y_blk <= y_blk_last ? '0 : y_blk + 1;
			y_blk_last <= y_blk == SCALE-2;
		end
		
		if (vsync[0]) begin
			// Reset on vsync before next frame
			pix_line_addr <= '0;
		end
		else if (end_of_visible_line && y_blk_last) begin
			// Updates at the beginning of the overscan area
			// following the end of the SCALEth line.
			pix_line_addr <= pix_line_addr + X_VISIBLE/SCALE;
		end
	end
end

// Manage the address counter
logic [N_PIXELS2-1:0] pix_addr;

always_ff @ (posedge clk147 or posedge reset) begin
	if (reset) begin
		pix_addr <= '0;
	end
	else begin
		// At the end of every native line (and one cycle early
		// because these registers are a stage ahead of x/y_native),
		// reload pix_addr to be pix_addr_base for the next line.
		//
		// Within a line, every time we get x_blk_last, increment by 1
		if (y_native_inc) pix_addr <= pix_line_addr;
		else if (x_blk_last) pix_addr <= pix_addr + 1;
	end
end

// Send address to RAM
assign o_addr = pix_addr;

// Make IO registers for R/G/B data.
// Also: expand the data to 8 bits in a way that
// tries to saturate its full range, even if
// the bit depth isn't 8 bits per pixel.
// If we do this by simply padding with zeros, then
// in the extreme case(in 1bpp mode), each channel
// can only ever be half-bright.
//
// So instead of just padding the channel data with zeros,
// those zeros are replaced with a replication (as many times
// as possible) with the channel data.
// So now in 1bpp, this expands to 00000000 and 11111111 as desired.
// In, say, 5bpp mode, a colour value whose bits are ABCDE are now
// expanded to ABCDEABC.
logic [2:0][7:0] io_rgb;
always_ff @ (posedge clk147) begin
	for (integer channel = 0; channel < 3; channel++) begin
		for (integer i = 0; i < 8; i++) begin
			io_rgb[channel][7-i] <= 
				i_pixel[channel][ BITS_PER_CHANNEL-1 - (i % BITS_PER_CHANNEL) ];
		end
	end
end

// Connect to IO pads
assign VGA_R = io_rgb[0];
assign VGA_G = io_rgb[1];
assign VGA_B = io_rgb[2];
assign VGA_BLANK_N = blank_n[3];
assign VGA_SYNC_N = 1'b0; // we don't need sync-on-green in VGA
assign VGA_HS = hsync[6];
assign VGA_VS = vsync[6];

// Finally, drive the VGA clock. Normally, we'd just assign VGA_CLK=clk147.
// However, we'd like to invert the clock first, to give better setup/hold
// time margins for the R/G/B/blank signals as they arrive at the ADC chip.
//
// Instead of using a lut-based inverter, we're going to use an
// ALTDDIO_OUT megafunction. This is a 2-to-1 mux located right in the IO pad.
// We mux between 1 and 0 using the clock as the select. The theory is that
// because it's in the IO pad, the clock will arrive here at around the same
// time the clock arrives at the IO registers, giving lower and more predictable skew.


altddio_out #
(
	.WIDTH(1)
)
clk_driver
(
	.datain_h(1'b0),
	.datain_l(1'b1),
	.outclock(clk147),
	.dataout(VGA_CLK)
);
/*
assign VGA_CLK = ~clk147;
*/

endmodule
