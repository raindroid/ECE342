# REVIEW do file for the tb

vlib work
vlog *.sv 
vsim -novopt tb  
add wave -group sim_top -hex /tb/*
add wave -group branch_ctrl -color #fe346e -hex /tb/dut/branch_control/*
add wave -group s2 -color #00bdaa -hex /tb/dut/S2/*
add wave -group s3 -color #400082 -hex /tb/dut/S3/*
add wave -group cpu -hex /tb/dut/*


run 10000ps
#run 1300ps