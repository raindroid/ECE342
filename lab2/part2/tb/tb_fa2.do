# REVIEW do file for the tb_fast_adder

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_fast_adder  
add wave /tb_fast_adder/*
run -all

