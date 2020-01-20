# REVIEW do file for the tb_signed_array_multiplier

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_signed_array_multiplier  
add wave /tb_signed_array_multiplier/*
add wave -color #ae52d4 /tb_signed_array_multiplier/u_signed_array_multiplier/p
add wave /tb_signed_array_multiplier/u_signed_array_multiplier/carry
add wave /tb_signed_array_multiplier/u_signed_array_multiplier/sign
add wave -color yellow /tb_signed_array_multiplier/u_signed_array_multiplier/plus
add wave -color yellow /tb_signed_array_multiplier/u_signed_array_multiplier/minus
run -all

