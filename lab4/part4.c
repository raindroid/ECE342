#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <math.h>

void swap(int* x, int* y);
void plot_pixel(int x, int y, short int line_color);
void draw_line(int x0,int y0,int x1,int y1, short int line_color);
void clear_screen();
bool wait_for_vsync(); //REVIEW 243的 不知道要不要

volatile int pixel_buffer_start; // REVIEW 同样 243敲来的 不知道需不需要
volatile int *SW_ptr = (int *) 0xFF200040; // REVIEW sw是用这个地址吗？

//REVIEW 这个是handout上的地址？不知道是哪个
//volatile int *mode = (int *) 0x00700000;
//volatile int *line_colour = (int *) 0x00700014;

//REVIEW 这里SW_ptr不知道为什么报错
unsigned SW_value = (unsigned int) *SW_ptr;// read SW value

//REVIEW 以下不确定
unsigned up = (SW_value & 0b1) << 0b1101; //sw_value and with 1 then shift left by 9 bits to get sw0.
unsigned mode = ((SW_value >> 1) & 0b1) << 0b1100; //sw_value shift right by 1 and with 1 then shift left by 8 bits to get sw1.
unsigned colour_bit = ((SW_value >> 2) & 0b111) << 0b0101; //sw_value shift right by 2 and with 111 then shift left by 5 bits to get sw234.

//TODO  颜色怎么用colour_bit determine啊 
unsigned line_colour = colour_bit;

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020; //REVIEW again, not sure whether we need this
    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;

    clear_screen();

    int lastY = 0;
    int y,dy;

//REVIEW see if goes up or goes down
    if(up) {
        y = 209;
        dy = -1;
    } else{
        y =0;
        dy = 1;
    }

    while (wait_for_vsync()) {
        draw_line(0, lastY, 335, lastY, 0); //erase last line drew
        draw_line(0, y, 335, y, line_colour);
        lastY = y;
        y+=dy;

        //REVIEW screen size 336x210
        if(!up && y==210){ //wrap around tothe other end and continue moving
            y=0;
        }
        if(up && y==-1){
            y=209;
            dy*=-1;
        }

    }
}

void draw_line(int x0,int y0,int x1,int y1, short int line_color){
    bool is_steep = abs(y1-y0) >abs(x1-x0);
    if(is_steep){ // if steep -> swap x,y
        swap(&x0,&y0);
        swap(&x1,&y1);
    }

    if(x0>x1){ //if from right to left -> swap
        swap(&x0,&x1);
        swap(&y0,&y1);
    }
    int delta_x = x1 - x0;
    int delta_y = abs(y1 - y0);
    int error = -(delta_x/2);
    int y = y0;
    int y_step;
    if (y0<y1){
        y_step = 1;
    } else{
        y_step = -1;
    }

    for(int x = x0; x<=x1; x++){
        if(is_steep){
            plot_pixel(y,x,line_color);
        } else{
            plot_pixel(x,y,line_color);
        }
        error += delta_y;
        if(error >= 0){
            y += y_step;
            error -= delta_x;
        }
    }
}

void clear_screen(){
    for(int y = 0;y<210;y++){
        for(int x = 0; x<336;x++){
            plot_pixel(x,y,0);
        }
    }
}

void swap(int* x, int* y) {
    int temp = *x;
    *x = *y;
    *y = temp;
}


//REVIEW 以前screen size是320x240 所以y shift 10，x shift 1. 这个lab是336x210 不知道shift多少
void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

bool wait_for_vsync(){
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020; // pixel controller
    register int status; //status register

    *pixel_ctrl_ptr =1;
    status = *(pixel_ctrl_ptr+3); //+3: status register

    //not done drawing: 1&1 = 1
    //done drawing: 0&1 = 0
    while ((status & 0x01)!= 0){//Status and with 1
        status = *(pixel_ctrl_ptr+3);
    }
    //*pixel_ctrl_ptr =1;
    return  true;
}