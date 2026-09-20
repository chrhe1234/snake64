#include <stdlib.h>
#include <stdint.h>
#include <c64/vic.h>
#include <c64/cia.h>
#include <c64/sprites.h>

#include "snake.h"
#include "utils.h"
#include "gfx.h"
#include "sprites.h"
#include "snd.h"

// ############################################################### memory layout
// $0a00-$0bff code/data
// $0c00-$0fff sprites
// $1000-$37ff code/data
// $3800-$4000 charset (not initialized)
// $4000-$a000 BSS/heap/stack (not initialized)

#pragma region(lower1, 0x0a00, 0x0c00, , , {code, data})
#pragma section(sprites, 0, , , data)
#pragma region(sprites_region, 0x0c00, 0x1000, , , {sprites})
#pragma region(lower2, 0x1000, 0x3800, , , {code, data})
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
#define	SDIR_UP		0
#define	SDIR_RIGHT	1
#define	SDIR_DOWN	2
#define	SDIR_LEFT	3

// opposite direction, alternative is (SDIR_xyz + 2) & 0x03 but that might take a little longer
uint8_t SDIR_OPPOSITE[4] = {SDIR_DOWN, SDIR_LEFT, SDIR_UP, SDIR_RIGHT};

// snake head movement depending on direction direction changes ddx/ddy[SIDR_xyz]
const int8_t ddx[4] = {0, 1, 0, -1};
const int8_t ddy[4] = {-1, 0, 1, 0};

// snake status flags
#define	SNAKE_ACTIVE	0
#define	SNAKE_INACTIVE	1
#define	SNAKE_DEAD		2

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
		return;
	}
	if (s == 2) {
		snake2.status = 0;
		snake2.direction = SDIR_RIGHT;
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
		gfx_set_xy(snake1.x[snake1.start], snake1.y[snake1.start], S1_COLOR, SP_HEAD);
		uint8_t p = dec8(snake1.start);
		gfx_set_xy(snake1.x[p], snake1.y[p], S1_COLOR, SP_BODY);
		return;
	}
	if (s == 2) {
		gfx_set_xy(snake2.x[snake2.start], snake2.y[snake2.start], S2_COLOR, SP_HEAD);
		uint8_t p = dec8(snake2.start);
		gfx_set_xy(snake2.x[p], snake2.y[p], S2_COLOR, SP_BODY);
		return;
	}
}

// draw tail of the snake (last two pieces and a final erase if necessary)
void snake_draw_tail(uint8_t s) {
	if (s == 1) {
		gfx_set_xy(snake1.x[snake1.end], snake1.y[snake1.end], S1_COLOR, SP_TAIL2);
		uint8_t p1 = inc8(snake1.end);
		gfx_set_xy(snake1.x[p1], snake1.y[p1], S1_COLOR, SP_TAIL1);
		uint8_t p2 = dec8(snake1.end);
		if (snake1.x[p2] != 0xff) {
			gfx_set_xy(snake1.x[p2], snake1.y[p2], S1_COLOR, SP_EMPTY);
		}
		return;
	}
	if (s == 2) {
		gfx_set_xy(snake2.x[snake2.end], snake2.y[snake2.end], S2_COLOR, SP_TAIL2);
		uint8_t p1 = inc8(snake2.end);
		gfx_set_xy(snake2.x[p1], snake2.y[p1], S2_COLOR, SP_TAIL1);
		uint8_t p2 = dec8(snake2.end);
		if (snake2.x[p2] != 0xff) {
			gfx_set_xy(snake2.x[p2], snake2.y[p2], S2_COLOR, SP_EMPTY);
		}
		return;
	}
}

// draw body of the snake (all except for two and last two bits)
void snake_draw_body(uint8_t s) {
	if (s == 1) {
		for (uint8_t i = snake1.start - 2;;) {
			gfx_scr_set_xy(snake1.x[i], snake1.y[i], SP_BODY);
			gfx_clr_set_xy(snake1.x[i], snake1.y[i], S1_COLOR);
			--i;
			if (i == (uint8_t) (snake1.end + 1))
				break;
		}
		return;
	}
	if (s == 2) {
		for (uint8_t i = (uint8_t) snake2.start - 2;;) {
			gfx_scr_set_xy(snake2.x[i], snake2.y[i], SP_BODY);
			gfx_clr_set_xy(snake2.x[i], snake2.y[i], S2_COLOR);
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

// apply hazard-style punishment to snake s (shrink by one segment while long enough to survive, otherwise die)
void snake_punish(uint8_t s) {
	if (s == 1) {
		background_color = S1_COLOR;
		if (snake1.length <= 5) {
			snake1.status = SNAKE_DEAD;
			snake_set_dead_color(1);
			snd_play_death();
		} else {
			snake_dec_score(1);
			update_score = 1;
			snake1.length--;
			snake1.end++;
			snake_draw_tail(1);
			snd_play_collision();
		}
		return;
	}
	if (s == 2) {
		background_color = S2_COLOR;
		if (snake2.length <= 5) {
			snake2.status = SNAKE_DEAD;
			snake_set_dead_color(2);
			snd_play_death();
		} else {
			snake_dec_score(2);
			update_score = 1;
			snake2.length--;
			snake2.end++;
			snake_draw_tail(2);
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
		snake1.start++;
		snake1.x[snake1.start] = nx;
		snake1.y[snake1.start] = ny;
		if (snake1.grow > 0) {
			snake1.grow--;
			if (snake1.length < SNAKE_MAX)
				snake1.length++;
			else
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
		snake2.start++;
		snake2.x[snake2.start] = nx;
		snake2.y[snake2.start] = ny;
		if (snake2.grow > 0) {
			snake2.grow--;
			if (snake2.length < SNAKE_MAX)
				snake2.length++;
			else
				snake2.end++;
		} else {
			snake2.end++;
		}
	}
	snake_draw_head(s);
	snake_draw_tail(s);
}

// initialize, reset both snakes, reset the score if reset_score != 0
void snake_init(uint8_t reset_score) {
	snake_reset(1, reset_score);
	snake1.status = SNAKE_ACTIVE;
	snake1.direction = SDIR_LEFT;
	snake_add(1, 18, 11);
	snake_add(1, 17, 11);
	snake_add(1, 16, 11);
	snake_add(1, 15, 11);
	snake_add(1, 14, 11);
	snake_add(1, 13, 11);
	snake_reset(2, reset_score);
	snake2.status = SNAKE_ACTIVE;
	snake2.direction = SDIR_RIGHT;
	snake_add(2, 22, 11);
	snake_add(2, 23, 11);
	snake_add(2, 24, 11);
	snake_add(2, 25, 11);
	snake_add(2, 26, 11);
	snake_add(2, 27, 11);
}

// return != 0 when stop key is stop_pressed
uint8_t stop_pressed() {
	cia1.pra = 0x7f;
	if (cia1.prb & 0x80)
		return 0;
	else
		return 1;
}

#define JOY_UP      0x01
#define JOY_DOWN    0x02
#define JOY_LEFT    0x04
#define JOY_RIGHT   0x08
#define JOY_FIRE    0x10

void snake_control(uint8_t s) {
	if (s == 1) {
		uint8_t joy = ~cia1.pra;		// joystick 2
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
	if (s == 2) {
		uint8_t joy = ~cia1.prb;		// joystick 1
		if ((joy & JOY_LEFT) && snake2.direction != SDIR_RIGHT)
			snake2.direction = SDIR_LEFT;
		if ((joy & JOY_RIGHT) && snake2.direction != SDIR_LEFT)
			snake2.direction = SDIR_RIGHT;
		if ((joy & JOY_UP) && snake2.direction != SDIR_DOWN)
			snake2.direction = SDIR_UP;
		if ((joy & JOY_DOWN) && snake2.direction != SDIR_UP)
			snake2.direction = SDIR_DOWN;
//		if (!(joy & JOY_FIRE))
//			fire();
		return;
	}
}

// = 0 if the direction is not available (body of snake, obstacle, hazard ...), 1 = available, 2 = forced (food)
#define SDIR_BLOCKED	0
#define SDIR_AVAILABLE	1
#define SDIR_FORCED		2

// bonus score for keeping the current direction, reduces movement direction jitter
#define SDIR_STICKINESS	3

uint8_t snake_dir_available[4];
int snake_dir_score[4];

uint8_t abs8(int8_t v) {
	if (v >= 0)
		return (uint8_t) v;
	else
		return (uint8_t) -v;
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
		if (i == SDIR_OPPOSITE[hd]) {						// cannot reverse 180°
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
			uint8_t empty = 0, hazard = 0, food = 0, empty_ahead = 0;
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
			// count the number of empty, food and hazardous tiles in the 5x5 area in the direction of interest
			for (int8_t x = -2; x <= +2; x++) {
				for (int8_t y = -2; y <= +2; y++) {
					cx = hx + ddx[i] - x;
					if (cx < 0)
						cx = 0;
					if (cx > 39)
						cx = 39;
					cy = hy + ddy[i] - y;
					if (cy < 0)
						cy = 0;
					if (cy > 23)
						cy = 23;
					uint8_t c = gfx_scr_get_xy((uint8_t) cx, (uint8_t) cy);
					if (c == TILE_EMPTY)
						empty++;
					if (c == TILE_FOOD) {
						// the significance of food decreases with distance
						uint8_t d = abs8(x) + abs8(y);
						food += 6 - d;
					}
					if (c == TILE_HAZARD) {
						// the significance of a hazard decreases with distance
						uint8_t d = abs8(x) + abs8(y);
						hazard += 6 - d;
					}
				}
			}
			int score = empty + food - hazard + (rng_next() & 0x03) + 2 * empty_ahead;
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
#define FOOD_DURATION		10

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
	for (uint8_t i = 0; i < FOOD_MAX; i++) {
		if (food[i].active == FOOD_INACTIVE) {
			// food inactive -> spawn
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

// ############################################################### events

#define EVENT_N	SPR_N		// = number of simultaneous sprites

enum EventType {
	HEART
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
	uint8_t ndx = 0;
	while (event[ndx].active) {
		ndx++;
		if (ndx == 8)
			return;
	}
	switch (t) {
		case HEART:
			event[ndx].active = 1;
			event[ndx].type = HEART;
			uint8_t rng64 = (rng_next() & 0x3f);
			event[ndx].ypos = SPR_OFFSET_Y + 8 + (rng64 << 1) + (rng64 >> 1);
			if (rng_next() & 1) {
				event[ndx].xpos = 0;
				event[ndx].xdir = 1;
			} else {
				event[ndx].xpos = 320 + SPR_OFFSET_X;
				event[ndx].xdir = 0;
			}
			event[ndx].animate_counter = 0;
			event[ndx].animate_state = 0;
			break;
	}
}

const uint8_t heart_animate[] = {3, 4, 5, 4, 3};

// process all events including display updates, call once per frame
void event_process() {
	for (uint8_t i = 0; i < EVENT_N; i++) {
		if (event[i].active) {
			switch (event[i].type) {
				case HEART:
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
						event[i].animate_counter++;
						if (event[i].animate_counter >= 3) {
							event[i].animate_counter = 0;
							event[i].animate_state++;
							if (event[i].animate_state >= 5)
								event[i].animate_state = 0;
						}
						// check collision with snake head -> consume and disable event
						uint8_t xc = (uint8_t) ((event[i].xpos - SPR_OFFSET_X + 12) >> 3);
						uint8_t yc = (event[i].ypos - SPR_OFFSET_Y + 10) >> 3;
						if (gfx_scr_get_xy(xc, yc) == SP_HEAD) {
							uint8_t clr = gfx_clr_get_xy(xc, yc);
							if (clr == S1_COLOR) {
								snake_inc_score(1, 5);
								update_score = 1;
								snd_play_eat();
								event[i].active = 0;
							}
							if (clr == S2_COLOR) {
								snake_inc_score(2, 5);
								update_score = 1;
								snd_play_eat();
								event[i].active = 0;
							}
						}
						if (event[i].active) {
							spr_image(i, 48 + heart_animate[event[i].animate_state]);
							spr_show(i, 1);
							spr_color(i, C64_PURPLE);
							spr_move(i, event[i].xpos, event[i].ypos);
						} else {
							spr_show(i, 0);
						}
					} else {
						spr_show(i, 0);
					}
					break;
			}
		}
	}
}

// ############################################################### game core routines

void game_hazard_map(uint8_t config) {
	switch(config & 0x03) {
		case 0:
			// no obstacles
			break;
		case 1:
			// four horizontal obstacles
			for (uint8_t i = 0; i <= 10; i++) {
				gfx_draw_hazard(5 + i, 5);
				gfx_draw_hazard(24 + i, 5);
				gfx_draw_hazard(5 + i, 16);
				gfx_draw_hazard(24 + i, 16);
			}
			break;
		case 2:
			// four crosses
			for (uint8_t i = 0; i <= 7; i++) {
				gfx_draw_hazard(8 - 3 + i, 5);
				gfx_draw_hazard(8 - 3 + i, 18);
				gfx_draw_hazard(30 - 3 + i, 5);
				gfx_draw_hazard(30 - 3 + i, 18);
			}
			for (uint8_t i = 0; i <= 6; i++) {
				gfx_draw_hazard(8, 6 - 3 + i);
				gfx_draw_hazard(31, 6 - 3 + i);
				gfx_draw_hazard(8, 17 - 3 + i);
				gfx_draw_hazard(31, 17 - 3 + i);
			}
			break;
		case 3:
			// four blocks
			for (uint8_t x = 0; x <= 7; x++) {
				for (uint8_t y = 0; y <= 7; y++) {
					gfx_draw_hazard(8 - 3 + x, 6 - 3 + y);
					gfx_draw_hazard(8 - 3 + x, 17 - 3 + y);
					gfx_draw_hazard(31 - 3 + x, 6 - 3 + y);
					gfx_draw_hazard(31 - 3 + x, 17 - 3 + y);
				}
			}
			break;
		default:
			break;
	}
}

#define ADVANCE_TICKS		6		// number of frames between snake advances, must be > 2
#define COMPUTER_TICKS		3		// number of frames between computer moves, must be > 2
#define FOOD_TICKS			50		// number of frames between food checks
#define LEVEL_TIMER_TICKS	50		// number of frames between level timer ticks (e.g. 50)

#define PLAYER_VS_PLAYER	0		// p v p
#define PLAYER_VS_COMPUTER	1		// p v e

uint8_t game_mode = PLAYER_VS_PLAYER;

const uint8_t level_timer_char[] = {32, 101, 97, 234, 224};

char level_str[] = S"LEVEL ##";

void game_loop(void) {
	uint8_t first_level = 1;		// first level of the game, only reset
	uint8_t level = 0;				// current level (0..63)
	uint8_t	stop = 0;

	while (!stop) {
		// display current level for one second
		gfx_scr_set(32);
		gfx_clr_set(1);
		level_str[6] = ((level + 1) / 10) + 48;
		level_str[7] = ((level + 1) % 10) + 48;
		gfx_print_xy(16, 12, C64_WHITE, level_str);
		for(uint8_t i = 0; i < 50; i++)
			gfx_wait_frame_end();

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
		snake_draw_tail(1);
		snake_draw_head(2);
		snake_draw_body(2);
		snake_draw_tail(2);

		// set up food
		food_init();
		food_check();

		event_init();

		uint8_t advance_counter = 0;
		uint8_t computer_counter = 0;
		uint8_t food_counter = 0;
		uint8_t level_timer_counter = 0;

		uint8_t level_timer1 = 9;			// 9 main ticks, do not change
		uint8_t level_timer2 = 4;			// 4 sub ticks, do not change

		update_score = 1;					// update the score at the beginning of each game loop

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
	//			sta     $d020           	// set border color
				sta     $d021           	// set background color
				lda		#C64_BLACK
				sta		background_color
			}
			event_process();				// update events and their sprites

			computer_counter++;
			advance_counter++;
			food_counter++;
			level_timer_counter++;

			if (advance_counter >= ADVANCE_TICKS) {
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
					// food checks only occur when nothing else happens, it can take a significant amount of time
					if (food_counter >= FOOD_TICKS) {
						food_check();
						food_counter = 0;
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
					if (level_timer1 == 0)
						break;
					else {
						level_timer1--;
						event_add(HEART);
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
		gfx_spr_hide_all();
		gfx_fade_to_black();
		level = (level + 1) & 0x3f;
		// no further levels if both snakes are dead
		if (snake1.status == SNAKE_DEAD && snake2.status == SNAKE_DEAD)
			stop++;
			// break;
	}
}

void game_over() {
	gfx_clr_set(C64_BLACK);
	gfx_scr_set(32);
	gfx_print_xy(15, 11, C64_LIGHT_RED, S"GAME OVER");
	for (uint8_t i = 0; i < 100; i++)
		gfx_wait_frame_end();
}

uint8_t game_menu() {
	gfx_clr_set(C64_BLACK);
	gfx_scr_set(32);
	gfx_draw_snake_logo();
	gfx_print_xy(0, 9, C64_WHITE, S"MENU");
	gfx_print_xy(2, 11, C64_LIGHT_GRAY, S"F1   START GAME");
	gfx_print_xy(2, 13, C64_LIGHT_GRAY, S"F3   CHANGE MODE");
	gfx_print_xy(2, 17, C64_LIGHT_GRAY, S"F5   EXIT");
	gfx_print_xy(0, 20, C64_WHITE, S"LAST SCORES");
	gfx_set_xy(2+0, 22, S1_COLOR, SP_TAIL2);
	gfx_set_xy(2+1, 22, S1_COLOR, SP_TAIL1);
	gfx_set_xy(2+2, 22, S1_COLOR, SP_BODY);
	gfx_set_xy(2+3, 22, S1_COLOR, SP_BODY);
	gfx_set_xy(2+4, 22, S1_COLOR, SP_BODY);
	gfx_set_xy(2+5, 22, S1_COLOR, SP_HEAD);
	gfx_set_xy(2+0, 24, S2_COLOR, SP_TAIL2);
	gfx_set_xy(2+1, 24, S2_COLOR, SP_TAIL1);
	gfx_set_xy(2+2, 24, S2_COLOR, SP_BODY);
	gfx_set_xy(2+3, 24, S2_COLOR, SP_BODY);
	gfx_set_xy(2+4, 24, S2_COLOR, SP_BODY);
	gfx_set_xy(2+5, 24, S2_COLOR, SP_HEAD);
	gfx_set_xy(14, 22, S1_COLOR, snake1.score[3] + 48);
	gfx_set_xy(15, 22, S1_COLOR, snake1.score[2] + 48);
	gfx_set_xy(16, 22, S1_COLOR, snake1.score[1] + 48);
	gfx_set_xy(17, 22, S1_COLOR, snake1.score[0] + 48);
	gfx_set_xy(14, 24, S2_COLOR, snake2.score[3] + 48);
	gfx_set_xy(15, 24, S2_COLOR, snake2.score[2] + 48);
	gfx_set_xy(16, 24, S2_COLOR, snake2.score[1] + 48);
	gfx_set_xy(17, 24, S2_COLOR, snake2.score[0] + 48);

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

int main(void) {
	rng_init();
	gfx_init();
	snd_init();
	snake_init(1);	// just to initialize the score to 0 for menu()
	while(1) {
		if (!game_menu())
			break;
		game_loop();
		game_over();
	}
	snd_stop_all();
	gfx_exit();
	return 0;
}
