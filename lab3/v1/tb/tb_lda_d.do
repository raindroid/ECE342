# REVIEW do file for the tb_lda_datapath

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_lda_datapath  
add wave -group sim_top /tb_lda_datapath/*
add wave -group -unsigned all_data /tb_lda_datapath/u_lda_datapath/*
add wave -group clear_data -label clear_x -unsigned /tb_lda_datapath/u_lda_datapath/clear_x
add wave -group clear_data -label clear_y -unsigned /tb_lda_datapath/u_lda_datapath/clear_y
add wave -group clear_data -label clear_i -unsigned /tb_lda_datapath/u_lda_datapath/clear_i

add wave -group draw_data -label draw_x -unsigned /tb_lda_datapath/u_lda_datapath/draw_x
add wave -group draw_data -label draw_y -unsigned /tb_lda_datapath/u_lda_datapath/draw_y
add wave -group draw_data -label draw_plot -unsigned /tb_lda_datapath/u_lda_datapath/draw_plot
add wave -group draw_data -label draw_color -unsigned /tb_lda_datapath/u_lda_datapath/draw_color
add wave -group draw_data -label steep -unsigned /tb_lda_datapath/u_lda_datapath/steep
add wave -group draw_data -label error -signed /tb_lda_datapath/u_lda_datapath/error
add wave -group draw_data -label error_temp -signed /tb_lda_datapath/u_lda_datapath/error_temp


add wave -group draw_data -label after_steep_x0 -unsigned /tb_lda_datapath/u_lda_datapath/after_steep_x0
add wave -group draw_data -label after_steep_y0 -unsigned /tb_lda_datapath/u_lda_datapath/after_steep_y0
add wave -group draw_data -label after_steep_x1 -unsigned /tb_lda_datapath/u_lda_datapath/after_steep_x1
add wave -group draw_data -label after_steep_y1 -unsigned /tb_lda_datapath/u_lda_datapath/after_steep_y1

run -all
