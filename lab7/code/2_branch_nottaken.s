// Test 2: branches not taken
//
// Tests conditional branches that are not taken (PC=PC+2 assumption is always right)
// Minimum required IPC: 1.0

// Should be 1 at the end
mvi r6, 0

// Error flag
mvi r7, 0

// Test jz
mvi r0, 0
addi r0, 0
addi r6, 1
addi r0, 1
jz error

// Test jn
mvi r0, 0
subi r0, 1
addi r0, 1
jn error

// Test jzr
mvi r1, error
mvi r0, 0
addi r0, 0
addi r0, 1
jzr r1

// Test jnr
mvi r0, 0
subi r0, 1
addi r0, 1
jnr r1

measure_end:
j measure_end

error:
mvi r7, 1
j measure_end



// Results section for simulator
.org 0x1000
.dw 0x0	// start PC of measurement region
.dw measure_end		// end PC
.dw 21	// number of instructions
.dw 0x80	// minimum IPC * 128
.dw 0b11000000	// which regs to check
.dw 0, 0, 0, 0, 0, 0, 1, 0	// correct reg values


