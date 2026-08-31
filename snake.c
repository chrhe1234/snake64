#include <stdint.h>
#include <c64/vic.h>
#include <c64/cia.h>

#include "gfx.h"
#include "sprites.h"

// ############################################################### memory layout
// $0A00-$0BFF code/data
// $0C00-$0FFF sprites
// $1000-$1FFF code/data
// $2000-$27FF charset
// $2800-$A000 code/date/BSS/heap/stack

#pragma region(lower1, 0x0a00, 0x0c00, , , {code, data})
#pragma section(sprites, 0)
#pragma region(sprites, 0x0c00, 0x1000, , , {sprites})
#pragma region(lower2, 0x1000, 0x2000, , , {code, data})
#pragma section(charset, 0)
#pragma region(charset, 0x2000, 0x2800, , , {charset})
#pragma region(main, 0x2800, 0xa000, , , {code, data, bss, heap, stack})

// ############################################################### character set

#pragma data(charset)
// modified charset, only lowercase/graphics needed
// 94: smaller ball, shrunk version of 81 (e.g. second last bit of snake)
// 28: even smaller ball, shrunk 94 (e.g. very end of tail)
// 39: larger ball, expanded 81 (e.g. fat main body)

__export volatile uint8_t charset[2048] = {
    #embed "charset.bin"
};
#pragma data(data)

#define chrout	$ffd2				// chrout ROM address
#define getin	$ffe4				// getin ROM address

// define snake part character ids
#define SP_HEAD		87
#define	SP_BODY		39
#define	SP_TAIL1	81
#define SP_TAIL2	94
#define	SP_EMPTY	32

#define SCOLOR1		C64_LIGHT_GREEN
#define	SCOLOR2		C64_LIGHT_BLUE

// snake direction flags
#define	SDIR_UP		0
#define	SDIR_RIGHT	1
#define	SDIR_DOWN	2
#define	SDIR_LEFT	3

// snake status flags
#define	SNAKE_ACTIVE	0
#define	SNAKE_INACTIVE	1
#define	SNAKE_DEAD		2

#define	SNAKE_MAX		240

typedef struct {
	uint8_t	status;
	uint8_t	direction;				// movement direction
	uint8_t	x[256];					// "ring buffer" of snake position, 0xff -> invalid
	uint8_t	y[256];
	uint8_t	start, end, length;		// index of current start and end, length
	uint8_t	grow;					// number of rounds the snake should keep growing
} Snake;

Snake snake1, snake2;

// *** most of the code below would use pointers but for the C64 the generated code is more compact like this (i.e. with
// hardwired addresses

// reset all data for the given snake
void snake_reset(uint8_t s) {
	if (s == 1) {
		snake1.status = 0;
		snake1.direction = SDIR_RIGHT;
		snake1.start = 0;
		snake1.end = 0;
		snake1.length = 0;
		snake1.grow = 0;
		for (uint8_t i = 0;; ++i) {
			snake1.x[i] = 0xff;
			snake1.y[i] = 0xff;
			if (i == 255)
				break;
		}
		return;
	}
	if (s == 2) {
		snake2.status = 0;
		snake2.direction = SDIR_RIGHT;
		snake2.start = 0;
		snake2.end = 0;
		snake2.length = 0;
		snake2.grow = 0;
		for (uint8_t i = 0;; ++i) {
			snake2.x[i] = 0xff;
			snake2.y[i] = 0xff;
			if (i == 255)
				break;
		}
		return;
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
		gfx_scr_set_xy(snake1.x[snake1.start], snake1.y[snake1.start], SP_HEAD);
		gfx_clr_set_xy(snake1.x[snake1.start], snake1.y[snake1.start], SCOLOR1);
		uint8_t p = dec8(snake1.start);
		gfx_scr_set_xy(snake1.x[p], snake1.y[p], SP_BODY);
		gfx_clr_set_xy(snake1.x[p], snake1.y[p], SCOLOR1);
		return;
	}
	if (s == 2) {
		gfx_scr_set_xy(snake2.x[snake2.start], snake2.y[snake2.start], SP_HEAD);
		gfx_clr_set_xy(snake2.x[snake2.start], snake2.y[snake2.start], SCOLOR2);
		uint8_t p = dec8(snake2.start);
		gfx_scr_set_xy(snake2.x[p], snake2.y[p], SP_BODY);
		gfx_clr_set_xy(snake2.x[p], snake2.y[p], SCOLOR2);
		return;
	}
}

// draw tail of the snake (last two pieces and a final erase if necessary)
void snake_draw_tail(uint8_t s) {
	if (s == 1) {
		gfx_scr_set_xy(snake1.x[snake1.end], snake1.y[snake1.end], SP_TAIL2);
		gfx_clr_set_xy(snake1.x[snake1.end], snake1.y[snake1.end], SCOLOR1);
		uint8_t p1 = inc8(snake1.end);
		gfx_scr_set_xy(snake1.x[p1], snake1.y[p1], SP_TAIL1);
		gfx_clr_set_xy(snake1.x[p1], snake1.y[p1], SCOLOR1);
		uint8_t p2 = dec8(snake1.end);
		if (snake1.x[p2] != 0xff) {
			gfx_scr_set_xy(snake1.x[p2], snake1.y[p2], SP_EMPTY);
			gfx_clr_set_xy(snake1.x[p2], snake1.y[p2], SCOLOR1);
		}
		return;
	}
	if (s == 2) {
		gfx_scr_set_xy(snake2.x[snake2.end], snake2.y[snake2.end], SP_TAIL2);
		gfx_clr_set_xy(snake2.x[snake2.end], snake2.y[snake2.end], SCOLOR2);
		uint8_t p1 = inc8(snake2.end);
		gfx_scr_set_xy(snake2.x[p1], snake2.y[p1], SP_TAIL1);
		gfx_clr_set_xy(snake2.x[p1], snake2.y[p1], SCOLOR2);
		uint8_t p2 = dec8(snake2.end);
		if (snake2.x[p2] != 0xff) {
			gfx_scr_set_xy(snake2.x[p2], snake2.y[p2], SP_EMPTY);
			gfx_clr_set_xy(snake2.x[p2], snake2.y[p2], SCOLOR2);
		}
		return;
	}
}

// draw body of the snake (all except for two and last two bits)
void snake_draw_body(uint8_t s) {
	if (s == 1) {
		for (uint8_t i = snake1.start - 2;;) {
			gfx_scr_set_xy(snake1.x[i], snake1.y[i], SP_BODY);
			gfx_clr_set_xy(snake1.x[i], snake1.y[i], SCOLOR1);
			--i;
			if (i == (uint8_t) (snake1.end + 1))
				break;
		}
		return;
	}
	if (s == 2) {
		for (uint8_t i = (uint8_t) snake2.start - 2;;) {
			gfx_scr_set_xy(snake2.x[i], snake2.y[i], SP_BODY);
			gfx_clr_set_xy(snake2.x[i], snake2.y[i], SCOLOR2);
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
			gfx_clr_set_xy(snake1.x[i], snake1.y[i], C64_DARK_GRAY);
			--i;
			if (i == (uint8_t) (snake1.end - 1))
				break;
		}
		return;
	}
	if (s == 2) {
		for (uint8_t i = snake2.start;;) {
			gfx_clr_set_xy(snake2.x[i], snake2.y[i], C64_DARK_GRAY);
			--i;
			if (i == (uint8_t) (snake2.end - 1))
				break;
		}
		return;
	}
}

// snake direction changes, #define	SDIR_UP		0, #define	SDIR_RIGHT	1, #define	SDIR_DOWN	2, #define	SDIR_LEFT	3

const int8_t ddx[4] = {0, 1, 0, -1};
const int8_t ddy[4] = {-1, 0, 1, 0};

// advance snake in the correct direction
void snake_advance(uint8_t s) {
	uint8_t nx, ny, content;
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
			} else
				if (content == TILE_HAZARD) {	// collision with hazard
					if (snake1.length <= 5) {
						snake1.status = SNAKE_DEAD;
						snake_set_dead_color(1);
					} else {
						snake1.length--;
						snake1.end++;
						snake_draw_tail(1);
					}
					return;
				} else
					return;
		}
		snake1.start++;
		snake1.x[snake1.start] = nx;
		snake1.y[snake1.start] = ny;
		if (snake1.grow > 0 && snake1.length < SNAKE_MAX) {
			snake1.grow--;
			snake1.length++;
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
		if (content != TILE_EMPTY) {		// collision (!!!!!!!!!!!!!!!!!!!!!!!!)
			return;
		}
		snake2.start++;
		snake2.x[snake2.start] = nx;
		snake2.y[snake2.start] = ny;
		if (snake2.grow > 0 && snake2.length < SNAKE_MAX) {
			snake2.grow--;
			snake2.length++;
		} else {
			snake2.end++;
		}
	}
	snake_draw_head(s);
	snake_draw_tail(s);
}

// initialize, reset both snakes
void snake_init() {
	snake_reset(1);
	snake1.status = SNAKE_ACTIVE;
	snake1.direction = SDIR_LEFT;
	snake_add(1, 15, 10);
	snake_add(1, 14, 10);
	snake_add(1, 13, 10);
	snake_add(1, 12, 10);
	snake_add(1, 11, 10);
	snake_add(1, 10, 10);
	snake_reset(2);
}

uint8_t wait_for_key() {
	__asm {
	_l1:
		jsr		getin
		beq		_l1
		sta		accu
		lda		#0
		sta		accu+1
	}
}

// wait approximately 100 ms
void wait_100ms() {
	__asm {
		ldx		#80
	_outer:
		ldy		#0
	_inner:
		dey
		bne		_inner
		dex
		bne		_outer
	}
}

// wait for scan line 250, end of frame
void wait_for_frame() {
	__asm {
		lda		#250
	_wait1:
		cmp		$d012
		bne		_wait1
	_wait2:
		cmp		$d012
		beq		_wait2
	}
}

#define JOY_UP      0x01
#define JOY_DOWN    0x02
#define JOY_LEFT    0x04
#define JOY_RIGHT   0x08
#define JOY_FIRE    0x10

void snake_control(uint8_t s) {
	if (s == 1) {
		uint8_t joy = ~cia1.pra;
		if ((joy & JOY_LEFT) && snake1.direction != SDIR_RIGHT)
			snake1.direction = SDIR_LEFT;
		if ((joy & JOY_RIGHT) && snake1.direction != SDIR_LEFT)
			snake1.direction = SDIR_RIGHT;
		if ((joy & JOY_UP) && snake1.direction != SDIR_DOWN)
			snake1.direction = SDIR_UP;
		if ((joy & JOY_DOWN) && snake1.direction != SDIR_UP)
			snake1.direction = SDIR_DOWN;
//		if (!(joy & JOY_FIRE))
//			fire();
		return;
	}
}

int main(void) {
	gfx_init();
	gfx_draw_frame();

	gfx_draw_food(35, 20);
	gfx_draw_food(35, 5);
	gfx_draw_food(5, 20);
	gfx_draw_food(5, 5);

	gfx_draw_hazard(20, 3);
	gfx_draw_hazard(20, 20);

	snake_init();
	snake_draw_head(1);
	snake_draw_body(1);
	snake_draw_tail(1);

	uint8_t advance_counter = 0;
	for(;;) {
		wait_for_frame();
		snake_control(1);
		if(advance_counter++ > 5) {
			if (snake1.status == SNAKE_ACTIVE)
				snake_advance(1);
			advance_counter = 0;
		}
	}

	gfx_reset();
	return 0;
}
