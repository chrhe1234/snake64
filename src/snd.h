#ifndef _SND_H_
#define _SND_H_

#include <stdint.h>
#include <c64/sid.h>

#define SID_VOLUME_MAX  0x0f
#define SID_NUM_VOICES  3

typedef struct {
    uint16_t freq;       // SID frequency value
    uint16_t pwm;        // 12-bit pulse width, e.g. 0x0800 = 50%
    uint8_t ctrl;        // waveform/control bits, WITHOUT SID_CTRL_GATE
    uint8_t attdec;      // attack/decay
    uint8_t susrel;      // sustain/release
    uint8_t duration;    // gate-on duration in frames
} Sound;

// plays default timer tick sound
void snd_play_timer_tick();

// plays timer sound with frequency decreased with increased remaining
void snd_play_timer_tick_n(uint8_t remaining);

// plays final timer (longer) tick sound
void snd_play_final_timer_tick();

void snd_play_collision();

void snd_play_eat();

void snd_play_bounce();

void snd_play_death();

void snd_play_donk();

void snd_init();

void snd_stop_all();

void snd_play(uint8_t channel, const Sound *s);

void snd_update();

void snd_test();

#endif

