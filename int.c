/*
 * int.c
 *
 *  Created on: 2015/12/13
 *      Author: koji
 */
#include "func.h"
#include "dsctbl.h"
#include "graphic.h"
#include "int.h"
#include "fifo.h"

#define PORT_KEYDAT 0x0060

struct FIFO8 keyfifo;
struct FIFO8 mousefifo;

void init_pic(void)
{
	io_out8(PIC0_IMR, 0xff);	/* disable all interrupt */
	io_out8(PIC1_IMR, 0xff);	/* disable all interrupt */

	io_out8(PIC0_ICW1, 0x11);	/* edge trigger mode */
	io_out8(PIC0_ICW2, 0x20);	/* recieve IRQ0-7 as INT20-27 */
	io_out8(PIC0_ICW3, 1 << 2);	/* PIC1 <-> IRQ2 */
	io_out8(PIC0_ICW4, 0x01);	/* non buffer mode */

	io_out8(PIC1_ICW1, 0x11);	/* edge trigger mode */
	io_out8(PIC1_ICW2, 0x28);	/* recieve IRQ8-15 as INT28-2f */
	io_out8(PIC1_ICW3, 2);		/* PIC1 <-> IRQ2 */
	io_out8(PIC1_ICW4, 0x01);	/* non buffer mode */

	io_out8(PIC0_IMR, 0xfb);	/* disable all interrupt except PIC1 */
	io_out8(PIC1_IMR, 0xff);	/* disable all interrupt */

	return;
}

/* interrupt from PS/2 keyboard */
void inthandler21(int *esp)
{
	unsigned char data;

	io_out8(PIC0_OCW2, 0x61);
	data = io_in8(PORT_KEYDAT);

	fifo8_put(&keyfifo, data);

	return;
}

/* interrupt from PS/2 mouse */
void inthandler2c(int *esp)
{
	unsigned char data;

	io_out8(PIC1_OCW2, 0x64);
	io_out8(PIC0_OCW2, 0x62);
	data = io_in8(PORT_KEYDAT);

	fifo8_put(&mousefifo, data);

	return;
}

/* for Athlon64X2 chipset incomplete interrupt. */
/* this interrupt handler does nothing */
void inthandler27(int *esp)
{
	io_out8(PIC0_OCW2, 0x67);	/* send PIC "accept IRQ-07" */

	return;
}
