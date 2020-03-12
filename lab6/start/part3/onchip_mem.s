mvi r4, 0x00 # switches
mvhi r4, 0x20

mvi r5, 0x0
mvhi r5, 0x30 # LED address

// set end
mvi r6, 0x10 
mvhi r6, 0x11
mvi r0, 0x4f
mvhi r0, 0xa3
st r0, r6

// set color
mvi r6, 0x14
mvi r6, 0x11
mvi r0, 0x2
st r0, r6

ld r0, r4
st r0, r5
j -0x7