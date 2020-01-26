# REVIEW do file for the tb_multiplier_cell
# NOTE This file is abandoned

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_multiplier_cell  
add wave /tb_multiplier_cell/*
run -all

