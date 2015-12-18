/*
 * fifo.c
 *
 *  Created on: 2015/12/15
 *      Author: koji
 */
#include "fifo.h"

#define FLAGS_OVERRUN 0x0001

/* init fifo buffer */
void fifo8_init(struct FIFO8 *fifo, int size, unsigned char *buf)
{
	fifo->size = size;
	fifo->buf = buf;
	fifo->free = size;	/* unused area */
	fifo->flags = 0;
	fifo->p = 0;		/* write point */
	fifo->q = 0;		/* read point */

	return;
}

/* write data */
int fifo8_put(struct FIFO8 *fifo, unsigned char data)
{
	if(fifo->free == 0)	{
		/* overrun */
		fifo->flags |= FLAGS_OVERRUN;
		return -1;
	}
	fifo->buf[fifo->p] = data;
	fifo->p++;
	if(fifo->p == fifo->size) {
		fifo->p = 0;
	}
	fifo->free--;

	return 0;
}

/* read data */
int fifo8_get(struct FIFO8 *fifo)
{
	int data;

	if(fifo->free == fifo->size) {
		/* no data */
		return -1;
	}
	data = fifo->buf[fifo->q];
	fifo->q++;
	if(fifo->q == fifo->size) {
		fifo->q = 0;
	}
	fifo->free++;

	return data;
}

/* report used space */
int fifo8_status(struct FIFO8 *fifo)
{
	return fifo->size - fifo->free;
}
