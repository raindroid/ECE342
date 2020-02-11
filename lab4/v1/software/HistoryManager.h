#ifndef __HISTORY_MANAGER_H__
#define __HISTORY_MANAGER_H__

#include "funcs.h"

#define HISTORY_NOT_IN_USE 0
#define HISTORY_IN_USE 1
#define HISTORY_CAPACITY 10

typedef struct {
    Line l;
    int used;   
} LineHistory;

typedef struct {
    LineHistory record1;
    LineHistory record2;
} HistoryManager;

void history_put(HistoryManager *, Line *line);

void history_clear_screen(HistoryManager *);    

#endif