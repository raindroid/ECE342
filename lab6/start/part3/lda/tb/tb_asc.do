# REVIEW do file for the tb_avalon_slave_controller

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_avalon_slave_controller  
add wave -group sim_top /tb_avalon_slave_controller/*
add wave -group avalog -color blue /u_avalon_slave_controller/*
run -all
