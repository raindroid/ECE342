`timescale 1ns/1ns

module testbench();

  logic [7:0] dut_x;
  logic [7:0] dut_y;
  logic [15:0] dut_debug_out;

  wallace_tree_multiplier dut_mult(dut_x, dut_y, dut_debug_out);
  

  logic dut_clk;
  initial dut_clk = 1'b0;
  always #1 dut_clk = ~dut_clk;

  initial begin

    @(posedge dut_clk);

    for (integer x = 0; x < 2**8; x++) begin
      for (integer y = 0; y < 2**8; y++) begin

        logic [15:0] product;
        product = x * y;

        dut_x = x[7:0];
        dut_y = y[7:0];

        @(posedge dut_clk);
        @(posedge dut_clk);
        if(dut_debug_out != product) begin
          $display("DUT output did not match Model output!");
          $display("Operands were: x = %0d, y = %0d", x, y);
          $display("DUT result was: %0d", dut_debug_out);
          $display("Expected result was: %0d", product);
          $stop;
        end

      end
    end

    $display("All cases passed!");
    $stop;

  end

endmodule
