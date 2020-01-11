# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog *.sv

#load simulation using mux as the top level simulation module
vsim control

#log all signals and add some signals to waveform window
log {/*}

add wave -color yellow clk reset 
add wave -color green i_enter  i_over i_under i_equal 
add wave -color blue o_inc_actual o_update_leds
add wave -color #ae52d4 -hex state nextstate

force {clk} 0 0, 1 10ns -r 20ns
force {reset} 1 0, 0 20ns
force {i_enter} 0 0, 1 160ns, 0 220ns, 1 540ns, 0 600ns, 1 850ns, 0 920ns
force {i_equal} 0 0, 1 900ns
run 1000ns