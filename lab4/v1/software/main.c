#define LDA_reg         *(volatile char *)0x00700000
#define LDA_mode_reg    *(volatile char *)0x00700000
#define LDA_staus_reg   *(volatile char *)(0x00700000 + 0x4)
#define LDA_go_reg      *(volatile char *)(0x00700000 + 0x8)
#define LDA_line_s_reg  (0x00700000 + 0xc)
#define LDA_line_e_reg  (0x00700000 + 0x10)
#define LDA_color_reg   *(volatile char *)(0x00700000 + 0x14)
#define switches (volatile char *) 0x00011010
#define leds (char *) 0x00011000

#include <stdio.h>
#include <string.h>

#define printf(fmt, ...) { \
        char buffer[128]; \
        sprintf(buffer, fmt, ##__VA_ARGS__); \
        write(0, buffer, strlen(buffer)); \
    } 

size_t write( int fd, const void* buf, size_t nbytes );

int main() {

    int x0, y0, x1, y1;
    
    x0 = 1;
    y0 = 1;

    x1 = 335;
    y1 = 209;

    *(volatile int *)LDA_line_s_reg = (y0 << 9) | x0;
    *(volatile int *)LDA_line_e_reg = (y1 << 9) | x1;
    LDA_color_reg = 0b011;

    LDA_go_reg = 1;
    *leds = 0xff;
    printf("s %d \n", (y0 << 9) + x0);

    // unsigned b = 0;
    while (1) {
        // if (b !=  *switches) printf("Switch changed 0x%04x\n", b);
        // b = *switches;
        *leds = *switches;
    }
}