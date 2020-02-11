#include "HistoryManager.h"

void history_put(HistoryManager * h, Line *line) {
    LineHistory * record = &h->record1;
    if (h->record1.used) record = &h->record2;
    record->l = *line;
    record->used = HISTORY_IN_USE;
}

void history_clear_screen(HistoryManager * h) {
    if (h->record1.used) draw_line_black(&h->record1.l);
    h->record1.used = HISTORY_NOT_IN_USE;
    if (h->record2.used) draw_line_black(&h->record2.l);
    h->record2.used = HISTORY_NOT_IN_USE;
}