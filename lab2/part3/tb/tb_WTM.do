# REVIEW do file for the tb_wallace_tree_multiplier

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_wallace_tree_multiplier  
add wave -label i_m /tb_wallace_tree_multiplier/i_m
add wave -label i_q /tb_wallace_tree_multiplier/i_q
add wave -label o_p /tb_wallace_tree_multiplier/o_p

add wave -label p /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p  
add wave -label s0 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/s0   
add wave -label c0 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/c0   
add wave -label s1 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/s1   
add wave -label c1 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/c1   
add wave -label s2 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/s2   
add wave -label c2 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/c2   
add wave -label s3 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/s3   
add wave -label c3 -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/c3   

# add wave -label pout -color #ae52d4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/pout    
# add wave -label p0 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p0   
# add wave -label p1 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p1   
# add wave -label p2 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p2   
# add wave -label p3 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p3   
# add wave -label p4 /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/p4   
# add wave -group fa /tb_wallace_tree_multiplier/u_wallace_tree_multiplier/fa/*
run -all

