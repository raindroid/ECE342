create_clock -period 1ns [get_ports clk]
set_false_path -from reset -to *
