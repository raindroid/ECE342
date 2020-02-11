#include <stdio.h>
#include <string.h>
#include "HistoryManager.h"
#include "parts.h"
#include "Math.h"

int main() {

    // NOTE we try to simulate the C++ OOP style here
    HistoryManager h = {0};
    Part4 p4 = {0};
    Part5 p5 = {0};

    while(1) {
        history_clear_screen(&h);
        part4_draw(&p4, &h);
        part5_draw(&p5, &h);

        wait_for_vsync();
    }

    return 0;
}

