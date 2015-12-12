#include <stdio.h>
#include "func.h"
#include "graphic.h"
#include "dsctbl.h"
#include "int.h"

void Main() {
	struct BOOTINFO *binfo = (struct BOOTINFO *)0x0ff0;
	char s[40];
	char mcursor[16 * 16];
	int mx, my;

	init_gdtidt();
	init_pic();

	init_palette();
	init_screen(binfo->vram, binfo->scrnx, binfo->scrny);

	putfonts8_asc(binfo->vram, binfo->scrnx, 9, 21, COL8_000000, "Hello, World!");
	putfonts8_asc(binfo->vram, binfo->scrnx, 8, 20, COL8_FFFFFF, "Hello, World!");

	sprintf(s, "scrnx = %d", binfo->scrny);
	putfonts8_asc(binfo->vram, binfo->scrnx, 16, 64, COL8_FFFFFF, s);

	mx = (binfo->scrnx - 16) / 2;
	my = (binfo->scrny - 28 -16) /2;
	init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
	sprintf(s, "(%d, %d)", mx, my);
	putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
	
	while(1) {
		io_hlt();
	}
}

