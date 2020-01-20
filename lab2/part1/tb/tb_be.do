# REVIEW do file for the tb_booth_encoder

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_booth_encoder  
add wave /tb_booth_encoder/*
run -all

