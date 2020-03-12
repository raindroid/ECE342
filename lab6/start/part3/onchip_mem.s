    mvi r4, 0x00 # switches
    mvhi r4, 0x20

    mvi r5, 0x0
    mvhi r5, 0x30 # LED address

    // y0 = 0
    // y1 = 1101_0001

    // set bit 16 of the line end to 1
    mvi r6, 0x12
    mvhi r6, 0x11
    mvi r0, 0x1
    st r0, r6

draw_start:
    call		init_line

draw_loop:
    // draw black
    mvi r0, 0
    call		draw_line
    // update position
    addi r1, 1
    addi r2, 1
    // check if line is out of screen
    mvi r6, 0x50 # store 336 (0x150)
    mvhi r6, 1
    cmp r1, r6
    jz draw_start
    // draw colored line
    ld r0, r4   # read color
    call		draw_line
    call		display_info #for debug

    call		delay
    j draw_loop

display_info:
    // debug info
    st r0, r5
    mvi r6, 0x00
    mvhi r6, 0x10
    st r1, r6
    jr r7

init_line:
    // set initial line start and line end [15:0]
    mvi r1, 0
    mvi r2, 0
    mvhi r2, 0xa2
    jr r7

draw_line:
    // NOTE params:
        // r0 as color
        // r1 as line start
        // r2 as line end
    // set color
    mvi r6, 0x14
    mvhi r6, 0x11
    st r0, r6

    // set line start
    mvi r6, 0x0c
    mvhi r6, 0x11
    st r1, r6

    // set line end
    mvi r6, 0x10
    mvhi r6, 0x11
    st r2, r6

    // REVIEW DRAW SIGNAL!
    mvi r6, 0x08
    mvhi r6, 0x11
    st r6, r6
    jr r7

delay:
    mvi r6, 0xff
    mvhi r6, 0x9f
    delay_loop:
        subi r6, 1
        jzr r7
        j delay_loop
            