/*
 * mouse.c
 *
 *  Created on: 2015/12/19
 *      Author: koji
 */
#include "mouse.h"
#include "keyboard.h"

#define KEYCMD_SENDTO_MOUSE		0xd4
#define MOUSECMD_ENABLE			0xf4

void enable_mouse(struct MOUSE_DEC *mdec)
{
	/* enable mouse */
	wait_KBC_sendready();
	io_out8(PORT_KEYCMD, KEYCMD_SENDTO_MOUSE);
	wait_KBC_sendready();
	io_out8(PORT_KEYDAT, MOUSECMD_ENABLE);
	/* ACK is sent if success */
	mdec->phase = 0;

	return;
}

int mouse_decode(struct MOUSE_DEC *mdec, unsigned char dat)
{
	if(mdec->phase == 0) {
		/* waiting mouse 0xfa */
		if(dat == 0xfa) {
			mdec->phase = 1;
		}
		return 0;
	}else if(mdec->phase == 1) {
		/* waiting mouse 1st byte */
		if((dat & 0xc8) == 0x08) {
			mdec->buf[0] = dat;
			mdec->phase = 2;
		}
		return 0;
	}else if(mdec->phase == 2) {
		/* waiting mouse 2nd byte */
		mdec->buf[1] = dat;
		mdec->phase = 3;
		return 0;
	}else if(mdec->phase == 3) {
		/* waiting mouse 3rd byte */
		mdec->buf[2] = dat;
		mdec->phase = 1;
		mdec->btn = mdec->buf[0] & 0x07;
		mdec->x = mdec->buf[1];
		mdec->y = mdec->buf[2];
		if((mdec->buf[0] & 0x10) != 0) {
			mdec->x |= 0xffffff00;
		}
		if((mdec->buf[0] & 0x20) != 0) {
			mdec->y |= 0xffffff00;
		}
		mdec->y = - mdec->y;
		return 1;
	}

	return -1; /* can not be reached */
}

