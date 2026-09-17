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

uint8_t rng_state;

void rng_init(void) {
	rng_state = *((volatile uint8_t*) 0xdc04);
}

uint8_t rng_next(void) {
	rng_state = ((rng_state << 2) + rng_state) + 1;
	return rng_state;
}
