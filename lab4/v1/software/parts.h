#ifndef __PARTS_H__
#define __PARTS_H__
#include "HistoryManager.h"

// REVIEW Part 4 & 5 inputs
#define I_UP (SW & 0b1) //SW and with 1 to get sw0.
#define I_CW ((SW >> 1) & 0b1) //SW and with 2 and with 1 to get sw1.
#define I_COLOR ((SW >> 3) & 0b111) //SW shift right by 3 and with 111 sw543.
#define EN_P4 ((SW >> 6) & 0b1)    // Enable Part 4
#define EN_P5 ((SW >> 7) & 0b1)    // Enable Part 5

typedef struct {
    int y;
} Part4;

void part4_draw(Part4 *, HistoryManager *);

typedef struct {
    int d;  // degree
} Part5;
void part5_draw(Part5 *, HistoryManager *);


#endif