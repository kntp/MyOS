/*
 * int.c
 *
 *  Created on: 2015/12/13
 *      Author: koji
 */
#include "func.h"
#include "int.h"

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
