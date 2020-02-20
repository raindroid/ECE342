// Finds the sum of 1..10
// Result should be 55 (0x37)

mvi r0, 10	// counts down to 1
mvi r1, 0	// sum, initialized to 0

.0:
add r1, r0	// add counter to sum
cmpi r0, 1	// check if counter is 1
jz loopend	// if it is, goto loopend
subi r0, 1	// otherwise, subtract 1 from counter
j .0b		// ... and go back to top of loop

loopend:		// store r1 to address 0x1000
mvi r0, 0x00
mvhi r0, 0x10
st r1, r0

inf: j inf


