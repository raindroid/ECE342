mvi r1, 0x0
mvhi r1, 0x20 # switches address

mvi r2, 0x0
mvhi r2, 0x30 # LED address

ld r0, r1
st r0, r2
j -0x3
