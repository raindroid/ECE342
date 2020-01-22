# REVIEW do file for the tb_carry_save_multiplier

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_carry_save_multiplier  
add wave /tb_carry_save_multiplier/*
add wave -color #ae52d4 /tb_carry_save_multiplier/u_carry_save_multiplier/p
add wave /tb_carry_save_multiplier/u_carry_save_multiplier/carry
add wave /tb_carry_save_multiplier/u_carry_save_multiplier/mq
add wave /tb_carry_save_multiplier/u_carry_save_multiplier/fa/*
run -all

