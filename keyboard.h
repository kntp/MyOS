/*
 * keyboard.h
 *
 *  Created on: 2015/12/19
 *      Author: koji
 */

#ifndef KEYBOARD_H_
#define KEYBOARD_H_

#define PORT_KEYDAT				0x0060
#define PORT_KEYCMD				0x0064

void wait_KBC_sendready(void);
void init_keyboard(void);

#endif /* KEYBOARD_H_ */
