mvi r1, 0xff

mvi r2, 0x0
mvhi r2, 0x30 # LED address

mvi r0, 0x3
st r0, r1
ld r0, r1
addi r0, 1
st r0, r1
st r0, r2
j -0x4