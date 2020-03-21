// Test 0: basic pipelining
//
// A sequence of non-branch, non-memory, independent instructions
// Minimum required IPC: 1.0

mvi r0, 7
mvi r1, 6
mvi r2, 5
mvi r3, 4
mvi r4, 3
mvi r5, 2
mvi r6, 1
mvi r7, 0

subi r0, 1
subi r1, 1
subi r2, 1
subi r3, 1
subi r4, 1
subi r5, 1
subi r6, 1
measure_end:
subi r7, 1

addi r0, 0
addi r0, 0
addi r0, 0
addi r0, 0
addi r0, 0

// Results section for simulator
.org 0x1000
.dw 0x0	// start PC of measurement region
.dw measure_end		// end PC
.dw 16	// number of instructions
.dw 0x80	// minimum IPC * 128
.dw 0b11111111	// which regs to check
.dw 6, 5, 4, 3, 2, 1, 0, -1	// correct reg values


