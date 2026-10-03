// #include <stdlib.h>
// #include <stdio.h>
#include <stdint.h>
#include <c64/vic.h>
#include <c64/cia.h>
#include <c64/sprites.h>
#include <c64/kernalio.h>

#include "snake.h"
#include "utils.h"
#include "gfx.h"
#include "sprites.h"
#include "snd.h"

// ############################################################### memory layout
// $0a00-$0bff code/data
// $0c00-$0fbf sprites
// $0fc0-$37ff code/data
// $3800-$4000 charset (not initialized)
// $4000-$a000 BSS/heap/stack (not initialized)

#pragma region(lower1, 0x0870, 0x0c00, , , {code, data})
#pragma section(sprites, 0, , , data)
#pragma region(sprites_region, 0x0c00, 0x0fc0, , , {sprites})
#pragma region(lower2, 0x0fc0, 0x3800, , , {code, data})
#pragma section(charset, 0, , , bss)
#pragma region(charset_region, 0x3800, 0x4000, , , {charset})
#pragma region(high, 0x4000, 0xa000, , , {bss, heap, stack})

// ############################################################### character set

#pragma bss(charset)
// modified charset, not initialized, located at 0x3800, needs to be set up by gfx_init
// 94: smaller ball, shrunk version of 81 (e.g. second last bit of snake)
// 28: even smaller ball, shrunk 94 (e.g. very end of tail)
// 39: larger ball, expanded 81 (e.g. fat main body)
__export volatile uint8_t charset_memory[2048];
#pragma bss(bss)

// background color that will be set in each game loop
uint8_t background_color = C64_BLACK;

// score will be updated on screen at the beginning of a game loop if set
uint8_t update_score = 0;

// ############################################################### snakes

// snake direction flags (do not change, those values are assumed in several places)
// opposite direction is (SDIR_xyz + 2) & 0x03 but faster is actually SDIR_xyz ^ 2 (!)
#define	SDIR_UP		0
#define	SDIR_RIGHT	1
#define	SDIR_DOWN	2
#define	SDIR_LEFT	3

// snake head movement depending on direction direction changes ddx/ddy[SIDR_xyz]
const int8_t ddx[4] = {0, 1, 0, -1};
const int8_t ddy[4] = {-1, 0, 1, 0};

// snake status flags
#define	SNAKE_ACTIVE	0
#define	SNAKE_INACTIVE	1
#define	SNAKE_DEAD		2

// snake maximum length
#define	SNAKE_MAX		240

// number of consecutive blocked advance-ticks tolerated before a trapped snake starts shrinking
#define STUCK_TIMEOUT	4

// *** most of the code below would use pointers but for the C64
// the generated code is more compact like this (i.e. with hardwired addresses)

Snake snake1, snake2;

// reset all data for the given snake, resets score if reset_score != 0
void snake_reset(uint8_t s, uint8_t reset_score) {
	if (s == 1) {
		snake1.status = 0;
		snake1.direction = SDIR_RIGHT;
		snake1.moved = SDIR_RIGHT;
		snake1.start = 0;
		snake1.end = 0;
		snake1.length = 0;
		snake1.grow = 0;
		snake1.stuck = 0;
		for (uint8_t i = 0;; ++i) {
			snake1.x[i] = 0xff;
			snake1.y[i] = 0xff;
			if (i == 255)
				break;
		}
		if (reset_score) {
			snake1.score[0] = 0;
			snake1.score[1] = 0;
			snake1.score[2] = 0;
			snake1.score[3] = 0;
		}
		snake1.trail = 0;
		return;
	}
	if (s == 2) {
		snake2.status = 0;
		snake2.direction = SDIR_RIGHT;
		snake2.moved = SDIR_RIGHT;
		snake2.start = 0;
		snake2.end = 0;
		snake2.length = 0;
		snake2.grow = 0;
		snake2.stuck = 0;
		for (uint8_t i = 0;; ++i) {
			snake2.x[i] = 0xff;
			snake2.y[i] = 0xff;
			if (i == 255)
				break;
		}
		if (reset_score) {
			snake2.score[0] = 0;
			snake2.score[1] = 0;
			snake2.score[2] = 0;
			snake2.score[3] = 0;
		}
		snake2.trail = 0;
		return;
	}
}

// increase score of snake s by value (v = 0..10), "pedestrian" version, 9999 = max score
void snake_inc_score(uint8_t s, uint8_t v) {
	if (v > 10)
		v = 10;
	if (s == 1) {
		snake1.score[0] += v;
		if (snake1.score[0] >= 10) {
			snake1.score[0] -= 10;
			snake1.score[1]++;
			if (snake1.score[1] >= 10) {
				snake1.score[1] = 0;
				snake1.score[2]++;
				if (snake1.score[2] >= 10) {
					snake1.score[2] = 0;
					snake1.score[3]++;
					if (snake1.score[3] >= 10) {
						snake1.score[0] = 9;
						snake1.score[1] = 9;
						snake1.score[2] = 9;
						snake1.score[3] = 9;
					}
				}
			}
		}
		return;
	}
	if (s == 2) {
		snake2.score[0] += v;
		if (snake2.score[0] >= 10) {
			snake2.score[0] -= 10;
			snake2.score[1]++;
			if (snake2.score[1] >= 10) {
				snake2.score[1] = 0;
				snake2.score[2]++;
				if (snake2.score[2] >= 10) {
					snake2.score[2] = 0;
					snake2.score[3]++;
					if (snake2.score[3] >= 10) {
						snake2.score[0] = 9;
						snake2.score[1] = 9;
						snake2.score[2] = 9;
						snake2.score[3] = 9;
					}
				}
			}
		}
		return;
	}
}

// decrease score, "pedestrian" version
void snake_dec_score(uint8_t s) {
	if (s == 1) {
		if (snake1.score[0] == 0 && snake1.score[1] == 0 && snake1.score[2] == 0 && snake1.score[3] == 0)
			return;
		if(snake1.score[0] > 0)
			snake1.score[0]--;
		else {
			snake1.score[0] = 9;
			if (snake1.score[1] > 0)
				snake1.score[1]--;
			else {
				snake1.score[1] = 9;
				if (snake1.score[2] > 0)
					snake1.score[2]--;
				else {
					snake1.score[2] = 9;
					if (snake1.score[3] > 0)
						snake1.score[3]--;
				}
			}
		}
	}
	if (s == 2) {
		if (snake2.score[0] == 0 && snake2.score[1] == 0 && snake2.score[2] == 0 && snake2.score[3] == 0)
			return;
		if(snake2.score[0] > 0)
			snake2.score[0]--;
		else {
			snake2.score[0] = 9;
			if (snake2.score[1] > 0)
				snake2.score[1]--;
			else {
				snake2.score[1] = 9;
				if (snake2.score[2] > 0)
					snake2.score[2]--;
				else {
					snake2.score[2] = 9;
					if (snake2.score[3] > 0)
						snake2.score[3]--;
				}
			}
		}
	}
}

// add a segment to the front of snake s (1 or 2)
void snake_add(uint8_t s, uint8_t x, uint8_t y) {
	if (s == 1) {
		if(snake1.length >= SNAKE_MAX)
			return;
		if(snake1.length != 0)
			snake1.start++;
		snake1.x[snake1.start] = x;
		snake1.y[snake1.start] = y;
		snake1.length++;
		return;
	}
	if (s == 2) {
		if(snake2.length >= SNAKE_MAX)
			return;
		if(snake2.length != 0)
			snake2.start++;
		snake2.x[snake2.start] = x;
		snake2.y[snake2.start] = y;
		snake2.length++;
		return;
	}
}

// workaround for snake1.x[(uint8_t) (ndx +/- 1)] not working properly for ndx = 255/0 because the +/-1 is merged
// into the address of snake1.x (lda snake1.x+/-1,x), needs to be __noinline (!)

__noinline uint8_t inc8(uint8_t v) {
	return v + 1;
}

__noinline uint8_t dec8(uint8_t v) {
	return v - 1;
}

// draw head of the snake (1st two pieces)
void snake_draw_head(uint8_t s) {
	if (s == 1) {
		uint8_t color = snake1.status == SNAKE_DEAD ? COLOR_DEAD : COLOR_SNAKE1;
		gfx_set_xy(snake1.x[snake1.start], snake1.y[snake1.start], color, SP_HEADU + snake1.direction);
		uint8_t p = dec8(snake1.start);
		gfx_set_xy(snake1.x[p], snake1.y[p], color, SP_BODY);
		return;
	}
	if (s == 2) {
		uint8_t color = snake2.status == SNAKE_DEAD ? COLOR_DEAD : COLOR_SNAKE2;
		gfx_set_xy(snake2.x[snake2.start], snake2.y[snake2.start], color, SP_HEADU + snake2.direction);
		uint8_t p = dec8(snake2.start);
		gfx_set_xy(snake2.x[p], snake2.y[p], color, SP_BODY);
		return;
	}
}

// draw tail of the snake (last two pieces and a final erase if necessary)
// tail_moved must be 0 when growth suppressed the tail advance this tick, so the cell
// behind the tail (still occupied by the live body) is left untouched
void snake_draw_tail(uint8_t s, uint8_t tail_moved) {
	if (s == 1) {
		gfx_set_xy(snake1.x[snake1.end], snake1.y[snake1.end], COLOR_SNAKE1, SP_TAIL2);
		uint8_t p1 = inc8(snake1.end);
		gfx_set_xy(snake1.x[p1], snake1.y[p1], COLOR_SNAKE1, SP_TAIL1);
		if (tail_moved) {
			uint8_t p2 = dec8(snake1.end);
			if (snake1.x[p2] != 0xff) {
				if (snake1.trail == 0)
					gfx_set_xy(snake1.x[p2], snake1.y[p2], COLOR_SNAKE1, SP_EMPTY);
				else {
					snake1.trail--;
					gfx_set_xy(snake1.x[p2], snake1.y[p2], COLOR_TRAIL, SP_TAIL2);
				}
			}
		}
		return;
	}
	if (s == 2) {
		gfx_set_xy(snake2.x[snake2.end], snake2.y[snake2.end], COLOR_SNAKE2, SP_TAIL2);
		uint8_t p1 = inc8(snake2.end);
		gfx_set_xy(snake2.x[p1], snake2.y[p1], COLOR_SNAKE2, SP_TAIL1);
		if (tail_moved) {
			uint8_t p2 = dec8(snake2.end);
			if (snake2.x[p2] != 0xff) {
				if (snake2.trail == 0)
					gfx_set_xy(snake2.x[p2], snake2.y[p2], COLOR_SNAKE2, SP_EMPTY);
				else {
					snake2.trail--;
					gfx_set_xy(snake2.x[p2], snake2.y[p2], COLOR_TRAIL, SP_TAIL2);
				}
			}
		}
		return;
	}
}

// draw body of the snake (all except for two and last two bits)
void snake_draw_body(uint8_t s) {
	if (s == 1) {
		for (uint8_t i = snake1.start - 2;;) {
			gfx_scr_set_xy(snake1.x[i], snake1.y[i], SP_BODY);
			gfx_clr_set_xy(snake1.x[i], snake1.y[i], COLOR_SNAKE1);
			--i;
			if (i == (uint8_t) (snake1.end + 1))
				break;
		}
		return;
	}
	if (s == 2) {
		for (uint8_t i = (uint8_t) snake2.start - 2;;) {
			gfx_scr_set_xy(snake2.x[i], snake2.y[i], SP_BODY);
			gfx_clr_set_xy(snake2.x[i], snake2.y[i], COLOR_SNAKE2);
			--i;
			if (i == (uint8_t) (snake2.end + 1))
				break;
		}
		return;
	}
}

// set the color of a snake to 'dead'
void snake_set_dead_color(uint8_t s) {
	if (s == 1) {
		for (uint8_t i = snake1.start;;) {
			gfx_clr_set_xy(snake1.x[i], snake1.y[i], COLOR_DEAD);
			--i;
			if (i == (uint8_t) (snake1.end - 1))
				break;
		}
		return;
	}
	if (s == 2) {
		for (uint8_t i = snake2.start;;) {
			gfx_clr_set_xy(snake2.x[i], snake2.y[i], COLOR_DEAD);
			--i;
			if (i == (uint8_t) (snake2.end - 1))
				break;
		}
		return;
	}
}

// apply hazard-style punishment to snake s (shrink by one segment while long enough to survive, otherwise die)
void snake_punish(uint8_t s) {
	if (s == 1) {
		background_color = COLOR_SNAKE1;
		if (snake1.length <= 5) {
			snake1.status = SNAKE_DEAD;
			snake_set_dead_color(1);
			snd_play_death();
		} else {
			snake_dec_score(1);
			update_score = 1;
			snake1.length--;
			snake1.end++;
			snake_draw_tail(1, 1);
			snd_play_collision();
		}
		return;
	}
	if (s == 2) {
		background_color = COLOR_SNAKE2;
		if (snake2.length <= 5) {
			snake2.status = SNAKE_DEAD;
			snake_set_dead_color(2);
			snd_play_death();
		} else {
			snake_dec_score(2);
			update_score = 1;
			snake2.length--;
			snake2.end++;
			snake_draw_tail(2, 1);
			snd_play_collision();
		}
		return;
	}
}

// deactivate the food slot at x,y (called when a snake eats it), defined below with the rest of the food logic
void food_deactivate(uint8_t x, uint8_t y);

// advance snake in the correct direction
void snake_advance(uint8_t s) {
	uint8_t nx, ny, content;
	uint8_t tail_moved = 1;			// 0 when growth suppresses the tail advance this tick
	if (s == 1) {
		if (snake1.status != SNAKE_ACTIVE)
			return;
		nx = snake1.x[snake1.start] + ddx[snake1.direction];
		ny = snake1.y[snake1.start] + ddy[snake1.direction];
		content = gfx_scr_get_xy(nx, ny);
		if (content != TILE_EMPTY) {			// collision
			if (content == TILE_FOOD) {			// collision with food
				snake1.grow = 2;
				gfx_scr_set_xy(nx, ny, TILE_EMPTY);
				food_deactivate(nx, ny);
				snake_inc_score(1, 1);
				update_score = 1;
				snd_play_eat();
			} else {
				// collision with hazard or blocked by wall, self or other snake
				snake1.stuck++;
				if (snake1.stuck >= STUCK_TIMEOUT) {
					snake1.stuck = 0;
					snake_punish(1);
				}
				return;
			}
		}
		// move forward
		snake1.stuck = 0;
		snake1.moved = snake1.direction;
		snake1.start++;
		snake1.x[snake1.start] = nx;
		snake1.y[snake1.start] = ny;
		if (snake1.grow > 0) {
			snake1.grow--;
			if (snake1.length < SNAKE_MAX) {
				snake1.length++;
				tail_moved = 0;
				snake1.trail = 0;	// growth cancels an active hazardous trail immediately
			} else
				snake1.end++;
		} else {
			snake1.end++;
		}
	}
	if (s == 2) {
		if (snake2.status != SNAKE_ACTIVE)
			return;
		nx = snake2.x[snake2.start] + ddx[snake2.direction];
		ny = snake2.y[snake2.start] + ddy[snake2.direction];
		content = gfx_scr_get_xy(nx, ny);
		if (content != TILE_EMPTY) {			// collision
			if (content == TILE_FOOD) {			// collision with food
				snake2.grow = 2;
				gfx_scr_set_xy(nx, ny, TILE_EMPTY);
				food_deactivate(nx, ny);
				snake_inc_score(2, 1 );
				update_score = 1;
				snd_play_eat();
			} else {
				// collision with hazard or blocked by wall, self or other snake
				snake2.stuck++;
				if (snake2.stuck >= STUCK_TIMEOUT) {
					snake2.stuck = 0;
					snake_punish(2);
				}
				return;
			}
		}
		// move forward
		snake2.stuck = 0;
		snake2.moved = snake2.direction;
		snake2.start++;
		snake2.x[snake2.start] = nx;
		snake2.y[snake2.start] = ny;
		if (snake2.grow > 0) {
			snake2.grow--;
			if (snake2.length < SNAKE_MAX) {
				snake2.length++;
				tail_moved = 0;
				snake2.trail = 0;	// growth cancels an active hazardous trail immediately
			} else
				snake2.end++;
		} else {
			snake2.end++;
		}
	}
	snake_draw_head(s);
	snake_draw_tail(s, tail_moved);
}

// initialize, reset both snakes, reset the score if reset_score != 0
void snake_init(uint8_t reset_score) {
	snake_reset(1, reset_score);
	snake1.status = SNAKE_ACTIVE;
	snake1.direction = SDIR_LEFT;
	snake1.moved = SDIR_LEFT;

	snake_add(1, 18, 11);
	snake_add(1, 17, 11);
	snake_add(1, 16, 11);
	snake_add(1, 15, 11);
	snake_add(1, 14, 11);
	snake_add(1, 13, 11);

	snake_reset(2, reset_score);
	snake2.status = SNAKE_ACTIVE;
	snake2.direction = SDIR_RIGHT;
	snake2.moved = SDIR_RIGHT;

	snake_add(2, 22, 11);
	snake_add(2, 23, 11);
	snake_add(2, 24, 11);
	snake_add(2, 25, 11);
	snake_add(2, 26, 11);
	snake_add(2, 27, 11);
}

// ############################################################### keyboard and joystick input during game

// return != 0 when stop key is stop_pressed
uint8_t stop_pressed() {
	__asm { sei }
	cia1.pra = 0x7f;
	uint8_t cont = (cia1.prb & 0x80);
	__asm { cli }
	if (cont)
		return 0;
	else
		return 1;
}

#define JOY_UP      0x01
#define JOY_DOWN    0x02
#define JOY_LEFT    0x04
#define JOY_RIGHT   0x08
#define JOY_FIRE    0x10

// lookup table for calculating the next direction based on the last executed step (moved)
// joystick bits after inversion -> new direction, index [moved][joy & 0x0f], 0xff = no change
// single direction: taken as is, reverse ignored
// diagonal containing the current heading: no change (protects against a stick held slightly off-axis)
// diagonal of reverse + perpendicular: the perpendicular part
// a held stick position never changes the direction a second time, so there is no staircase movement
const uint8_t JOY_DIR[4][16] = {
	//	    -     U     D    UD     L    UL    DL     -     R    UR    DR     -     -     -     -     -
	{ 0xff,    0, 0xff, 0xff,    3, 0xff,    3, 0xff,    1, 0xff,    1, 0xff, 0xff, 0xff, 0xff, 0xff },	// last step U
	{ 0xff,    0,    2, 0xff, 0xff,    0,    2, 0xff,    1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },	// last step R
	{ 0xff, 0xff,    2, 0xff,    3,    3, 0xff, 0xff,    1,    1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },	// last step D
	{ 0xff,    0,    2, 0xff,    3, 0xff, 0xff, 0xff, 0xff,    0,    2, 0xff, 0xff, 0xff, 0xff, 0xff }	// last step L
};

// read joystick, the new direction is looked up for the last executed step (moved), not the pending one,
// so neither a diagonal nor two turns within one advance period can reverse the snake
void snake_control(uint8_t s) {
	if (s == 1) {
		uint8_t joy = ~cia1.pra;		// joystick 2
		uint8_t d = JOY_DIR[snake1.moved][joy & 0x0f];
		if (d != 0xff)
			snake1.direction = d;
//		if (!(joy & JOY_FIRE))
//			fire();
		return;
	}
	if (s == 2) {
		__asm { sei }
		cia1.pra = 0xff;				// deselect all keyboard columns, otherwise keys in column 7 act as joystick 1
		uint8_t joy = ~cia1.prb;		// joystick 1
		cia1.pra = 0x7f;				// restore the value the KERNAL keyboard scan leaves
		__asm { cli }
		uint8_t d = JOY_DIR[snake2.moved][joy & 0x0f];
		if (d != 0xff)
			snake2.direction = d;
//		if (!(joy & JOY_FIRE))
//			fire();
		return;
	}
}

// ############################################################### computer player

// = 0 if the direction is not available (body of snake, obstacle, hazard ...), 1 = available, 2 = forced (food)
#define SDIR_BLOCKED	0
#define SDIR_AVAILABLE	1
#define SDIR_FORCED		2

// bonus score for keeping the current direction, reduces movement direction jitter
#define SDIR_STICKINESS	3

uint8_t snake_dir_available[4];

uint8_t sce_empty, sce_food, sce_hazard;	// number of empty and food tiles found during exploration
uint8_t sce_i;

const uint8_t sce_offset[60] = {		// offset that needs to be added to probe the next screen position, x0 and y0 always top left
	+1, +1, +1, +1, +36,	+1, +1, +1, +1, +36,	+1, +1, +1, +1,	0,					// walk the screen when the snake heading is up
	+1, +1, +38,	+1, +1, +38,	+1, +1, +38,	+1, +1, +38,	+1, +1, 0,			// walk the screen when the snake heading is right
	+1, +1, +1, +1, +36,	+1, +1, +1, +1, +36,	+1, +1, +1, +1, 0,					// walk the screen when the snake heading down
	+1, +1, +38,	+1, +1, +38,	+1, +1, +38,	+1, +1, +38,	+1, +1, 0			// walk the screen when the snake heading is left
};

const uint8_t sce_weight[60] = {
	+2, +3, +4, +3, +2,		+3, +4, +5, +4, +3,		+4, +5, +6, +5, +4,					// weights for the position when heading up
	+4, +3, +2,		+5, +4, +3,		+6, +5, +4,		+5, +4, +3,		+4, +3, +2, 		// weights for the position when heading right
	+4, +5, +6, +5, +4,		+3, +4, +5, +4, +3,		+2, +3, +4, +3, +2,					// weights for the position when heading down
	+2, +3, +4,		+3, +4, +5,		+4, +5, +6,		+3, +4, +5,		+2, +3, +4, 		// weights for the position when heading left
};

// evaluate the vicinity of the snake head
void snake_computer_explore(uint8_t cx, uint8_t cy, uint8_t sce_offset_ndx) {
	__asm {
		ldy     cy					// put top (left) screen row address into load instruction
		lda		scr_row_low,y
		sta		_load+1
		lda		scr_row_high,y
		sta		_load+2

		lda		#0					// init counters
		sta		sce_empty
		sta		sce_food
		sta		sce_hazard
		lda		#15
		sta		sce_i

		ldy		sce_offset_ndx		// load index

		ldx     cx
	_loop:
	_load:
		lda		$ffff,x				// modified to actual screen address

		cmp		#TILE_EMPTY			// is it empty?
		bne		_c1
		inc		sce_empty
		jmp		_continue

	_c1:
		cmp		#TILE_FOOD			// is it food?
		bne		_c2
		lda		sce_food
		clc
		adc		sce_weight,y
		sta		sce_food
		jmp		_continue

	_c2:
		lda		sce_hazard			// must be hazard
		clc
		adc		sce_weight,y
		sta		sce_hazard

	_continue:
		txa							// add offset to x
		clc
		adc		sce_offset,y
		tax
		iny

		dec		sce_i				// loop
		bne		_loop
	}
}

void snake_computer(uint8_t s) {
	uint8_t hx, hy, hd;		// snake head position and direction
	switch (s) {
		case 1:
			hx = snake1.x[snake1.start];
			hy = snake1.y[snake1.start];
			hd = snake1.direction;
			break;
		case 2:
			hx = snake2.x[snake2.start];
			hy = snake2.y[snake2.start];
			hd = snake2.direction;
			break;
		default:
			return;
	}
	uint8_t forced_move = 0, forced_move_direction = 0;		// check available directions
	for (uint8_t i = 0; i < 4; i++) {
		if (i == (hd ^ 2)) {						// cannot reverse 180°
			snake_dir_available[i] = SDIR_BLOCKED;
		} else {
			uint8_t nx = hx + ddx[i];						// no bounds check necessary, head stays within +1 .. MAX-1
			uint8_t ny = hy + ddy[i];
			uint8_t c = gfx_scr_get_xy(nx, ny);
			if (c == TILE_HAZARD)
				snake_dir_available[i] = SDIR_BLOCKED;
			else
				if (c == TILE_FOOD) {
					snake_dir_available[i] = SDIR_FORCED;
					forced_move++;
					forced_move_direction = i;
				} else
					if (c != TILE_EMPTY)
						snake_dir_available[i] = SDIR_BLOCKED;
					else
						snake_dir_available[i] = SDIR_AVAILABLE;
		}
	}
	if (forced_move) {
		if (s == 1) {
			snake1.direction = forced_move_direction;
			return;
		}
		if (s == 2) {
			snake2.direction = forced_move_direction;
			return;
		}
	}
	// test the 5x5 environment one step into each available direction (and the number of empty spaces
	// in this direction and then calculate the score
	uint8_t nhd = hd;	// new head direction defaults to current one
	int max_score = INT16_MIN;
	for (uint8_t i = 0; i < 4; i++) {
		if (snake_dir_available[i] == SDIR_AVAILABLE) {
			uint8_t empty_ahead = 0;
			// count number of empty or food spaces ahead in the chosen direction (max of 6)
			int8_t cx = hx + ddx[i];
			int8_t cy = hy + ddy[i];
			for (uint8_t j = 0; j < 6; j++) {
				cx += ddx[i];
				cy += ddy[i];
				if (cx < 0)
					break;
				if (cx > 39)
					break;
				if (cy < 0)
					break;
				if (cy > 23)
					break;
				uint8_t c = gfx_scr_get_xy((uint8_t) cx, (uint8_t) cy);
				if (c == TILE_EMPTY || c == TILE_FOOD) {
					empty_ahead++;
				} else {
					break;
				}
			}

			// evaluate a 5x3 field ahead of the snake in a given direction: empty cells, food and hazards
			uint8_t cx0, cy0, ndx;
			switch (i) {
				case 0:		// up
					cx0 = hx > 2 ? hx - 2 : 0;
					cx0 = cx0 > 39 - 4 ? 39 - 4 : cx0;
					cy0 = hy > 2 ? hy - 2 : 0;
					cy0 = cy0 > 23 - 2 ? 23 - 2 : cy0;
					ndx = 0;
					break;
				case 1:		// right
					cx0 = hx;
					cx0 = cx0 > 39 - 2 ? 39 - 2 : cx0;
					cy0 = hy > 2 ? hy - 2 : 0;
					cy0 = cy0 > 23 - 4 ? 23 - 4 : cy0;
					ndx = 15;
					break;
				case 2:		// down
					cx0 = hx > 2 ? hx - 2 : 0;
					cx0 = cx0 > 39 - 4 ? 39 - 4 : cx0;
					cy0 = hy;
					cy0 = cy0 > 23 - 2 ? 23 - 2 : cy0;
					ndx = 30;
					break;
				case 3:		// left
					cx0 = hx > 2 ? hx - 2 : 0;
					cx0 = cx0 > 39 - 2 ? 39 - 2 : cx0;
					cy0 = hy > 2 ? hy - 2 : 0;
					cy0 = cy0 > 23 - 4 ? 23 - 4 : cy0;
					ndx = 45;
					break;
				default:
					cx0 = 0;
					cy0 = 0;
					ndx = 0;
					break;
			}
			snake_computer_explore(cx0, cy0, ndx);

			int score = sce_empty + sce_food - sce_hazard + (rng_next() & 0x03) + 2 * empty_ahead;
			if (i == hd)
				score += SDIR_STICKINESS;	// bias towards keeping the current direction

			if (score > max_score) {		// track maximum score and store new head direction
				max_score = score;
				nhd = i;
			}
		}
	}
	// set new direction
	if (s == 1)
		snake1.direction = nhd;
	if (s == 2)
		snake2.direction = nhd;
}

// ############################################################### food

typedef struct {
	uint8_t x;
	uint8_t y;
	uint8_t active;
	uint8_t age;
} Food;

#define FOOD_MAX			4
#define FOOD_INACTIVE		0
#define FOOD_ACTIVE			1
#define FOOD_SPAWN_TRIES	5
#define FOOD_DURATION		16				// stick to something is easy to do using integer arithmetics and hope the compiler optimizes it

Food food[FOOD_MAX];

void food_init() {
	for (uint8_t i = 0; i < FOOD_MAX; i++)
		food[i].active = FOOD_INACTIVE;
}

// mark the food slot at x,y inactive (e.g. called when a snake eats it)
void food_deactivate(uint8_t x, uint8_t y) {
	for (uint8_t i = 0; i < FOOD_MAX; i++) {
		if (food[i].active == FOOD_ACTIVE && food[i].x == x && food[i].y == y) {
			food[i].active = FOOD_INACTIVE;
			return;
		}
	}
}

// checks if food needs to spawn or despawn
void food_check() {
	uint8_t search_performed = 0;
	for (uint8_t i = 0; i < FOOD_MAX; i++) {
		if (food[i].active == FOOD_INACTIVE) {
			// food inactive -> spawn but only once per check because it's expensive
			if (!search_performed) {
				search_performed = 1;
				for (uint8_t j = 0; j < FOOD_SPAWN_TRIES; j++) {
					uint8_t x = 1 + (rng_next() % 38); // oscar64 modulo is sufficiently fast
					uint8_t y = 1 + (rng_next() % 22);
					if (gfx_scr_get_xy(x, y) == TILE_EMPTY) {
						food[i].x = x;
						food[i].y = y;
						food[i].age = FOOD_DURATION + (rng_next() % FOOD_DURATION);
						food[i].active = 1;
						gfx_draw_food(x, y);
						break;
					}
				}
			}
		} else {
			// food active -> age and despawn if necessary
			if (food[i].age > 0) {
				food[i].age--;
			} else {
				food[i].active = FOOD_INACTIVE;
				gfx_scr_set_xy(food[i].x, food[i].y, TILE_EMPTY);
			}
		}
	}
}

// ############################################################### hazards/obstacles

#define HAZARD_FIXED		0		// permanent hazard
#define HAZARD_REMOVABLE	1		// removable by a 'key' event

typedef struct {
	uint8_t map;		// map type (0..4) this hazard belongs to
	uint8_t kind;		// HAZARD_FIXED or HAZARD_REMOVABLE
	uint8_t x;			// top left x and y
	uint8_t y;
	uint8_t w;			// width and height (a bar is w x 1 or 1 x h)
	uint8_t h;
} Hazard;

// all hazards of all map types, game_hazard_map picks the rows of the current map type, rows can be added in any order, max. REM_HAZARDS_MAX locked hazards per map type
const Hazard hazard[] = {
	// map type 0: two removable bars
	{ 0, HAZARD_REMOVABLE,  5,  5, 30,  1 },
	{ 0, HAZARD_REMOVABLE,  5, 16, 30,  1 },
	// map type 1: four horizontal bars, two removable bars in between
	{ 1, HAZARD_FIXED,      5,  5, 11,  1 },
	{ 1, HAZARD_FIXED,     24,  5, 11,  1 },
	{ 1, HAZARD_FIXED,      5, 16, 11,  1 },
	{ 1, HAZARD_FIXED,     24, 16, 11,  1 },
	{ 1, HAZARD_REMOVABLE, 16,  5,  8,  1 },
	{ 1, HAZARD_REMOVABLE, 16, 16,  8,  1 },
	// map type 2: four crosses
	{ 2, HAZARD_FIXED,      5,  5,  8,  1 },
	{ 2, HAZARD_FIXED,      5, 18,  8,  1 },
	{ 2, HAZARD_FIXED,     27,  5,  8,  1 },
	{ 2, HAZARD_FIXED,     27, 18,  8,  1 },
	{ 2, HAZARD_FIXED,      8,  3,  1,  7 },
	{ 2, HAZARD_FIXED,     31,  3,  1,  7 },
	{ 2, HAZARD_FIXED,      8, 14,  1,  7 },
	{ 2, HAZARD_FIXED,     31, 14,  1,  7 },
	{ 2, HAZARD_REMOVABLE, 13,  5, 14,  1 },
	{ 2, HAZARD_REMOVABLE, 13, 18, 14,  1 },
	// map type 3: four blocks
	{ 3, HAZARD_FIXED,      5,  3,  8,  1 },
	{ 3, HAZARD_FIXED,      5, 14,  8,  1 },
	{ 3, HAZARD_FIXED,     27,  3,  8,  1 },
	{ 3, HAZARD_FIXED,     27, 14,  8,  1 },
	{ 3, HAZARD_FIXED,      5, 10,  8,  1 },
	{ 3, HAZARD_FIXED,      5, 21,  8,  1 },
	{ 3, HAZARD_FIXED,     27, 10,  8,  1 },
	{ 3, HAZARD_FIXED,     27, 21,  8,  1 },
	{ 3, HAZARD_REMOVABLE, 12,  4,  1,  6 },
	{ 3, HAZARD_REMOVABLE, 27,  4,  1,  6 },
	{ 3, HAZARD_REMOVABLE, 12, 15,  1,  6 },
	{ 3, HAZARD_REMOVABLE, 27, 15,  1,  6 },
	{ 3, HAZARD_REMOVABLE, 16,  7,  7,  1 },
	{ 3, HAZARD_REMOVABLE, 16, 18,  7,  1 },
	// map type 4: four L-like obstacles and four bars with a hook
	{ 4, HAZARD_FIXED,      3,  3, 11,  1 },
	{ 4, HAZARD_FIXED,      6,  9, 11,  1 },
	{ 4, HAZARD_FIXED,      6, 14, 11,  1 },
	{ 4, HAZARD_FIXED,      3, 19, 11,  1 },
	{ 4, HAZARD_FIXED,     26,  3, 11,  1 },
	{ 4, HAZARD_FIXED,     23,  9, 11,  1 },
	{ 4, HAZARD_FIXED,     23, 14, 11,  1 },
	{ 4, HAZARD_FIXED,     26, 19, 11,  1 },
	{ 4, HAZARD_FIXED,      3,  3,  1,  4 },
	{ 4, HAZARD_FIXED,     36,  3,  1,  4 },
	{ 4, HAZARD_FIXED,      3, 16,  1,  4 },
	{ 4, HAZARD_FIXED,     36, 16,  1,  4 },
	{ 4, HAZARD_FIXED,     16,  6,  1,  4 },
	{ 4, HAZARD_FIXED,     23,  6,  1,  4 },
	{ 4, HAZARD_FIXED,     16, 14,  1,  4 },
	{ 4, HAZARD_FIXED,     23, 14,  1,  4 },
	{ 4, HAZARD_REMOVABLE, 14,  3, 12,  1 },
	{ 4, HAZARD_REMOVABLE, 14, 19, 12,  1 },
	{ 4, HAZARD_REMOVABLE,  6, 10,  1,  4 },
	{ 4, HAZARD_REMOVABLE, 33, 10,  1,  4 }
};

#define HAZARD_N	((uint8_t) (sizeof(hazard) / sizeof(hazard[0])))

void game_draw_hazard(const uint8_t ndx, const uint8_t chr);	// declaration

#define REM_HAZARDS_MAX		8
#define REM_HAZARDS_NONE	0xff
uint8_t rem_hazard[REM_HAZARDS_MAX];		// removable hazards (index into hazard[]) of the current level, == REM_HAZARDS_NONE -> invalid

// ############################################################### events

#define EVENT_N	SPR_N		// = number of simultaneous sprites

enum EventType {
	HEART,
	SCORPION,
	BARREL,
	KEY
};

typedef struct {
	uint8_t active;				// 1 = active, 0 otherwise
	enum EventType type;
	uint16_t xpos;				// 0 .. 320 + SPR_OFFSET_X
	uint8_t xdir;				// 0 = moving left, 1 = moving right
	uint8_t ypos;				// SPR_OFFSET_Y .. SPR_OFFSET + 200
	uint8_t animate_counter;	// animation counter (specific for EventType)
	uint8_t animate_state;		// animation state (specific for EventType)
} Event;

Event event[EVENT_N];

void event_init() {
	for (uint8_t i = 0; i < EVENT_N; i++)
		event[i].active = 0;
}

// add the given event type if a slot is available
void event_add(enum EventType t) {
	uint8_t row;
	uint8_t ndx = 0;
	while (event[ndx].active) {
		ndx++;
		if (ndx == 8)
			return;
	}
	switch (t) {
		// spawning behaviour is the same for all four events
		case HEART:
		case SCORPION:
		case BARREL:
		case KEY:
			event[ndx].active = 1;
			event[ndx].type = t;
			row = (rng_next() % 22) + 1;
			// ypos set so that the sprite center is in the middle of a row
			event[ndx].ypos = (row << 3) + 4 + SPR_OFFSET_Y - 10;
			if (rng_next() & 1) {
				event[ndx].xpos = 8;
				event[ndx].xdir = 1;
			} else {
				event[ndx].xpos = 320 + SPR_OFFSET_X - 8;
				event[ndx].xdir = 0;
			}
			event[ndx].animate_counter = 0;
			event[ndx].animate_state = 0;
			break;
	}
}

// top and bottom character from screen for routine below
uint8_t ecc_chr_top, ecc_chr_bottom;

// true for any of the four directional head characters SP_HEADU..SP_HEADL (SP_HEADU must be a multiple of 4)
#define IS_HEAD(c)	(((c) & 0xfc) == SP_HEADU)

// check sprite collision with snakes, return 0 if none, snake number otherwise, (x is 0..319 + SPR_OFFSET_X and needs to be 16 bit)
uint8_t event_check_collision(uint16_t x, uint8_t y) {
	uint8_t clr;

	// top character row overlapping with sprite, always on the screen (0..24), yc + 1 is always on the screen too, see above
	uint8_t yc = (y - SPR_OFFSET_Y + 10 - 4) >> 3;

	// left character column overlapping with sprites, can be off the screen if x + 8 < SPR_OFFSET, which can happen during movement to the left
	uint8_t xc = (uint8_t) ((x - SPR_OFFSET_X + 12 - 4) >> 3);
	uint8_t skip_left = x + 8 < SPR_OFFSET_X ? 1 : 0;

	// right character column overlapping with sprites, can be off the screen if x + 12 >= 320 + SPR_OFFSET_X, which can happen during movement to the left
	uint8_t skip_right = x + 8 >= SPR_OFFSET_X + 320 ? 1 : 0;

	// test left column
	if (!skip_left) {
		// get character at xc, yc and xc, cy + 1
		__asm {
			ldy     yc					// put top screen row address into load instruction
			lda		scr_row_low,y
			sta		_load1+1
			sta		_load2+1
			lda		scr_row_high,y
			sta		_load1+2
			sta		_load2+2

			ldx     xc
		_load1:
			lda		$ffff,x				// modified to actual screen row address
			sta		ecc_chr_top
			txa							// next row
			clc
			adc		#40
			tax
		_load2:
			lda		$ffff,x				// modified to actual screen row address
			sta		ecc_chr_bottom
		}
		if (IS_HEAD(ecc_chr_top) || ecc_chr_top == SP_TAIL1 || ecc_chr_top == SP_TAIL2 || ecc_chr_top == SP_BODY) {
			clr = gfx_clr_get_xy(xc, yc);
			if (clr == COLOR_SNAKE1)
				return 1;
			if (clr == COLOR_SNAKE2)
				return 2;
		}
		if (IS_HEAD(ecc_chr_bottom) || ecc_chr_bottom == SP_TAIL1 || ecc_chr_bottom == SP_TAIL2 || ecc_chr_bottom == SP_BODY) {
			clr = gfx_clr_get_xy(xc, yc + 1);
			if (clr == COLOR_SNAKE1)
				return 1;
			if (clr == COLOR_SNAKE2)
				return 2;
		}
	}

	// test right column
	if (!skip_right) {
		// get character at xc + 1, yc and xc + 1, cy + 1
		__asm {
			ldy     yc					// put top screen row address into load instruction
			lda		scr_row_low,y
			sta		_load1+1
			sta		_load2+1
			lda		scr_row_high,y
			sta		_load1+2
			sta		_load2+2

			ldx     xc
			inx
		_load1:
			lda		$ffff,x				// modified to actual screen row address
			sta		ecc_chr_top
			txa							// next row
			clc
			adc		#40
			tax
		_load2:
			lda		$ffff,x				// modified to actual screen row address
			sta		ecc_chr_bottom
		}
		if (IS_HEAD(ecc_chr_top) || ecc_chr_top == SP_TAIL1 || ecc_chr_top == SP_TAIL2 || ecc_chr_top == SP_BODY) {
			clr = gfx_clr_get_xy(xc + 1, yc);
			if (clr == COLOR_SNAKE1)
				return 1;
			if (clr == COLOR_SNAKE2)
				return 2;
		}
		if (IS_HEAD(ecc_chr_bottom) || ecc_chr_bottom == SP_TAIL1 || ecc_chr_bottom == SP_TAIL2 || ecc_chr_bottom == SP_BODY) {
			clr = gfx_clr_get_xy(xc + 1, yc + 1);
			if (clr == COLOR_SNAKE1)
				return 1;
			if (clr == COLOR_SNAKE2)
				return 2;
		}
	}
	return 0;
}

// sprite animations (i.e. sequence of sprites cycled through for an event, must be 5)
const uint8_t heart_animate[5] = {3, 4, 5, 4, 3};
const uint8_t scorpion_animate[5] = {0, 1, 2, 1, 0};
const uint8_t scorpion_animate_flipped[5] = {6, 7, 8, 7, 6};
const uint8_t barrel_animate[5] = {9, 10, 11, 11, 9};
const uint8_t key_animate[5] = {14, 13, 12, 13, 14};

// process all events including display updates, call once per frame
void event_process() {
	for (uint8_t i = 0; i < EVENT_N; i++) {
		if (event[i].active) {
			// update animation counter
			event[i].animate_counter++;
			if (event[i].animate_counter >= 3) {
				event[i].animate_counter = 0;
				event[i].animate_state++;
				if (event[i].animate_state >= 5)
					event[i].animate_state = 0;
			}
			// movement
			if (event[i].xdir) {
				event[i].xpos++;
				if (event[i].xpos > (SPR_OFFSET_X + 320 - 8))
					event[i].active = 0;
			} else {
				event[i].xpos--;
				if (event[i].xpos < (SPR_OFFSET_X - 16))
					event[i].active = 0;
			}
			if (event[i].active) {
				// handle individual events if the event is still active
				// check collision with snake -> consume and disable event
				uint8_t collision = event_check_collision(event[i].xpos, event[i].ypos);
				switch (event[i].type) {
					case HEART:
						if (collision == 1) {
							snake1.grow = 4;
							snake_inc_score(1, 5);
							update_score = 1;
							snd_play_eat();
							event[i].active = 0;
						}
						if (collision == 2) {
							snake2.grow = 4;
							snake_inc_score(2, 5);
							update_score = 1;
							snd_play_eat();
							event[i].active = 0;
						}
						if (event[i].active) {
							spr_image(i, 48 + heart_animate[event[i].animate_state]);
							spr_color(i, COLOR_HEART);
						}
						break;
					case SCORPION:
						if (collision == 1) {
							snake_punish(1);
							event[i].active = 0;
						}
						if (collision == 2) {
							snake_punish(2);
							event[i].active = 0;
						}
						if (event[i].active) {
							if (!event[i].xdir)
								spr_image(i, 48 + scorpion_animate[event[i].animate_state]);
							else
								spr_image(i, 48 + scorpion_animate_flipped[event[i].animate_state]);
							spr_color(i, COLOR_SCORPION);
						}
						break;
					case BARREL:
						if (collision == 1) {
							snake1.grow = 0;
							snake1.trail = 8;
							event[i].active = 0;
							snd_play_bounce();
						}
						if (collision == 2) {
							snake2.grow = 0;
							snake2.trail = 8;
							event[i].active = 0;
							snd_play_bounce();
						}
						if (event[i].active) {
							spr_image(i, 48 + barrel_animate[event[i].animate_state]);
							spr_color(i, COLOR_BARREL);
						}
						break;
					case KEY:
						if (collision) {
							for (uint8_t j = 0; j < REM_HAZARDS_MAX; j++) {
								if (rem_hazard[j] != REM_HAZARDS_NONE) {
									game_draw_hazard(rem_hazard[j], TILE_EMPTY);
									rem_hazard[j] = REM_HAZARDS_NONE;
									event[i].active = 0;
									snd_play_donk();
									break;
								}
							}
						}
						if (event[i].active) {
							spr_image(i, 48 + key_animate[event[i].animate_state]);
							spr_color(i, COLOR_KEY);
						}
						break;
				}
			}
			// disable sprite if event was switched off/is now inactive, update position and display otherwise
			if (!event[i].active) {
				spr_show(i, 0);
			} else {
				spr_show(i, 1);
				spr_move(i, event[i].xpos, event[i].ypos);
			}
		}
	}
}

// ############################################################### game core routines

// draw a single hazard from the list (w x h cells starting at x, y)
void game_draw_hazard(const uint8_t ndx, const uint8_t chr) {
	uint8_t y = hazard[ndx].y;
	for (uint8_t j = 0; j < hazard[ndx].h; j++) {
		uint8_t x = hazard[ndx].x;
		for (uint8_t i = 0; i < hazard[ndx].w; i++) {
			gfx_set_xy(x, y, COLOR_HAZARD, chr);
			x++;
		}
		y++;
	}
}

// number of removable hazard per every 5 levels (1..5, 6..10, ...)
uint8_t rem_hazard_level[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

// draw the hazard map corresponding to the given level (1..50)
void game_hazard_map(uint8_t level) {
	if (level == 0 || level > 50)
		level = 50;
	for (uint8_t i = 0; i < REM_HAZARDS_MAX; i++) {
		rem_hazard[i] = REM_HAZARDS_NONE;
	}
	const uint8_t map = ((uint8_t) (level - 1)) % 5;
	// draw all hazards of this map type from the list, removable only as many as possible for that level
	uint8_t rh_ndx = 0;
	for (uint8_t i = 0; i < HAZARD_N; i++) {
		if (hazard[i].map != map)
			continue;
		if (hazard[i].kind == HAZARD_FIXED) {
			game_draw_hazard(i, TILE_HAZARD);
		} else {
			if (rh_ndx < REM_HAZARDS_MAX && rh_ndx < rem_hazard_level[((uint8_t) (level - 1)) / 5]) {
				game_draw_hazard(i, TILE_REMOVABLE);
				rem_hazard[rh_ndx] = i;
				rh_ndx++;
			}
		}
	}
}

#define ADVANCE_TICKS		6		// number of frames between snake advances at full speed, must be > 2 and divisible by 2 and 3 (speeds 2/4 and 3/4)
#define COMPUTER_TICKS		3		// number of frames between computer moves, must be > 2
#define FOOD_TICKS			50		// number of frames between food checks
#define LEVEL_TIMER_TICKS	50		// number of frames between level timer ticks (e.g. 50)
uint16_t EVENT_SPAWN_TICKS = 50;	// number of frames between event spawns (16 bit, scaled by the speed factor)

// EVENT_SPAWN_TICKS for every 5 levels (1..5, 6..10, etc.) at full speed
uint8_t EVENT_SPAWN_TICKS_LVL[10] = { 200, 150, 100, 100, 50, 50, 25, 25, 25, 25};

// game speed for every 5 levels in quarters of full speed (2 = 50%, 3 = 75%, 4 = 100%), applies to snake
// advances, event movement and event spawning, level timer and food checks stay in real time
#define SPEED_FULL	4
uint8_t SPEED_LVL[10] = { 2, 3, 4, 4, 4, 4, 4, 4, 4, 4};

// event spawning probability per every 5 levels, p = number from below / 128
uint8_t EVENT_SPAWN_KEY_LVL[10] =		{ 20, 20, 20, 20, 20, 20, 15, 15, 10, 10};
uint8_t EVENT_SPAWN_FOOD_LVL[10] =		{ 80, 75, 70, 60, 40, 35, 30, 25, 20, 15};
uint8_t EVENT_SPAWN_BARREL_LVL[10] =	{ 20, 20, 25, 30, 30, 30, 30, 25, 20, 15};

#define PLAYER_VS_PLAYER	0		// p v p
#define PLAYER_VS_COMPUTER	1		// p v e

uint8_t game_mode = PLAYER_VS_COMPUTER;

const uint8_t level_timer_char[] = {32, 101, 97, 234, 224};

char level_str[] = S"LEVEL ## OF 50";

uint8_t highscore[3][4] = {
	{0, 0, 0, 0},
	{0, 0, 0, 0},
	{0, 0, 0, 0}
};

const uint8_t fileID = 2;
const uint8_t channel = 2;

// drive the highscores are loaded from and saved to, set by game_init_device()
uint8_t game_device = 8;

// use the device the game was loaded from (the KERNAL keeps the last used device at $BA),
// drive 8 if the game was not loaded from a disk drive (e.g. tape = 1, or 0 if unknown)
void game_init_device(void) {
	uint8_t dev = *(volatile uint8_t *) 0xba;
	game_device = dev >= 8 ? dev : 8;
}

// read and discard the drive status (e.g. "62,FILE NOT FOUND,00,00"), this also stops
// the blinking error LED of a 1541 after a failed operation
void game_read_drive_status(void) {
	char status[40];
	krnio_setnam("");
	if (krnio_open(15, game_device, 15)) {
		krnio_read(15, status, sizeof(status));
		krnio_close(15);
	}
}

void game_save_highscores(void) {
	// delete old version
	krnio_setnam("S0:SNAKE64.HGH");
	krnio_open(15, game_device, 15);
	krnio_close(15);

	// create new version
	krnio_setnam("SNAKE64.HGH,S,W");
	if (krnio_open(fileID, game_device, channel)) {
		krnio_write(fileID, (const char*) highscore, sizeof(highscore));
		krnio_close(fileID);
	}
	game_read_drive_status();		// clears e.g. a write protect error
}

void game_load_highscores(void) {
	uint8_t ok = 0;

	// attempt to read highscore
	krnio_setnam("SNAKE64.HGH,S,R");
	if (krnio_open(fileID, game_device, channel)) {
		ok = krnio_read(fileID, (char*) highscore, sizeof(highscore)) == sizeof(highscore);
		krnio_close(fileID);
	}
	game_read_drive_status();		// clears "62,FILE NOT FOUND" when there is no highscore file yet

	// accept only a complete file with digits 0..9, otherwise start with an empty list
	uint8_t *p = (uint8_t*) highscore;
	for (uint8_t i = 0; i < sizeof(highscore); i++) {
		if (p[i] > 9)
			ok = 0;
	}
	if (!ok) {
		for (uint8_t i = 0; i < sizeof(highscore); i++)
			p[i] = 0;
	}
}

void game_loop(void) {
	uint8_t first_level = 1;		// first level of the game, only reset
	uint8_t level = 1;				// current level (1..50)
	uint8_t	stop = 0;

	while (!stop) {
		// display current level for one second
		gfx_scr_set(32);
		gfx_clr_set(1);
		level_str[6] = (level / 10) + 48;
		level_str[7] = (level % 10) + 48;
		gfx_print_xy(13, 12, C64_WHITE, level_str);
		for(uint8_t i = 0; i < 50; i++) {
			gfx_wait_frame_end();
			snd_update();
		}

		// init snakes
		snake_init(first_level);
		if (first_level) {
			first_level = 0;
		}

		// set up screen
		gfx_setup_game_screen();
		game_hazard_map(level);
		gfx_update_score();

		snake_draw_head(1);
		snake_draw_body(1);
		snake_draw_tail(1, 1);
		snake_draw_head(2);
		snake_draw_body(2);
		snake_draw_tail(2, 1);

		// set up food
		food_init();
		food_check();

		event_init();

		uint8_t advance_counter = 0;
		uint8_t computer_counter = 0;
		uint8_t food_counter = 0;
		uint8_t level_timer_counter = 0;
		uint16_t event_spawn_counter = 0;
		uint8_t event_counter = 0;
		uint8_t level_ndx = (level - 1) / 5;		// index for level configuration arrays

		// frame counts are stretched by SPEED_FULL / speed: 50% -> x2, 75% -> x4/3
		uint8_t speed = SPEED_LVL[level_ndx];
		uint8_t advance_ticks = ADVANCE_TICKS * SPEED_FULL / speed;
		EVENT_SPAWN_TICKS = (uint16_t) EVENT_SPAWN_TICKS_LVL[level_ndx] * SPEED_FULL / speed;

		uint8_t level_timer1 = 9;			// 9 main ticks, do not change
		uint8_t level_timer2 = 4;			// 4 sub ticks, do not change

		update_score = 1;					// update the score at the beginning of each game loop

		stop = 0;
		while (!stop) {
			// update score if need, can be late after last end-of-frame wait, bottom part
			if (update_score) {
				gfx_update_score();
				update_score = 0;
			}

			// sound update, just before the end-of-frame wait, no graphics involved
			snd_update();

			// read player controls, just before the end-of-frame wait, no graphics involved
			snake_control(1);
			if (game_mode == PLAYER_VS_PLAYER)
				snake_control(2);

			gfx_wait_frame_end();			// *** end of frame wait, this sync's the game loop

			__asm {							// update background color and reset to black for next frame
				lda		background_color
				sta     $d021           	// set background color
				lda		#C64_BLACK
				sta		background_color
			}
			event_counter += speed;			// update events and their sprites in speed out of SPEED_FULL frames, evenly spread
			if (event_counter >= SPEED_FULL) {
				event_counter -= SPEED_FULL;
				event_process();
			}

			snake_draw_head(1);			// redraw player heads to account for potential new heading
			snake_draw_head(2);

			computer_counter++;
			advance_counter++;
			food_counter++;
			level_timer_counter++;
			event_spawn_counter++;

			if (advance_counter >= advance_ticks) {
				if (snake1.status == SNAKE_ACTIVE) {
					snake_advance(1);
				}
				if (snake2.status == SNAKE_ACTIVE) {
					snake_advance(2);
				}
				advance_counter = 0;
			} else {
				// computer player only gets to update its direction every three loops and only in a loop without snake advancing/drawing
				if (computer_counter >= COMPUTER_TICKS) {
					if(game_mode == PLAYER_VS_COMPUTER)
						snake_computer(2);
					computer_counter = 0;
				} else {
					// event spawning only happens when the timer is up and only when there's no snake advancing/drawing
					if (event_spawn_counter >= EVENT_SPAWN_TICKS) {
						event_spawn_counter = 0;
						uint8_t rng = rng_next() & 0x7F;
						if (rng < EVENT_SPAWN_KEY_LVL[level_ndx]) {
							uint8_t rem_hazard_present = 0;
							for (uint8_t i = 0; i < REM_HAZARDS_MAX; i++)
								if (rem_hazard[i] != REM_HAZARDS_NONE) {
									rem_hazard_present++;
									break;
								}
							if (rem_hazard_present)
								event_add(KEY);
							else
								event_add(HEART);
						} else {
							if (rng < EVENT_SPAWN_FOOD_LVL[level_ndx] + EVENT_SPAWN_KEY_LVL[level_ndx]) {
								event_add(HEART);
							} else {
								if (rng < EVENT_SPAWN_BARREL_LVL[level_ndx] + EVENT_SPAWN_FOOD_LVL[level_ndx] + EVENT_SPAWN_KEY_LVL[level_ndx]) {
									event_add(BARREL);
								} else {
									event_add(SCORPION);
								}
							}
						}
					} else {
						// food checks only occur when nothing else happens, it can take a significant amount of time
						if (food_counter >= FOOD_TICKS) {
							food_check();
							food_counter = 0;
						}
					}
				}
			}

			// tick down
			if (level_timer_counter >= LEVEL_TIMER_TICKS) {
				level_timer_counter = 0;
				level_timer2--;
				gfx_scr_set_xy(15 + level_timer1, 24, level_timer_char[level_timer2]);
				snd_play_timer_tick_n(level_timer1 * 4 + level_timer2);
				if (level_timer2 == 0) {
					level_timer2 = 4;
					if (level_timer1 == 0) {
						snd_play_final_timer_tick();
						break;
					} else {
						level_timer1--;
					}
				}
			}

			// exit if both snakes are dead
			if (snake1.status == SNAKE_DEAD && snake2.status == SNAKE_DEAD)
				break;
			// set stop flag when stop is pressed
			if (stop_pressed())
				stop++;
		}
		__asm {							// restore background color to black
			lda		#C64_BLACK
			sta		background_color
			sta     $d021           	// set background color
		}
		gfx_spr_hide_all();
		gfx_fade_to_black();

		level++;
		if (level > 50)
			level = 50;

		// no further levels if both snakes are dead
		if (snake1.status == SNAKE_DEAD && snake2.status == SNAKE_DEAD)
			stop++;
	}
}

// snake for the menu and game over screen
char snake_str[] = {SP_TAIL2, SP_TAIL1, SP_BODY, SP_BODY, SP_BODY, SP_HEADR, 0};

void game_over() {
	gfx_clr_set(C64_BLACK);
	gfx_scr_set(32);
	gfx_print_xy(15, 11, C64_LIGHT_RED, S"GAME OVER");
	gfx_print_xy(13, 14, COLOR_SNAKE1, snake_str);
	gfx_print_xy(13, 16, COLOR_SNAKE2, snake_str);
	for (uint8_t i = 0; i < 4; i++) {
		gfx_set_xy(20 + i, 14, COLOR_SNAKE1, snake1.score[3 - i] + 48);
		gfx_set_xy(20 + i, 16, COLOR_SNAKE2, snake2.score[3 - i] + 48);
	}
	for (uint8_t i = 0; i < 150; i++) {
		gfx_wait_frame_end();
		snd_update();
	}
}

// fixed texts of the menu: position, color and screen code string
typedef struct {
	uint8_t x, y, color;
	const char *str;
} ScreenText;

const ScreenText menu_text[] = {
	{0, 9, C64_WHITE, S"MENU"},
	{2, 11, C64_LIGHT_GRAY, S"F1   START GAME"},
	{2, 13, C64_LIGHT_GRAY, S"F3   CHANGE MODE"},
	{2, 17, C64_LIGHT_GRAY, S"F5   EXIT"},
	{28, 10, C64_DARK_GRAY, S"CHRHE (2026)"},
	{30, 20, C64_LIGHT_RED, S"HIGHSCORES"},
	{0, 20, C64_WHITE, S"LAST SCORES"},
	{2, 22, COLOR_SNAKE1, snake_str},
	{2, 24, COLOR_SNAKE2, snake_str},
	{33, 22, C64_LIGHT_RED, S"1."},
	{33, 23, C64_LIGHT_RED, S"2."},
	{33, 24, C64_LIGHT_RED, S"3."}
};

uint8_t game_menu() {
	gfx_clr_set(C64_BLACK);
	gfx_scr_set(32);
	gfx_draw_snake_logo();

	for (uint8_t t = 0; t < sizeof(menu_text) / sizeof(menu_text[0]); t++)
		gfx_print_xy(menu_text[t].x, menu_text[t].y, menu_text[t].color, menu_text[t].str);

	for (uint8_t i = 0; i < 4; i++) {
		gfx_set_xy(14 + i, 22, COLOR_SNAKE1, snake1.score[3 - i] + 48);
		gfx_set_xy(14 + i, 24, COLOR_SNAKE2, snake2.score[3 - i] + 48);
		gfx_set_xy(36 + i, 22, C64_LIGHT_RED, highscore[0][3 - i] + 48);
		gfx_set_xy(36 + i, 23, C64_LIGHT_RED, highscore[1][3 - i] + 48);
		gfx_set_xy(36 + i, 24, C64_LIGHT_RED, highscore[2][3 - i] + 48);
	}

	while (1) {
		gfx_print_xy(2+0, 15, C64_LIGHT_GRAY, S"     CURRENTLY PLAYER VS. ");
		if (game_mode == PLAYER_VS_PLAYER)
			gfx_print_xy(2+26, 15, C64_LIGHT_GRAY, S"PLAYER  ");
		else
			gfx_print_xy(2+26, 15, C64_LIGHT_GRAY, S"COMPUTER");
		uint8_t k = wait_for_key();
		if (k == KEY_F3)
			game_mode ^= 1;
		if (k == KEY_F1)
			return 1;
		if (k == KEY_F5)
			return 0;
	}
}

// compares score, returns 1 if score 1 > score 2, 0 otherwise
uint8_t game_better_score(const uint8_t* score1, const uint8_t* score2) {
	for (int8_t i = 3; i >= 0; i--) {
		if (score1[i] > score2[i])
			return 1;
		if (score1[i] < score2[i])
			return 0;
	}
	return 0;
}

// test if a score should be added to the highscore list, adds it if so and returns 1, 0 otherwise
uint8_t game_check_score(const uint8_t* score) {
	for (uint8_t r = 0; r < 3; r++) {
		if (game_better_score(score, highscore[r])) {
			for (uint8_t i = 0; i < 4; i++) {
				if (r < 2)
					highscore[2][i] = highscore[1][i];
				if (r < 1)
					highscore[1][i] = highscore[0][i];
				highscore[r][i] = score[i];
			}
			return 1;
		}
	}
	return 0;
}

// update highscore from last results
void game_update_highscores() {
	uint8_t save = 0;
	save += game_check_score((uint8_t*) snake1.score);
	if (game_mode == PLAYER_VS_PLAYER) {
		// only player results are recorded
		save += game_check_score((uint8_t*) snake2.score);
	}
	if (save)
		game_save_highscores();
}

int main(void) {
	rng_init();
	gfx_init();
	snd_init();
	snake_init(1);		// just to initialize the score to 0 for menu()

	gfx_clr_set(C64_BLACK);	// display something on the screen when trying to load the highscores
	gfx_scr_set(32);
	gfx_draw_snake_logo();

	game_init_device();
	game_load_highscores();

	while(1) {
		kbd_flush();
		if (!game_menu())
			break;
		game_loop();
		game_over();
		game_update_highscores();
	}
	snd_stop_all();
	gfx_exit();
	return 0;
}
