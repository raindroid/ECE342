module vga_bmp
(
	input clk,
	input [8:0] x,
	input [7:0] y,
	input [2:0] color,
	input plot
);

localparam W = 336;
localparam H = 210;
localparam FILESIZE = 54 + 3*W*H;

bit [H-1:0][W-1:0][2:0] mem = '0;

always_ff @ (posedge clk) begin
	if (plot) mem[y][x] <= color;
end

// Hooray for StackOverflow. Adapted from C code.
// https://stackoverflow.com/questions/2654480/writing-bmp-image-in-pure-c-c-without-other-libraries
task write_bmp();
	integer fp;
	bit [0:13][7:0] bmpfileheader; 
	bit [0:39][7:0] bmpinfoheader; 
	
	fp = $fopen("vga.bmp", "wb");
	
	bmpfileheader = '0;
	bmpfileheader[0:1] = {"B","M"};
	bmpfileheader[10] = 8'd54;
	bmpfileheader[2] = FILESIZE[7:0];
	bmpfileheader[3] = FILESIZE[15:8];
	bmpfileheader[4] = FILESIZE[23:16];
	bmpfileheader[5] = FILESIZE[31:24];
	
	bmpinfoheader = '0;
	bmpinfoheader[0] = 8'd40;
	bmpinfoheader[12:14] = {8'd1, 8'd0, 8'd24};
	bmpinfoheader[4] = W[7:0];
	bmpinfoheader[5] = W[15:8];
	bmpinfoheader[6] = W[23:16];
	bmpinfoheader[7] = W[31:24];
	bmpinfoheader[8] = H[7:0];
	bmpinfoheader[9] = H[15:8];
	bmpinfoheader[10] = H[23:16];
	bmpinfoheader[11] = H[31:24];
	
	for (integer i = 0; i < 14; i++)
		$fwrite(fp, "%c", bmpfileheader[i]);
	for (integer i = 0; i < 40; i++)
		$fwrite(fp, "%c", bmpinfoheader[i]);
	
	for (integer y = 0; y < H; y++) begin
		for (integer x = 0; x < W; x++) begin
			$fwrite(fp, "%c%c%c", 
				{8{mem[H-y-1][x][0]}}, 
				{8{mem[H-y-1][x][1]}}, 
				{8{mem[H-y-1][x][2]}});
		end
		for (integer x = 0; x < (4-((W*3)%4))%4; x++) begin
			$fwrite(fp, "%c", 8'd0);
		end
	end
	
	$fclose(fp);
endtask;

endmodule