# Created by the Intel FPGA Monitor Program
# DO NOT MODIFY

############################################
# Global Defines
DEFINE_COMMA	:= ,

############################################
# Compilation Targets

# Programs
AS		:= nios2-elf-as
CC		:= nios2-elf-gcc
LD		:= nios2-elf-ld
OC		:= nios2-elf-objcopy
RM		:= rm -f

# Flags
USERCCFLAGS	:= -g -O0 -ffunction-sections -fverbose-asm -fno-inline -mno-cache-volatile -std=c11
ARCHASFLAGS	:= -mfloat-abi=softfp --gstabs -I "C:/intelFPGA_lite/18.1/nios2eds/components/altera_nios2/sdk/inc/"
ARCHCCFLAGS	:= -mhw-mul -mno-hw-div -I "C:/intelFPGA_lite/18.1/nios2eds/components/altera_nios2/HAL/inc/" -DSYSTEM_BUS_WIDTH=32 -DALT_SINGLE_THREADED -D_JTAG_UART_BASE=69664u
ARCHLDFLAGS	:= --defsym nasys_stack_top=0xe000 --defsym nasys_program_mem=0x0 --defsym nasys_data_mem=0x0
ARCHLDSCRIPT	:= --script="C:/intelFPGA_lite/18.1/University_Program/Monitor_Program/build/nios_cpp_build.ld"
ASFLAGS		:= $(ARCHASFLAGS)
CCFLAGS		:= -Wall -c $(USERCCFLAGS) $(ARCHCCFLAGS)
LDFLAGS		:= $(patsubst %, -Wl$(DEFINE_COMMA)%, $(ARCHLDFLAGS)) $(patsubst %, -Wl$(DEFINE_COMMA)%, $(ARCHLDSCRIPT))
OCFLAGS		:= -O srec

# Files
HDRS		:= funcs.h HistoryManager.h parts.h
SRCS		:= main.c amp/lib/src/niosII_jtag_uart.c HistoryManager.c funcs.c part4.c part5.c
OBJS		:= $(patsubst %, %.o, $(SRCS))

# Targets
COMPILE: main.srec

main.srec: main.elf
	$(RM) $@
	$(OC) $(OCFLAGS) $< $@

main.elf: $(OBJS)
	$(RM) $@
	$(CC) $(LDFLAGS) $(OBJS) -o $@

%.c.o: %.c $(HDRS)
	$(RM) $@
	$(CC) $(CCFLAGS) $< -o $@

%.s.o: %.s $(HDRS)
	$(RM) $@
	$(AS) $(ASFLAGS) $< -o $@

CLEAN: 
	$(RM) main.srec main.elf $(OBJS)

