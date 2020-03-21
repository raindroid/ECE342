// Test 4: memory dependence and forwarding
//
// Tests load and store forwarding
// Minimum required IPC: 1.0

// Pointer chase: r0 = memvar1, r0 = *memvar1 = memvar2, r1 = *memvar2 = 5
mvi r0, 0
mvi r0, memvar1
ld r0, r0
ld r1, r0

addi r1, 5	// data += 5
addi r0, 2	// address += 2
st r1, r0

// Read *(memvar+2) into r7
mvi r0, memvar2
addi r0, 2
ld r7, r0

measure_end:
j measure_end

memvar1:
.dw memvar2

memvar2:
.dw 5
.dw 0

// Results section for simulator
.org 0x1000
.dw 0x0	// start PC of measurement region
.dw measure_end		// end PC
.dw 11	// n instructions
.dw 0x80	// minimum IPC * 128
.dw 0b10000000	// which regs to check
.dw 0, 0, 0, 0, 0, 0, 0, 10	// correct reg values


