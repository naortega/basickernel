#include "screen.h"

#include "../kernel/ports.h"
#include "../kernel/util.h"

int get_screen_offset(int col, int row) {
	return (row * MAX_COLS + col) * 2;
}

int get_cursor() {
	/*
	 * screens use their control register as an index to
	 * select their internal registers of which:
	 *  - 14: high byte of the cursor's offset
	 *  - 15: low byte of the cursor's offset
	 */
	port_byte_out(REG_SCREEN_CTRL, 14);
	/* get the high byte and shift it a byte */
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTRL, 15);
	/* now add the low byte with the free space from before */
	offset += port_byte_in(REG_SCREEN_DATA);

	/* remember: each cell is two bytes, not one */
	return offset * 2;
}

void set_cursor(int offset) {
	/* convert from cell offset to char offset */
	offset /= 2;

	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
}

int handle_scrolling(int cursor_offset) {
	/* if within the screen then don't modify */
	if(cursor_offset < MAX_ROWS * MAX_COLS * 2)
		return cursor_offset;

	/* translate rows back by one */
	unsigned int i;
	for(i = 1; i < MAX_ROWS; ++i)
	{
		memory_copy((char*)get_screen_offset(0, i) + VIDEO_ADDRESS,
				(char*)get_screen_offset(0, i - 1) + VIDEO_ADDRESS,
				MAX_COLS * 2);
	}

	/* set last line to blank */
	char *last_line = (char*)get_screen_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS;
	for(i = 0; i < MAX_COLS * 2; ++i)
		last_line[i] = 0;

	/*
	 * move the cursor offset to the last row instead of
	 * off the screen
	 */
	cursor_offset -= MAX_COLS * 2;

	/* updated cursor position */
	return cursor_offset;
}

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

void print_at(const char *msg, int col, int row) {
	if(col >= 0 && row >= 0)
		set_cursor(get_screen_offset(col, row));

	int i;
	for(i = 0; msg[i] != 0; ++i)
		print_char(msg[i], col, row, WHITE_ON_BLACK);
}

void print(const char *msg) {
	print_at(msg, -1, -1);
}

void clear_screen() {
	int row, col;

	for(row = 0; row < MAX_ROWS; ++row)
	{
		for(col = 0; col < MAX_COLS; ++col)
		{
			print_char(' ', col, row, WHITE_ON_BLACK);
		}
	}

	set_cursor(get_screen_offset(0, 0));
}
