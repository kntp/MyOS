#include "func.h"

void Main()
{
	int i;

	for(i = 0x0000; i < 0xafff; i++) {
		write_mem8(i,10);
	}

	while(1) {
		io_hlt();
	}
}
