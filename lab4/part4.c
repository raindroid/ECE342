#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

void swap(int* x, int* y);
void plot_pixel(int x, int y, short int line_color);
void draw_line(int x0,int y0,int x1,int y1, short int line_color);
void clear_screen();
bool wait_for_vsync();

volatile int pixel_buffer_start; // global variable
volatile int *SW_ptr = (int *) 0xFF200040;

volatile int *mode = (int *) 0x00700000;
volatile int *line_colour = (int *) 0x00700014;

unsigned SW_value = (unsigned int) *SW_ptr;// read SW value
unsigned up = SW_value & 0000000001; //determine the direction of the line

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;

    clear_screen();
    int y =0;
    int dy = 1;
    int lastY = 0;
    while (wait_for_vsync()) {
        draw_line(0, lastY, 335, lastY, 0);
        draw_line(0, y, 335, y, line_colour);
        lastY = y;
        y+=dy;
        if(y==210){
            y=209;
            dy*=-1;
        }
        if(y==-1){
            y=0;
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
    for(int y = 0;y<240;y++){
        for(int x = 0; x<320;x++){
            plot_pixel(x,y,0);
        }
    }
}

void swap(int* x, int* y) {
    int temp = *x;
    *x = *y;
    *y = temp;
}


// QVGA: 320x240
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