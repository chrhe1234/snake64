#ifndef	_SPRITES_H_
#define	_SPRITES_H_

#include <stdint.h>

#define SPR_OFFSET_X	24
#define SPR_OFFSET_Y	50
#define SPR_N			8

extern volatile uint8_t sprite_data[15][64];

#endif
