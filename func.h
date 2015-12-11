#ifndef __FUNC_H__
#define __FUNC_H__

extern inline void io_hl();

void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);

#endif // __FUNC_H__
