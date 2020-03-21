// Turns a fixed string into uppercase
// Expected result:
// THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG
// Minimum IPC of 0.6

	mvi r0, str		// r0 is the address of str

loop_top:
	ld r1, r0		// get the current character

	cmpi r1, 0		// if null terminator, then exit loop
	jz done

	mv r4, r1		// call toupper with input char in r4
	call toupper
	st r1, r0		// store return value back into string
	
	addi r0, 2		// advance to next char in string
	j loop_top

done:
	mvi r1, str		// write the address of the string to 0x1002 for simulator to process
	mvi r0, 0x02
	mvhi r0, 0x10
	st r1, r0
	
end: j end
	
// toupper(c): if c is lowercase character, returns uppercase version. else returns c.
// takes input character in r4
// returns result in r1
// modifies only register r1
toupper:
	mv r1, r4		// initialize return value to the original unmodified character
	cmpi r1, 'a'	// if before 'a' in ascii table, then skip
	jnr r7
	
	cmpi r1, '{'	// if before '{' (which is after z) then it is a lowercase letter
	jn .0f
	jr r7

	.0:				// we get here if character is lowercase ascii character
	subi r1, 0x20	// there is a constant 0x20 offset between uc/lc characters in ASCII table
	jr r7
	
// The string is stored here. There is a 0x0000 null terminator word added at the end too
str:
	.string "the quick brown fox jumps over the lazy dog"

.org 0x1000
.dw 0x0	// start PC of measurement region
.dw end		// end PC
.dw 622	// number of instructions
.dw 76	// minimum IPC * 128
.dw 0	// which regs to check
.dw 0,0,0,0,0,0,0,0