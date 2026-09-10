#include "snd.h"
#include <stdint.h>

typedef struct {
    uint8_t ctrl;        // control value without gate
    uint8_t frames;      // remaining gate-on frames
} SoundState;

static SoundState snd_state[SID_NUM_VOICES];

void snd_stop_all(void) {
    uint8_t i;
    for (i = 0; i < SID_NUM_VOICES; ++i) {
        sid.voices[i].ctrl = 0;
        snd_state[i].ctrl = 0;
        snd_state[i].frames = 0;
    }
}

void snd_init(void) {
    snd_stop_all();
    sid.ffreq = 0;
    sid.resfilt = 0;
    sid.fmodevol = SID_VOLUME_MAX;	    // no filter, maximum master volume
}

void snd_play(uint8_t channel, const Sound *s) {
    uint8_t ctrl;
    if (channel >= SID_NUM_VOICES)
        return;
    ctrl = s->ctrl & ~SID_CTRL_GATE;

	sid.voices[channel].ctrl = ctrl;	// gate off first, allowing the envelope to be retriggered 

    sid.voices[channel].freq = s->freq;
    sid.voices[channel].pwm = s->pwm;
    sid.voices[channel].attdec = s->attdec;
    sid.voices[channel].susrel = s->susrel;

    snd_state[channel].ctrl = ctrl;
    snd_state[channel].frames = s->duration;

    sid.voices[channel].ctrl = ctrl | SID_CTRL_GATE;	    // enable gate
}

// count down frame counters and disable sounds when required
void snd_update(void) {
    for (uint8_t i = 0; i < SID_NUM_VOICES; i++) {
        if (snd_state[i].frames) {
            snd_state[i].frames--;
            if (!snd_state[i].frames) {
                // gate off, SID performs the release phase
                sid.voices[i].ctrl = snd_state[i].ctrl;
            }
        }
    }
}

// sound for snake smashing into a wall and obstacle
const Sound sound_smash = {
    .freq     = 0x0800,
    .pwm      = 0x0000,
    .ctrl     = SID_CTRL_NOISE,
    .attdec   = 0x09,
    .susrel   = 0x09,
    .duration = 15
};

// a bouncing sound
const Sound sound_bounce = {
    .freq     = 0x0900,
    .pwm      = 0x0500,
    .ctrl     = SID_CTRL_RECT,
    .attdec   = 0x07,
    .susrel   = 0x27,
    .duration = 12
};

// sound for timer blips
const Sound sound_blip = {
    .freq     = 0x2000,
    .pwm      = 0x0000,
    .ctrl     = SID_CTRL_TRI,
    .attdec   = 0x02,
    .susrel   = 0x00,
    .duration = 5
};

// maybe useful as a death sound
const Sound sound_death = {
    .freq     = 0x1400,
    .pwm      = 0x0000,
    .ctrl     = SID_CTRL_NOISE,
    .attdec   = 0x1a,
    .susrel   = 0x0a,
    .duration = 20
};

const Sound sound_gulp = {
    .freq     = 0x0f00,
    .pwm      = 0x0000,
    .ctrl     = SID_CTRL_TRI,
    .attdec   = 0x28,
    .susrel   = 0x01,
    .duration = 20
};

#define VIC_RASTER (*(volatile uint8_t *)0xd012)

void wait_frame(void) {
    while (VIC_RASTER != 250)
        ;
    while (VIC_RASTER == 250)
        ;
}

void snd_test() {
	snd_init();
	snd_play(0, &sound_blip);
	for (uint8_t i = 0; i < 100; i++) {
		wait_frame();
		snd_update();
	}
	snd_play(1, &sound_gulp);
	for (uint8_t i = 0; i < 100; i++) {
		wait_frame();
		snd_update();
	}
	snd_play(1, &sound_death);
	for (uint8_t i = 0; i < 100; i++) {
		wait_frame();
		snd_update();
	}
	snd_stop_all();
}

