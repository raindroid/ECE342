# REVIEW do file for the tb_half_adder

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_half_adder  
add wave /tb_half_adder/*
run -all

