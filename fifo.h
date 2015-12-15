/*
 * fifo.h
 *
 *  Created on: 2015/12/15
 *      Author: koji
 */

#ifndef FIFO_H_
#define FIFO_H_

struct FIFO8 {
	unsigned char *buf;
	int p, q, size, free, flags;
};

void fifo8_init(struct FIFO8 *fifo, int size, unsigned char *buf);
int fifo8_put(struct FIFO8 *fifo, unsigned char data);
int fifo8_get(struct FIFO8 *fifo);
int fifo8_status(struct FIFO8 *fifo);

#endif /* FIFO_H_ */
