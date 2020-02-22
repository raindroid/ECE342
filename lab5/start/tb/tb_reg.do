# REVIEW do file for the tb_reg_n

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_reg_n  
add wave -color #ae52d4 -hex /tb_reg_n/*

run -all