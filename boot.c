#include "func.h"

void Main() {
	int i;
	char *p = (char *)0xa0000;

	for( i = 0x0000; i < 0xffff; i++ ) {
		p[i] = i & 0x0f;
	}
	
	while(1) { io_hlt(); }
}
