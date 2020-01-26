# REVIEW do file for the tb_wallace_tree_multiplier

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_wallace_tree_multiplier  
add wave /tb_wallace_tree_multiplier/*
add wave -label pout -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/pout    
add wave -label p0 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p0   
add wave -label p1 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p1   
add wave -label p2 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p2   
add wave -label p3 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p3   
add wave -label p4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p4   
# add wave -group fa /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/fa/*
run -all

