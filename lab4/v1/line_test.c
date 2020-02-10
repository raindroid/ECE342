#define LDA_reg         *(volatile char *)0x00700000
#define LDA_mode_reg    *(volatile char *)0x00700000
#define LDA_staus_reg   *(volatile char *)(0x00700000 + 0x4)
#define LDA_go_reg      *(volatile char *)(0x00700000 + 0x8)
#define LDA_line_s_reg  *(volatile char *)(0x00700000 + 0xc)
#define LDA_line_e_reg  *(volatile char *)(0x00700000 + 0x10)
#define LDA_color_reg   *(volatile char *)(0x00700000 + 0x14)
#define switches (volatile char *) 0x00011010
#define leds (char *) 0x00011000

#include <stdio.h>
#include <string.h>

#define printf(fmt, ...) { \
        char buffer[41]; \
        unsigned len; \
        len = sprintf(buffer, fmt, ##__VA_ARGS__); \
        write(0, buffer, len); \
    } 


size_t write( int fd, const void* buf, size_t nbytes );

int main() {

    // unsigned x0, y0, x1, y1;
    
    // x0 = 1;
    // y0 = 1;

    // x1 = 235;
    // y1 = 209;

    // LDA_line_s_reg = (y0 << 9) + x0;
    // LDA_line_e_reg = (y1 << 9) + x1;
    // LDA_color_reg = 0b110;

    // LDA_go_reg = 1;

    // printf("LDA line start 0x%04x\n", LDA_line_s_reg);
    // printf("LDA line end 0x%04x\n", LDA_line_e_reg);
    // printf("LDA line color 0x%04x\n", LDA_color_reg);

    unsigned b = 0;
    while (b !=  *switches) {
        printf("Switch changed 0x%04x\n", b);
        b = *switches;
        *leds = *switches;
    }
}