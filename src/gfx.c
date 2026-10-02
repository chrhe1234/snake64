#include <stdint.h>
#include <c64/sprites.h>

#include "snake.h"
#include "gfx.h"

#include "snd.h"
#include "sprites.h"
#include "utils.h"

#define scrRAMaddr	0x0400
#define clrRAMaddr	0xd800

#define scrRAM		((uint8_t*) scrRAMaddr)
#define clrRAM		((uint8_t*) clrRAMaddr)

// ############################################################### screen and color RAM line offset

// screen RAM row address lookup table, low byte
uint8_t scr_row_low[25] = {
	(scrRAMaddr +  0 * 40) & 0xff,
	(scrRAMaddr +  1 * 40) & 0xff,
	(scrRAMaddr +  2 * 40) & 0xff,
	(scrRAMaddr +  3 * 40) & 0xff,
	(scrRAMaddr +  4 * 40) & 0xff,
	(scrRAMaddr +  5 * 40) & 0xff,
	(scrRAMaddr +  6 * 40) & 0xff,
	(scrRAMaddr +  7 * 40) & 0xff,
	(scrRAMaddr +  8 * 40) & 0xff,
	(scrRAMaddr +  9 * 40) & 0xff,
	(scrRAMaddr + 10 * 40) & 0xff,
	(scrRAMaddr + 11 * 40) & 0xff,
	(scrRAMaddr + 12 * 40) & 0xff,
	(scrRAMaddr + 13 * 40) & 0xff,
	(scrRAMaddr + 14 * 40) & 0xff,
	(scrRAMaddr + 15 * 40) & 0xff,
	(scrRAMaddr + 16 * 40) & 0xff,
	(scrRAMaddr + 17 * 40) & 0xff,
	(scrRAMaddr + 18 * 40) & 0xff,
	(scrRAMaddr + 19 * 40) & 0xff,
	(scrRAMaddr + 20 * 40) & 0xff,
	(scrRAMaddr + 21 * 40) & 0xff,
	(scrRAMaddr + 22 * 40) & 0xff,
	(scrRAMaddr + 23 * 40) & 0xff,
	(scrRAMaddr + 24 * 40) & 0xff
};

// screen RAM row address lookup table, high byte
uint8_t scr_row_high[25] = {
	(scrRAMaddr +  0 * 40) >> 8,
	(scrRAMaddr +  1 * 40) >> 8,
	(scrRAMaddr +  2 * 40) >> 8,
	(scrRAMaddr +  3 * 40) >> 8,
	(scrRAMaddr +  4 * 40) >> 8,
	(scrRAMaddr +  5 * 40) >> 8,
	(scrRAMaddr +  6 * 40) >> 8,
	(scrRAMaddr +  7 * 40) >> 8,
	(scrRAMaddr +  8 * 40) >> 8,
	(scrRAMaddr +  9 * 40) >> 8,
	(scrRAMaddr + 10 * 40) >> 8,
	(scrRAMaddr + 11 * 40) >> 8,
	(scrRAMaddr + 12 * 40) >> 8,
	(scrRAMaddr + 13 * 40) >> 8,
	(scrRAMaddr + 14 * 40) >> 8,
	(scrRAMaddr + 15 * 40) >> 8,
	(scrRAMaddr + 16 * 40) >> 8,
	(scrRAMaddr + 17 * 40) >> 8,
	(scrRAMaddr + 18 * 40) >> 8,
	(scrRAMaddr + 19 * 40) >> 8,
	(scrRAMaddr + 20 * 40) >> 8,
	(scrRAMaddr + 21 * 40) >> 8,
	(scrRAMaddr + 22 * 40) >> 8,
	(scrRAMaddr + 23 * 40) >> 8,
	(scrRAMaddr + 24 * 40) >> 8
};

// color RAM row address lookup table, low byte
uint8_t clr_row_low[25] = {
	(clrRAMaddr +  0 * 40) & 0xff,
	(clrRAMaddr +  1 * 40) & 0xff,
	(clrRAMaddr +  2 * 40) & 0xff,
	(clrRAMaddr +  3 * 40) & 0xff,
	(clrRAMaddr +  4 * 40) & 0xff,
	(clrRAMaddr +  5 * 40) & 0xff,
	(clrRAMaddr +  6 * 40) & 0xff,
	(clrRAMaddr +  7 * 40) & 0xff,
	(clrRAMaddr +  8 * 40) & 0xff,
	(clrRAMaddr +  9 * 40) & 0xff,
	(clrRAMaddr + 10 * 40) & 0xff,
	(clrRAMaddr + 11 * 40) & 0xff,
	(clrRAMaddr + 12 * 40) & 0xff,
	(clrRAMaddr + 13 * 40) & 0xff,
	(clrRAMaddr + 14 * 40) & 0xff,
	(clrRAMaddr + 15 * 40) & 0xff,
	(clrRAMaddr + 16 * 40) & 0xff,
	(clrRAMaddr + 17 * 40) & 0xff,
	(clrRAMaddr + 18 * 40) & 0xff,
	(clrRAMaddr + 19 * 40) & 0xff,
	(clrRAMaddr + 20 * 40) & 0xff,
	(clrRAMaddr + 21 * 40) & 0xff,
	(clrRAMaddr + 22 * 40) & 0xff,
	(clrRAMaddr + 23 * 40) & 0xff,
	(clrRAMaddr + 24 * 40) & 0xff
};

// color RAM row address lookup table, high byte
uint8_t clr_row_high[25] = {
	(clrRAMaddr +  0 * 40) >> 8,
	(clrRAMaddr +  1 * 40) >> 8,
	(clrRAMaddr +  2 * 40) >> 8,
	(clrRAMaddr +  3 * 40) >> 8,
	(clrRAMaddr +  4 * 40) >> 8,
	(clrRAMaddr +  5 * 40) >> 8,
	(clrRAMaddr +  6 * 40) >> 8,
	(clrRAMaddr +  7 * 40) >> 8,
	(clrRAMaddr +  8 * 40) >> 8,
	(clrRAMaddr +  9 * 40) >> 8,
	(clrRAMaddr + 10 * 40) >> 8,
	(clrRAMaddr + 11 * 40) >> 8,
	(clrRAMaddr + 12 * 40) >> 8,
	(clrRAMaddr + 13 * 40) >> 8,
	(clrRAMaddr + 14 * 40) >> 8,
	(clrRAMaddr + 15 * 40) >> 8,
	(clrRAMaddr + 16 * 40) >> 8,
	(clrRAMaddr + 17 * 40) >> 8,
	(clrRAMaddr + 18 * 40) >> 8,
	(clrRAMaddr + 19 * 40) >> 8,
	(clrRAMaddr + 20 * 40) >> 8,
	(clrRAMaddr + 21 * 40) >> 8,
	(clrRAMaddr + 22 * 40) >> 8,
	(clrRAMaddr + 23 * 40) >> 8,
	(clrRAMaddr + 24 * 40) >> 8
};

// ############################################################### initialize and reset

void gfx_spr_init() {
	spr_init((char*) 0x0400);
	for (uint8_t i = 0; i < SPR_N; i++)
		spr_set(i, 0, 0, 0, 48, 0, 0, 0, 0);
}

uint8_t gfx_old_border = 0;
uint8_t gfx_old_background = 0;
uint8_t gfx_old_d018 = 0;

// initialize graphics
void gfx_init() {
	__asm {
		lda     $d020           // save old border color and set to black
		sta     gfx_old_border
		lda     #0
		sta     $d020

		lda     $d021           // save old background color and set to black
		sta     gfx_old_background
		lda     #0
		sta     $d021

		lda		$d018			// save old config
		sta		gfx_old_d018
		lda 	#$1e			// set scr RAM address to 0x0400 and charset address to 0x3800
		sta 	$d018

		sei						// copy character ROM to 0x3800 before patching it
		lda 	$01
		pha
		and		#$fb        	// enable access to character ROM -> CHAREN = 0
		sta 	$01
		ldx 	#0
	_loop:
		lda 	$d000,x
		sta 	$3800,x
		lda 	$d100,x
		sta 	$3900,x
		lda 	$d200,x
		sta 	$3a00,x
		lda 	$d300,x
		sta 	$3b00,x
		lda 	$d400,x
		sta 	$3c00,x
		lda 	$d500,x
		sta 	$3d00,x
		lda 	$d600,x
		sta 	$3e00,x
		lda 	$d700,x
		sta 	$3f00,x
		inx
		bne		_loop
		pla						// restore memory configuration
		sta $01
		cli

		// set character 94 to $00 $00 $18 $3c $3c $18 $00 $00
		lda		#$00
		sta		$3800 + 94 * 8 + 0
		sta		$3800 + 94 * 8 + 1
		sta		$3800 + 94 * 8 + 6
		sta		$3800 + 94 * 8 + 7
		lda		#$18
		sta		$3800 + 94 * 8 + 2
		sta		$3800 + 94 * 8 + 5
		lda		#$3c
		sta		$3800 + 94 * 8 + 3
		sta		$3800 + 94 * 8 + 4

		// set character 28 to $00 $00 $00 $18 $18 $00 $00 $00
		lda		#$00
		sta		$3800 + 28 * 8 + 0
		sta		$3800 + 28 * 8 + 1
		sta		$3800 + 28 * 8 + 6
		sta		$3800 + 28 * 8 + 7
		sta		$3800 + 28 * 8 + 2
		sta		$3800 + 28 * 8 + 5
		lda		#$18
		sta		$3800 + 28 * 8 + 3
		sta		$3800 + 28 * 8 + 4

		// set character 39 to $3c $7e $ff $ff $ff $ff $7e $3c
		lda		#$3c
		sta		$3800 + 39 * 8 + 0
		sta		$3800 + 39 * 8 + 7
		lda		#$7e
		sta		$3800 + 39 * 8 + 1
		sta		$3800 + 39 * 8 + 6
		lda		#$ff
		sta		$3800 + 39 * 8 + 2
		sta		$3800 + 39 * 8 + 3
		sta		$3800 + 39 * 8 + 4
		sta		$3800 + 39 * 8 + 5

		// set character 128 to 0xff 0x81 0xbd 0xa5 0xa5 0xbd 0x81 0xff
		lda		#$ff
		sta		$3800 + 128 * 8 + 0
		sta		$3800 + 128 * 8 + 7
		lda		#$81
		sta		$3800 + 128 * 8 + 1
		sta		$3800 + 128 * 8 + 6
		lda		#$bd
		sta		$3800 + 128 * 8 + 2
		sta		$3800 + 128 * 8 + 5
		lda		#$a5
		sta		$3800 + 128 * 8 + 3
		sta		$3800 + 128 * 8 + 4

		// set character 129 to 0xff 0x81 ... 0x81 0xff
		lda		#$ff
		sta		$3800 + 129 * 8 + 0
		sta		$3800 + 129 * 8 + 7
		lda		#$81
		sta		$3800 + 129 * 8 + 1
		sta		$3800 + 129 * 8 + 6
		sta		$3800 + 129 * 8 + 2
		sta		$3800 + 129 * 8 + 5
		sta		$3800 + 129 * 8 + 3
		sta		$3800 + 129 * 8 + 4
	}
	gfx_scr_set(0x20);
	gfx_clr_set(0x01);
	gfx_spr_init();
}

// ###############################################################

// set screen RAM
void gfx_scr_set(uint8_t value) {
	__asm {
		lda value
		ldx #$00
	loop:
		sta $0400,x
		sta $0500,x
		sta $0600,x
		sta $06e8,x
		inx
		bne loop
	}
}

// set color RAM
void gfx_clr_set(uint8_t value) {
	__asm {
		lda value
		ldx #$00
	loop:
		sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $dae8,x
		inx
		bne loop
	}
}

// set screen RAM char at cx, cy to ca
void gfx_scr_set_xy(uint8_t cx, uint8_t cy, uint8_t ca) {
	__asm {
		ldy     cy
		lda		scr_row_low,y
		sta		_store+1
		lda		scr_row_high,y
		sta		_store+2
		lda		ca
		ldx     cx
	_store:
		sta		$ffff,x				// modified to actual screen address
	}
}

// get screen RAM char at cx, cy
uint8_t gfx_scr_get_xy(uint8_t cx, uint8_t cy) {
	__asm {
		ldy     cy
		lda		scr_row_low,y
		sta		_store+1
		lda		scr_row_high,y
		sta		_store+2
		ldx     cx
	_store:
		lda		$ffff,x				// modified to actual screen address
		sta		accu
		lda		#0
		sta		accu+1
	}
}

// set color RAM char at cx, cy to ca
void gfx_clr_set_xy(uint8_t cx, uint8_t cy, uint8_t ca) {
	__asm {
		ldy     cy
		lda		clr_row_low,y
		sta		_store+1
		lda		clr_row_high,y
		sta		_store+2
		lda		ca
		ldx     cx
	_store:
		sta		$ffff,x				// modified to actual screen address
    }
}

// get color RAM char at cx, cy
uint8_t gfx_clr_get_xy(uint8_t cx, uint8_t cy) {
	__asm {
		ldy     cy
		lda		clr_row_low,y
		sta		_store+1
		lda		clr_row_high,y
		sta		_store+2
		ldx     cx
	_store:
		lda		$ffff,x				// modified to actual screen address
		and		#$0f
		sta		accu
		lda		#0
		sta		accu+1
	}
}

// set screen x,y to color and chr
void gfx_set_xy(uint8_t cx, uint8_t cy, uint8_t color, uint8_t chr) {
	__asm {
		ldy     cy
		lda		scr_row_low,y
		sta		_store1+1
		lda		scr_row_high,y
		sta		_store1+2
		lda		chr
		ldx     cx
	_store1:
		sta		$ffff,x				// modified to actual screen buffer address

		ldy     cy
		lda		clr_row_low,y
		sta		_store2+1
		lda		clr_row_high,y
		sta		_store2+2
		lda		color
		ldx     cx
	_store2:
		sta		$ffff,x				// modified to actual color buffer address
    }
}

// print a null-terminated string (screen code) at cx, cy in the given color
void gfx_print_xy(uint8_t cx, uint8_t cy, uint8_t color, const char *str) {
	while (*str) {
		gfx_set_xy(cx, cy, color, (uint8_t) *str);
		cx++;
		str++;
      }
}

// hide all sprites
void gfx_spr_hide_all() {
	vic.spr_enable = 0x00;
}


// reset graphics
void gfx_exit() {
	gfx_spr_hide_all();
	__asm {
		lda		gfx_old_d018			// restore character and screen addresses
		sta 	$d018

		lda     gfx_old_border          // restore border color
		sta     $d020

		lda     gfx_old_background      // restore background color
		sta     $d021

		lda		#147					// clear screen
		jsr		chrout
	}
}

#define FRAME_COLOR		C64_LIGHT_RED

// set up game screen
void gfx_setup_game_screen() {
	// clear all
	gfx_scr_set(32);
	gfx_clr_set(1);

	// draw frame
	gfx_scr_set_xy(0, 0, 85);
	gfx_clr_set_xy(0, 0, FRAME_COLOR);
	gfx_scr_set_xy(39, 0, 73);
	gfx_clr_set_xy(39, 0, FRAME_COLOR);
	gfx_scr_set_xy(0, 23, 74);
	gfx_clr_set_xy(0, 23, FRAME_COLOR);
	gfx_scr_set_xy(39, 23, 75);
	gfx_clr_set_xy(39, 23, FRAME_COLOR);
	for(uint8_t i = 1; i < 23; i++) {
		gfx_scr_set_xy(0, i, 66);
		gfx_scr_set_xy(39, i, 66);
		gfx_clr_set_xy(0, i, FRAME_COLOR);
		gfx_clr_set_xy(39, i, FRAME_COLOR);
	}
	for(uint8_t i = 1; i < 39; i++) {
		gfx_scr_set_xy(i, 0, 67);
		gfx_scr_set_xy(i, 23, 67);
		gfx_clr_set_xy(i, 0, FRAME_COLOR);
		gfx_clr_set_xy(i, 23, FRAME_COLOR);
	}

	// set color for score of snake 1 + 2
	for(uint8_t i = 0; i < 4; i++) {
		gfx_clr_set_xy(1 + i, 24, S1_COLOR);
		gfx_clr_set_xy(35 + i, 24, S2_COLOR);
	}

	// set up timer indicator
	gfx_print_xy(10, 24, C64_WHITE, S"TIME");
	gfx_set_xy(14, 24, C64_WHITE, 118);
	for (uint8_t i = 15; i <= 24; i++) {
		gfx_set_xy(i, 24, C64_LIGHT_GRAY, 224);
	}
}

// draw/put food on the playing field
void gfx_draw_food(uint8_t x, uint8_t y) {
	gfx_set_xy(x, y, C64_PURPLE, TILE_FOOD);
}

// draw/put hazard on the playing field
void gfx_draw_hazard(uint8_t x, uint8_t y) {
	gfx_set_xy(x, y, C64_LIGHT_RED, TILE_HAZARD);
}

// wait for scan line 250, end of frame
void gfx_wait_frame_end() {
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

uint8_t fade_colors[6] = {C64_LIGHT_GRAY, C64_WHITE, C64_LIGHT_GRAY, C64_GRAY, C64_DARK_GRAY, C64_BLACK};

void gfx_fade_to_black() {
	gfx_wait_frame_end(); snd_update();
	for (uint8_t i = 0; i < 6; i++) {
		gfx_clr_set(fade_colors[i]);
		for (uint8_t j = 0; j < 4; j++) {
			gfx_wait_frame_end();
			snd_update();
		}
	}
}

#define SPBD	SP_BODY
#define SPHD	SP_HEAD
#define SPT1	SP_TAIL1
#define SPT2	SP_TAIL2

const uint8_t logo_scr[] = {
	  32, SPBD, SPBD, SPBD,   32,   32, SPBD,   32,   32,   32, SPHD,   32,   32, SPBD, SPBD, SPBD,   32,   32, SPHD,   32,   32,   32, SPT2,   32, SPBD, SPBD, SPBD, SPHD,   32,   32, SPBD, SPBD, SPBD,   32,   32,   32,   32,   32, SPBD,   32,
	SPBD,   32,   32,   32, SPHD,   32, SPBD, SPBD,   32,   32, SPBD,   32, SPBD,   32,   32,   32, SPBD,   32, SPBD,   32,   32, SPT1,   32,   32, SPBD,   32,   32,   32,   32, SPBD,   32,   32,   32, SPHD,   32,   32,   32, SPBD, SPBD,   32,
	SPBD,   32,   32,   32,   32,   32, SPBD, SPBD,   32,   32, SPBD,   32, SPBD,   32,   32,   32, SPBD,   32, SPBD,   32, SPBD,   32,   32,   32, SPBD,   32,   32,   32,   32, SPBD,   32,   32,   32,   32,   32,   32, SPBD,   32, SPBD,   32,
	  32, SPBD, SPBD, SPBD,   32,   32, SPBD,   32, SPBD,   32, SPBD,   32, SPBD, SPBD, SPBD, SPBD, SPBD,   32, SPBD, SPBD,   32,   32,   32,   32, SPBD, SPBD, SPBD, SPHD,   32, SPBD, SPT2, SPT1, SPBD,   32,   32, SPBD,   32,   32, SPBD,   32,
	  32,   32,   32,   32, SPBD,   32, SPBD,   32,   32, SPBD, SPBD,   32, SPBD,   32,   32,   32, SPBD,   32, SPBD,   32, SPBD,   32,   32,   32, SPBD,   32,   32,   32,   32, SPBD,   32,   32,   32, SPBD,   32, SPBD, SPBD, SPBD, SPBD, SPHD,
	SPT2,   32,   32,   32, SPBD,   32, SPT1,   32,   32, SPBD, SPBD,   32, SPT1,   32,   32,   32, SPBD,   32, SPT1,   32,   32, SPBD,   32,   32, SPBD,   32,   32,   32,   32, SPBD,   32,   32,   32, SPBD,   32,   32,   32,   32, SPT1,   32,
	  32, SPT1, SPBD, SPBD,   32,   32, SPT2,   32,   32,   32, SPBD,   32, SPT2,   32,   32,   32, SPHD,   32, SPT2,   32,   32,   32, SPHD,   32, SPBD, SPBD, SPT1, SPT2,   32,   32, SPBD, SPBD, SPBD,   32,   32,   32,   32,   32, SPT2,   32
};

const uint8_t logo_clr[] = {
/*	colors are the same throughout the column, could be changed later though
	0x00, 0x0d, 0x0d, 0x0d, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x07, 0x07, 0x07, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x03, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x00,
	0x0d, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x03, 0x03, 0x00, 0x00, 0x03, 0x00, 0x07, 0x00, 0x00, 0x00, 0x07, 0x00, 0x05, 0x00, 0x00, 0x05, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x0a, 0x0a, 0x00,
	0x0d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x00, 0x00, 0x03, 0x00, 0x07, 0x00, 0x00, 0x00, 0x07, 0x00, 0x05, 0x00, 0x05, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x0a, 0x00,
	0x00, 0x0d, 0x0d, 0x0d, 0x00, 0x00, 0x03, 0x00, 0x03, 0x00, 0x03, 0x00, 0x07, 0x07, 0x07, 0x07, 0x07, 0x00, 0x05, 0x05, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x00, 0x03, 0x03, 0x03, 0x03, 0x00, 0x00, 0x0a, 0x00, 0x00, 0x0a, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x03, 0x00, 0x00, 0x03, 0x03, 0x00, 0x07, 0x00, 0x00, 0x00, 0x07, 0x00, 0x05, 0x00, 0x05, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
	0x0d, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x03, 0x00, 0x00, 0x03, 0x03, 0x00, 0x07, 0x00, 0x00, 0x00, 0x07, 0x00, 0x05, 0x00, 0x00, 0x05, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x00,
	0x00, 0x0d, 0x0d, 0x0d, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x07, 0x00, 0x00, 0x00, 0x07, 0x00, 0x05, 0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x03, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x00
*/
	0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x00, 0x03, 0x03, 0x03, 0x03, 0x03, 0x00, 0x07, 0x07, 0x07, 0x07, 0x07, 0x00, 0x05, 0x05, 0x05, 0x05, 0x05, 0x00, 0x01, 0x01, 0x01, 0x01, 0x00, 0x03, 0x03, 0x03, 0x03, 0x03, 0x00, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a
};

void gfx_draw_snake_logo() {
	int ndx = 0;
	for (uint8_t y = 0; y < 7; y++) {
		for (uint8_t x = 0; x < 40; x++) {
//			gfx_set_xy(x, y, logo_clr[ndx], logo_scr[ndx]);
			gfx_set_xy(x, y, logo_clr[x], logo_scr[ndx]);
			ndx++;
		}
	}
}

void gfx_update_score() {
	__asm {
		lda		snake1+SNAKE_SCORE_OFF+3
		clc
		adc		#48
		sta		scrRAMaddr+24*40+1

		lda		snake1+SNAKE_SCORE_OFF+2
		clc
		adc		#48
		sta		scrRAMaddr+24*40+2

		lda		snake1+SNAKE_SCORE_OFF+1
		clc
		adc		#48
		sta		scrRAMaddr+24*40+3

		lda		snake1+SNAKE_SCORE_OFF+0
		clc
		adc		#48
		sta		scrRAMaddr+24*40+4

		lda		snake2+SNAKE_SCORE_OFF+3
		clc
		adc		#48
		sta		scrRAMaddr+24*40+35

		lda		snake2+SNAKE_SCORE_OFF+2
		clc
		adc		#48
		sta		scrRAMaddr+24*40+36

		lda		snake2+SNAKE_SCORE_OFF+1
		clc
		adc		#48
		sta		scrRAMaddr+24*40+37

		lda		snake2+SNAKE_SCORE_OFF+0
		clc
		adc		#48
		sta		scrRAMaddr+24*40+38
	}
}