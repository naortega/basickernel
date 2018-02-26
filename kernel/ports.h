#pragma once

/*
 * return a byte from a port.
 */
unsigned char port_byte_in(unsigned short port);
/*
 * write a byte of data to a port.
 */
void port_byte_out(unsigned short port, unsigned char data);
/*
 * return a word of data from a port.
 */
unsigned short port_word_in(unsigned short port);
/*
 * write a word of data to a port.
 */
void port_word_out(unsigned short port, unsigned short data);
