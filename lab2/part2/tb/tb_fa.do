# REVIEW do file for the tb_full_adder

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_full_adder  
add wave /tb_full_adder/*
run -all

