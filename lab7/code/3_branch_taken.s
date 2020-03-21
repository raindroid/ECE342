// Test 3: branches taken
//
// Tests branches, conditional or not, that are taken.
// Correctness is tested via making sure that the instructions
// behind the branch get squashed properly.
// Minimum required IPC: 1.0

// Error flags - these should remain at 0.
// If they get incremented, your CPU failed to squash either of the
// two instructions in the pipeline behind the branch
mvi r5, 0
mvi r6, 0

// Test call instruction
call testfunc
addi r5, 1	// these two should be skipped over when returning
addi r6, 1
j .0f	// call returns here

addi r5, 1
addi r6, 1

testfunc:
	addi r7, 4	// when we return, skip two instructions
	jr r7	// we get to test JR here

addi r5, 1
addi r6, 1

// Test callr similarly
.0:
mvi r7, testfunc
callr r7
addi r5, 1
addi r6, 1
j .0f

addi r5, 1
addi r6, 1

// Test jzr
.0:
mvi r0, 1
addi r0, 0
subi r0, 1
mvi r7, .0f
jzr r7

addi r5, 1
addi r6, 1

// Test jnr
.0:
mvi r0, 0
subi r0, 1
subi r0, 1
mvi r7, .0f
jnr r7

addi r5, 1
addi r6, 1

// Test jz
.0:
mvi r0, 1
addi r0, 0
subi r0, 1
jz .0f

addi r5, 1
addi r6, 1

// Test jn
.0:
mvi r0, 0
subi r0, 1
subi r0, 1
jn measure_end

addi r5, 1
addi r6, 1

measure_end:
j measure_end


// Results section for simulator
.org 0x1000
.dw 0x0	// start PC of measurement region
.dw measure_end		// end PC
.dw 30		// number of instructions
.dw 0x40	// minimum IPC * 128
.dw 0b01100000	// which regs to check
.dw 0, 0, 0, 0, 0, 0, 0, 0	// correct reg values


