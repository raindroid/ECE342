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
add wave -color #ae52d4 -hex state nextstate o_remaining_attempts

force {clk} 0 0, 1 10ns -r 20ns
force {reset} 1 0, 0 20ns
force {i_enter} 0 0, 1 160ns 
# 1st try       
force {i_enter} 0 220ns, 1 540ns  
# 2nd try  
force {i_enter} 0 600ns, 1 850ns  
# 3rd try  
force {i_enter} 0 920ns, 1 990ns  
# 4th try  
force {i_enter} 0 1120ns, 1 1200ns  
# 5th try
force {i_enter} 0 1320ns, 1 1400ns 
# 6th try 
force {i_enter} 0 1520ns, 1 1600ns  
# 7th try   failed this time
force {i_enter} 0 1720ns, 1 1780ns  
# 8th try   correct but failed (not responding) 
force {i_enter} 0 1820ns, 1 1880ns  
force {i_enter} 0 1940ns  
force {i_equal} 0 0, 1 1900ns
run 2000ns

force {reset} 1 0, 0 20ns
force {i_enter} 0 0, 1 160ns 
# 1st try       
force {i_enter} 0 220ns, 1 540ns  
# 2nd try  
force {i_enter} 0 600ns, 1 850ns  
# 3rd try  
force {i_enter} 0 920ns, 1 990ns  
# 4th try  
force {i_enter} 0 1120ns, 1 1200ns  
# 5th try
force {i_enter} 0 1320ns, 1 1400ns 
# 6th try 
force {i_enter} 0 1520ns, 1 1600ns  
# 7th try   correct this time
force {i_enter} 0 1720ns, 1 1780ns  
# 8th try   failed (not responding) 
force {i_enter} 0 1820ns, 1 1880ns 
force {i_enter} 0 1940ns
force {i_equal} 0 0, 1 1720ns, 0 1780ns
run 2000ns
