#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "funcs.h"
#include "parts.h"

void part4_draw(Part4 * p4, HistoryManager *h) {
    if (!EN_P4) return;
    //NOTE screen size 336x210
    if (I_UP) {
        p4->y --;
        if (p4->y <= -1) p4->y = 209;
    } else {
        p4->y ++;
        if (p4->y >= 210) p4->y = 0;
    }

    Line l = {0, p4->y, 335, p4->y, I_COLOR};
    draw_line(&l);
    history_put(h, &l);
}
