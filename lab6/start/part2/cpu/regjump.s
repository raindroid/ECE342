// This tests the jzr and jnr instructions
// If it ever jumps to the fail label, your instruction is broken
	mvi r0, -2	// Init loop counter

top:
	// Get r1 to point to jumptab[2*r0+4]
	mvi r1, jumptab
	add r1, r0
	add r1, r0
	addi r1, 4
	
	// Grab r4 and r5 from adjacent jumptab entries
	ld r4, r1
	addi r1, 2
	ld r5, r1

	// Advance loop counter and update flags.
	// First time: -1 -> trigger jnr 
	// Second time: 0 -> trigger jzr
	// Third time: 1 -> trigger neither
	addi r0, 1
	
	jzr r4	// fail, top, fail
	jnr r5	// top, fail, fail
		
	// Success if we get here
	mvi r1, goodstr
	j result
	
fail:
	mvi r1, badstr
	j result
	
result:
	mvi r0, 0x02	// Write address of string (in r1) to simulator
	mvhi r0, 0x10
	st r1, r0
		
end: j end
	
jumptab: 
	.dw fail, top, fail, fail
badstr: 
	.string "Failed"
goodstr: 
	.string "Success"
