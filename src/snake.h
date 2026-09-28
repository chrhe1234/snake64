#ifndef _SNAKE_H_
#define	_SNAKE_H_

#include <stdint.h>

#ifndef STDINT_H
// should not happen but it helps with CLion's syntax checker
typedef signed char int8_t;
typedef short int16_t;
typedef long int32_t;

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long uint32_t;
#endif

#define KEY_F1		133
#define KEY_F3		134
#define KEY_F5		135

typedef struct {
    uint8_t	status;
    uint8_t	direction;				// movement direction
    uint8_t	x[256];					// "ring buffer" of snake position, 0xff -> invalid
    uint8_t	y[256];
    uint8_t	start, end, length;		// index of current start and end, length
    uint8_t	grow;					// number of rounds the snake should keep growing
    uint8_t	stuck;					// number of consecutive blocked advance attempts
    int8_t score[4];				// score in individual digits, int (!), no uint
    uint8_t trail;                  // number of rounds the snake leaves a hazardous trail behind
    uint8_t moved;                  // direction of the last executed step (input is checked against it)
} Snake;

#define SNAKE_SCORE_OFF 519         // offset of score array in Snake struct

extern Snake snake1, snake2;

#endif
