#define switches (volatile char *) 0x0002010
#define leds (char *) 0x0002000

void main()
{ 
    while (1)
        *leds = *switches;
}