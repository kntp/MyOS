/*
 * mouse.h
 *
 *  Created on: 2015/12/19
 *      Author: koji
 */

#ifndef MOUSE_H_
#define MOUSE_H_

struct MOUSE_DEC {
	unsigned char buf[3], phase;
	int x, y, btn;
};

void enable_mouse(struct MOUSE_DEC *mdec);
int mouse_decode(struct MOUSE_DEC *mdec, unsigned char dat);

#endif /* MOUSE_H_ */
