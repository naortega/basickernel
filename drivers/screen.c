#include "screen.h"

#include "../kernel/ports.h"

void print_char(char c, int col, int row, char attr_byte) {
	unsigned char *vidmem = (unsigned char*) VIDEO_ADDRESS;

	if(!attr_byte)
		attr_byte = WHITE_ON_BLACK;

	/* get the offset of the screen location specified */
	int offset;
	/*
	 * if row & col are non-negative then they can be used
	 * as an offset
	 */
	if(col >= 0 && row >= 0)
	{
		offset = get_screen_offset(col, row);
	}
	/* otherwise use the cursor's current location */
	else
	{
		offset = get_cursor();
	}

	/* handle a newline */
	if(c == '\n')
	{
		int rows = offset / (2 * MAX_COLS);
		offset = get_screen_offset(79,rows);
	}
	/* else set the character */
	else
	{
		vidmem[offset] = c;
		vidmem[offset+1] = attr_byte;
	}

	/* update the offset to the next cell */
	offset += 2;
	/* set scrolling adjustment */
	offset = handle_scrolling(offset);
	/* update the cursor position */
	set_cursor(offset);
}
