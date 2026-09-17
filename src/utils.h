#ifndef _UTILS_H_
#define _UTILS_H_

#include <stdint.h>

#define chrout	$ffd2				// chrout ROM address
#define getin	$ffe4				// getin ROM address

uint8_t wait_for_key();

void rng_init(void);

uint8_t rng_next(void);

#endif
