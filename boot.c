#include "func.h"

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);

void Main() {
	int i;
	char *p = (char *)0xa0000;

	init_palette();

	for( i = 0x0000; i < 0xffff; i++ ) {
		p[i] = i & 0x0f;
	}
	
	while(1) { io_hlt(); }
}

void init_palette(void)
{
//	static unsigned char table_rgb[16 * 3] = {
	unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/* 0:black */
		0xff, 0x00, 0x00,	/* 1:lite red */
		0x00, 0xff, 0x00,	/* 2:lite green */
		0xff, 0xff, 0x00,	/* 3:lite yellow */
		0x00, 0x00, 0xff,	/* 4:lite blue */
		0xff, 0x00, 0xff,	/* 5:lite purple */
		0x00, 0xff, 0xff,	/* 6:lite sky blue */
		0xff, 0xff, 0xff,	/* 7:white */
		0xc6, 0xc6, 0xc6,	/* 8:lite gray */
		0x84, 0x00, 0x00,	/* 9:dark red */
		0x00, 0x84, 0x00,	/* 10:dark green */
		0x84, 0x84, 0x00,	/* 11:dark yellow */
		0x00, 0x00, 0x84,	/* 12:dark blue */
		0x84, 0x00, 0x84,	/* 13:dark purple */
		0x00, 0x84, 0x84,	/* 14:dark sky blue */
		0x84, 0x84, 0x84	/* 15:dark gray */
	};
	set_palette(0, 15, table_rgb);
	return;

}

void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags();	/* record interrupt enable flag */
	io_cli();					/* flag on to disable interrupt */
	io_out8(0x03c8, start);
	for(i = start; i <= end; i++) {
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags);	/* resume interrupt enable flag */
	return;
}
