#include "funcs.h"
#define I_SPEED ((SW >> 6) & 0b11) //SW shift right by 6 and with 11 sw76.

int get_color(int r, int g, int b) {
    return (b << 2) + (g << 1) + r;
}

void boundry_check(int *x, int min, int max) {
    // if (*x < min) *x = min;
    // if (*x > max) *x = max;
}

void draw_line(Line *line) {
    draw_line_xy(line->x0,
                 line->y0,
                 line->x1,
                 line->y1,
                 line->color);
}

void draw_line_black(Line *line) {
    draw_line_xy(line->x0,
                 line->y0,
                 line->x1,
                 line->y1,
                 BLACK);
}

void draw_line_xy(int x0, int y0, int x1, int y1, int color) {
    boundry_check(&x0, 0, 335);
    boundry_check(&x1, 0, 335);
    boundry_check(&y0, 0, 209);
    boundry_check(&y1, 0, 209);
    
    // NOTE wait for previous draw
    while (LDA_mode_reg == DRAW_MDOE_POLL && 
        LDA_staus_reg == DRAW_STATUS_DRAW);

    LDA_mode_reg = I_MODE & 0x1;
    LDA_line_s_reg = (y0 << 9) | x0;
    LDA_line_e_reg = (y1 << 9) | x1;
    LDA_color_reg = color;

    LDA_go_reg = 1; // DRAW!
}

void wait_for_vsync() {
    // NOTE there is no such function, so we simulate with a useless slow for loop
    int cnt = 1;
    while(cnt < 32000) cnt++;
}