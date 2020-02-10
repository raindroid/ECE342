#define LDA_base_reg    *(volatile char *)0x00700000
#define LDA_mode_reg    *(volatile char *)0x00700000
#define LDA_staus_reg   *(volatile char *)(0x00700000 + 0x4)
#define LDA_go_reg      *(volatile char *)(0x00700000 + 0x8)
#define LDA_line_s_reg  *(volatile char *)(0x00700000 + 0xc)
#define LDA_line_e_reg  *(volatile char *)(0x00700000 + 0x10)
#define LDA_color_reg   *(volatile char *)(0x00700000 + 0x14)
#define SW              *(volatile char *) 0x00011010
#define LEDS            *(char *) 0x00011000

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define printf(fmt, ...) { \
        char buffer[128]; \
        sprintf(buffer, fmt, ##__VA_ARGS__); \
        write(0, buffer, strlen(buffer)); \
    } 
    
size_t write( int fd, const void* buf, size_t nbytes );

int get_color(int r, int g, int b) {
    return (b << 2) + (g << 1) + r;
}

void boundry_check(int *x, int min, int max) {
    if (*x < min) *x = min;
    if (*x > max) *x = max;
}

void draw_line(int x0, int y0, int x1, int y1, int color) {
    boundry_check(&x, 0, 335);
    //TODO 
    LDA_line_s_reg = (y0 << 9) | x0;
    LDA_line_e_reg = (y1 << 9) | x1;
    LDA_color_reg = color;
}