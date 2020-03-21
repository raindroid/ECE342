// Test 1: dependent arithmetic
//
// A sequence of dependent arithmetic instructions
// Minimum required IPC: 1.0


//
// Test add reg
//

mvi r1, 1
mvi r2, 2
mvi r3, 3
mvi r4, 5

add r2, r1
add r3, r2	// forward r2 one cycle
add r4, r2	// forward r2 two cycles

// R2=3, R3=6, R4=8

add r1, r1
add r1, r1
add r1, r1
add r1, r1

// R1 = 16

mv r7, r4
add r7, r1
add r7, r3 // R7 = 30

//
// Test immediate stuff and movs
//

mvi r4, 0
mvi r1, 3
mvi r2, 2
mvi r3, 1

mv r4, r3
mv r3, r1
mv r1, r4

// R1 = 1, R2 = 2, R3 = 3

subi r1, 2
mv r6, r1	// R6 = -1

//
// Test half-register forwarding
//

mvi r0, 0xFE
mvhi r0, 0xFF
addi r0, 1

measure_end:
mv r5, r0	// R5 = -1

addi r0, 0
addi r0, 0
addi r0, 0
addi r0, 0
addi r0, 0


// Results section for simulator
.org 0x1000
.dw 0x0	// start PC of measurement region
.dw measure_end		// end PC
.dw 27	// number of instructions
.dw 0x80	// minimum IPC * 128
.dw 0b11100000	// which regs to check
.dw 0, 0, 0, 0, 0, -1, -1, 30 	// correct reg values


