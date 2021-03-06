#ifndef __FUNC_H__
#define __FUNC_H__

extern inline void io_hl();
void io_cli(void);
void io_sti(void);
void io_out8(int port, int data);
int io_load_eflags(void);
int io_store_eflags(int eflags);
int load_cr0(void);
void store_cr0(int cr0);

void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);

void asm_inthandler21(void);
void asm_inthandler27(void);
void asm_inthandler2c(void);

unsigned int memtest_sub(unsigned int start, unsigned int end);

#endif // __FUNC_H__
