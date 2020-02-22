# REVIEW do file for the tb

vlib work
vlog *.sv 
vsim -novopt tb  
add wave -group sim_top -hex /tb/*
# add wave -group sim_top -color #ae52d4 -hex /tb/mem # too large to log
add wave -group cpu -hex /tb/dut/*
add wave -group cpu -color #388e3c -hex /tb/dut/BUS
add wave -group cpu -color #ae52d4 -hex /tb/dut/GPR_data


run 300000ps