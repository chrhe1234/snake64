#ifndef _GFX_H_
#define _GFX_H_

#include <stdint.h>

#define C64_BLACK		0
#define C64_WHITE		1
#define C64_RED			2
#define C64_CYAN		3
#define C64_PURPLE		4
#define C64_GREEN		5
#define C64_BLUE		6
#define C64_YELLOW		7
#define C64_ORANGE		8
#define C64_BROWN		9
#define C64_LIGHT_RED	10
#define C64_DARK_GRAY	11
#define C64_GRAY		12
#define C64_LIGHT_GREEN	13
#define C64_LIGHT_BLUE	14
#define C64_LIGHT_GRAY	15

#define	TILE_EMPTY	0x20
#define	TILE_FOOD	0x53
// #define TILE_HAZARD	0x56
#define TILE_HAZARD	0x66

// set screen RAM
void gfx_scr_set(uint8_t value);

// set screen RAM char at cx, cy to ca
void gfx_scr_set_xy(uint8_t cx, uint8_t cy, uint8_t ca);

// get screen RAM char at cx, cy
uint8_t gfx_scr_get_xy(uint8_t cx, uint8_t cy);

// set color RAM
void gfx_clr_set(uint8_t value);

// set color RAM char at cx, cy to ca
void gfx_clr_set_xy(uint8_t cx, uint8_t cy, uint8_t ca);

// set screen x,y to color and chr
void gfx_set_xy(uint8_t cx, uint8_t cy, uint8_t color, uint8_t chr);

// initialize graphics
void gfx_init();

// reset graphics
void gfx_exit();

// draw playground frame
void gfx_draw_frame();

// draw/put food on the playing field
void gfx_draw_food(uint8_t x, uint8_t y);

// draw/put hazard on the playing field
void gfx_draw_hazard(uint8_t x, uint8_t y);

// wait for the end of the frame (line 250)
void gfx_wait_frame_end();

// fade all character colors from white to black
void gfx_fade_to_black();

// print the given screen code (!) string to the given location and color
void gfx_print_xy(uint8_t cx, uint8_t cy, uint8_t color, const char *str);

// hide all sprites
void gfx_spr_hide_all();

// init sprites
void gfx_spr_init();

#endif
