#include <stdio.h>
#include "func.h"
#include "graphic.h"
#include "dsctbl.h"
#include "int.h"

void Main() {
	struct BOOTINFO *binfo = (struct BOOTINFO *)0x0ff0;
	char s[40];
	char mcursor[16 * 16];
	int mx, my, i;

	init_gdtidt();
	init_pic();
	io_sti();	/* after init IDT/PIC, enable CPU interrupt */

	init_palette();
	init_screen(binfo->vram, binfo->scrnx, binfo->scrny);

	mx = (binfo->scrnx - 16) / 2;
	my = (binfo->scrny - 28 -16) /2;
	init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
	sprintf(s, "(%d, %d)", mx, my);
	putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);

	io_out8(PIC0_IMR, 0xf9);		/* allow PIC1 and keyboard(11111001) */
	io_out8(PIC1_IMR, 0xef);		/* allow mouse(11101111) */

	while(1) {
		io_cli();
		if(keybuf.flag == 0) {
			io_stihlt();
		}else {
			i = keybuf.data;
			keybuf.flag = 0;
			io_sti();
			sprintf(s, "%02X", i);
			boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 16, 15, 31);
			putfonts8_asc(binfo->vram, binfo->scrnx, 0, 16, COL8_FFFFFF, s);
		}
	}
}

