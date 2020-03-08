// Part1 system

module part1 #
(
	parameter HEX_FILE = "mem.hex" // You can change this here, or override it upon instantiation
)(
    input clk,
    input reset,
    input [7:0] i_SW,
    
    output logic [7:0] o_LEDR
);

    // REVIEW Declare the bus signals
    // NOTE cpu
    logic [15:0] cpu_mem_addr;
    logic cpu_mem_rd;
    logic [15:0] cpu_mem_rddata;
    logic cpu_mem_wr;
    logic [15:0] cpu_mem_wrdata;
    // NOTE memory
    logic [10:0] mem_addr;
    logic mem_wr;
    logic [15:0] mem_wrdata;
    logic [15:0] mem_rddata;
    // NOTE I/O
    logic [7:0] sw_D;
    logic [7:0] sw_Q;
    logic sw_en;
    logic [7:0] led_D;
    logic [7:0] led_Q;
    logic led_en;

    // decode input
    assign sw_D = i_SW;
    assign sw_en = '1;
    logic sel_in;
    reg_n #(16) input_decoder (
        .i_clk(clk),
        .i_reset(reset),
        .i_in(1),
        .i_din(cpu_mem_addr[15:12] == 4'h0),
        .o_dout(sel_in)
    );
    assign cpu_mem_rddata = (sel_in) ? mem_rddata : sw_Q;
    
    // decode output
    assign o_LEDR = led_Q;
    assign led_en = (cpu_mem_addr[15:12] == 4'h3) && cpu_mem_wr;
    assign led_D = cpu_mem_wrdata[7:0];

    // decode memory
    assign mem_addr = (cpu_mem_addr[15:12] == 4'h0) ? cpu_mem_addr[11:1] : 11'h0;
    assign mem_wr = (cpu_mem_addr[15:12] == 4'h0) && cpu_mem_wr;

    // I/O
    reg_n #(8) sw (
        .i_clk(clk),
        .i_reset(reset),
        .i_in(sw_en),
        .i_din(sw_D),
        .o_dout(sw_Q)
    );

    reg_n #(8) led (
        .i_clk(clk),
        .i_reset(reset),
        .i_in(led_en),
        .i_din(led_D),
        .o_dout(led_Q)
    );
    
    cpu CPU (
        .clk(clk),
        .reset(reset),
        .o_mem_addr(cpu_mem_addr),
        .o_mem_rd(cpu_mem_rd),
        .i_mem_rddata(cpu_mem_rddata),
        .o_mem_wr(cpu_mem_wr),
        .o_mem_wrdata(cpu_mem_wrdata)
    );

    mem4k #(HEX_FILE) memory(
        .clk(clk),
        .addr(mem_addr),
        .wrdata(mem_wrdata),
        .wr(mem_wr),
        .rddata(mem_rddata)
    );
    
endmodule