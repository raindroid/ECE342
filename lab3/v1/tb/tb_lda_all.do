# REVIEW do file for the tb_line_drawing_algo

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_line_drawing_algo  

add wave -group output -unsigned -label o_x /tb_line_drawing_algo/o_x
add wave -group output -unsigned -label o_y /tb_line_drawing_algo/o_y
add wave -group output -label o_plot /tb_line_drawing_algo/o_plot
add wave -group output -label o_color /tb_line_drawing_algo/o_color
add wave -group output -label o_done /tb_line_drawing_algo/o_done

add wave -group sim_top /tb_line_drawing_algo/*

add wave -group inside /tb_line_drawing_algo/u_line_drawing_algo/*

add wave -group control /tb_line_drawing_algo/u_line_drawing_algo/u_lda_control/*

add wave -group datapath /tb_line_drawing_algo/u_line_drawing_algo/u_lda_datapath/*

run -all
