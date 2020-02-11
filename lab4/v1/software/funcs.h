#ifndef __FUNCS__H__
#define __FUNCS__H__

#define LDA_base_reg    *(volatile int *)0x00700000
#define LDA_mode_reg    *(volatile int *)0x00700000
#define LDA_staus_reg   *(volatile int *)(0x00700000 + 0x4)
#define LDA_go_reg      *(volatile int *)(0x00700000 + 0x8)
#define LDA_line_s_reg  *(volatile int *)(0x00700000 + 0xc)
#define LDA_line_e_reg  *(volatile int *)(0x00700000 + 0x10)
#define LDA_color_reg   *(volatile int *)(0x00700000 + 0x14)
#define SW              *(volatile char *)(0x00011010)
#define LEDS            *(char *)(0x00011000)

#define I_MODE ((SW >> 2) & 0b1) //SW shift right by 2 and with 1 to get sw3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DRAW_MODE_STALL 0
#define DRAW_MDOE_POLL 1

#define DRAW_STATUS_IDLE 0
#define DRAW_STATUS_DRAW 1

#define BLACK 0x0

#define printf(fmt, ...) { \
        char buffer[128]; \
        sprintf(buffer, fmt, ##__VA_ARGS__); \
        write(0, buffer, strlen(buffer)); \
    } 

typedef struct {
    int x0, y0,
        x1, y1,
        color;
} Line;
    
size_t write( int fd, const void* buf, size_t nbytes );

int get_color(int r, int g, int b);

void boundry_check(int *x, int min, int max);

void draw_line(Line *line);
void draw_line_black(Line *line);

void draw_line_xy(int x0, int y0, int x1, int y1, int color);

void wait_for_vsync();

#endif 