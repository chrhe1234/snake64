#include "utils.h"

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

static uint16_t rng_state = 0;

void rng_init(void) {
	__asm {
		lda		$dc04			// CIA1 timer A -> low byte
		sta		rng_state
		lda		$d012			// VIC raster line -> high byte
		sta		rng_state+1
	}
}

uint8_t rng_next(void) {
	__asm {
		lda		#0
		sta		accu+1

		lda		rng_state			// add $359d to rng_state
		clc
		adc		#$9d
		sta		rng_state
		lda		rng_state+1
		adc		#$35
		sta		rng_state+1

		eor		rng_state			// scramble ...
		sta		accu
		asl
		asl
		asl
		eor		accu
		sta		accu

		lsr
		lsr
		lsr
		lsr
		lsr
		eor		accu
		sta		accu

		asl
		asl
		asl
		asl
		eor		accu
		sta		accu
	}
}