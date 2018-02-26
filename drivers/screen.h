#pragma once

#define VIDEO_ADDRESS   0xb8000
#define MAX_ROWS        25
#define MAX_COLS        80

#define WHITE_ON_BLACK  0x0f

#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void print_char(char c, int col, int row, char attr_byte);
void print_at(const char *msg, int col, int row);
void print(const char *msg);
void clear_screen();
