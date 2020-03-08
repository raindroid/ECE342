# REVIEW do file for the tb_part1

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_part1  
add wave -group sim_top -hex /tb_part1/*
add wave -group part1 -color #039be5 -hex /tb_part1/u_part1/*
add wave -group cpu_p -color #388e3c -hex /tb_part1/u_part1/CPU/BUS
add wave -group cpu_p -color #ae52d4 -hex /tb_part1/u_part1/CPU/GPR_data
add wave -group cpu -color #512da8 -hex /tb_part1/u_part1/CPU/*

run -all