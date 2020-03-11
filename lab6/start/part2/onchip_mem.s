mvi r4, 0x00 # switches
mvhi r4, 0x20

mvi r5, 0x0
mvhi r5, 0x30 # LED address

mvi r6, 0x0 # HEX
mvhi r6, 0x10

mvi r1, 0  # init counter

ld r0, r4   # update speed
st r0, r5
addi r0, 1
call loop
addi r1, 1
st r1, r6 # display the number
j -0x7

loop:
cmpi r0, 0
jzr r7
subi r0, 1

mvi r3, 0xff
mvhi r3, 0x3f
delay: 
subi r3, 1 # wait longer
jz loop
j delay
