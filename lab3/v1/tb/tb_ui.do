# REVIEW do file for the tb_user_interface

vlib work
vlog *.sv ../*.sv
vsim -novopt tb_user_interface  
add wave -group sim_top /tb_user_interface/*
add wave -color green -group ui_control -label clk /tb_user_interface/u_user_interface/u_ui_control/clk
add wave -color green -group ui_control -label reset /tb_user_interface/u_user_interface/u_ui_control/reset
add wave -color green -group ui_control -label i_go /tb_user_interface/u_user_interface/u_ui_control/i_go
add wave -color green -group ui_control -label i_done /tb_user_interface/u_user_interface/u_ui_control/i_done

add wave -color orange -group ui_control -label o_updateXY /tb_user_interface/u_user_interface/u_ui_control/o_updateXY
add wave -color orange -group ui_control -label o_draw /tb_user_interface/u_user_interface/u_ui_control/o_draw

add wave -color yellow -group ui_control -label state /tb_user_interface/u_user_interface/u_ui_control/state
add wave -color yellow -group ui_control -label next_state /tb_user_interface/u_user_interface/u_ui_control/next_state


add wave -color green -group ui_datapath -label clk /tb_user_interface/u_user_interface/u_ui_datapath/clk
add wave -color green -group ui_datapath -label reset /tb_user_interface/u_user_interface/u_ui_datapath/reset
add wave -color green -group ui_datapath -label i_setX /tb_user_interface/u_user_interface/u_ui_datapath/i_setX
add wave -color green -group ui_datapath -label i_setY /tb_user_interface/u_user_interface/u_ui_datapath/i_setY
add wave -color green -group ui_datapath -label i_set_col /tb_user_interface/u_user_interface/u_ui_datapath/i_set_col
add wave -color green -group ui_datapath -label i_updateXY /tb_user_interface/u_user_interface/u_ui_datapath/i_updateXY
add wave -color green -group ui_datapath -label i_val /tb_user_interface/u_user_interface/u_ui_datapath/i_val

add wave -color orange -group ui_datapath -label tempX /tb_user_interface/u_user_interface/u_ui_datapath/tempX
add wave -color orange -group ui_datapath -label tempY /tb_user_interface/u_user_interface/u_ui_datapath/tempY

add wave -color yellow -group ui_datapath -label o_color /tb_user_interface/u_user_interface/u_ui_datapath/o_color
add wave -color yellow -group ui_datapath -label o_x0 /tb_user_interface/u_user_interface/u_ui_datapath/o_x0
add wave -color yellow -group ui_datapath -label o_y0 /tb_user_interface/u_user_interface/u_ui_datapath/o_y0
add wave -color yellow -group ui_datapath -label o_x1 /tb_user_interface/u_user_interface/u_ui_datapath/o_x1
add wave -color yellow -group ui_datapath -label o_y1 /tb_user_interface/u_user_interface/u_ui_datapath/o_y1
run 800ns

