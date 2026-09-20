# Snake64 - working notes

Snapshot of the code review and the random-number work done on 2026-09-17 .. 2026-09-20.
Numbers marked *measured* come from the compiled output (`snake64.asm`, `.map`) or from running the real
bytes of `snake64.prg` in a small 6502 emulator; numbers marked *est.* are hand-derived and were not compiled.
Cycle counts are nominal CPU cycles; VIC DMA and the 60 Hz KERNAL IRQ add time on top.
A PAL frame is about 19,650 cycles, an NTSC frame about 17,100.


## 1. Working conventions for reviews

* Suggest first; change files only when explicitly asked.
* Prefer measured numbers over claims, and say what is measured and what is estimated.
* Predictable (bounded) runtime is preferred over a lower average cost; keep solutions small and simple.
* For visual effects (sprite positions) even coverage matters more than hitting every value.


## 2. Tooling limits and how things were verified

* The review environment had no `git`, `oscar64` or C compiler, so nothing could be built or run.
* Diff against the last commit: read the loose objects in `.git/objects` with zlib and compare with the working tree.
* Compiled output: `snake64.asm` (listing), `snake64.map` / `.lbl` (sizes, addresses).
* Cycle counts: a tiny 6502 emulator (NMOS timings, branch page-cross penalties) running the real bytes of
  `snake64.prg` (`rng_next`, `divmod`, `food_check`, `gfx_scr_get_xy`). The scripts were temporary and are not kept.
* Oscar64 conventions observed:
  * a `uint8_t` result is returned in A; an asm-only function stores it in `accu` ($1b) and the compiler appends
    `lda accu / rts`;
  * `accu` / `accu+1` are free scratch in inline asm;
  * `x % n` always compiles to `jsr divmod+53` (constants are not strength-reduced);
  * `arr[(uint8_t)(i+1)]` may be compiled as `arr+1,x` without wrap-around (see `inc8`/`dec8` in `snake.c`);
    use separate index counters instead.


## 3. Random number generator

### Current implementation

* `rng_next()` in `src/utils.c` (inline asm, measured 49 bytes, 80 cycles, 86 with the `jsr`):
  16-bit counter `rng_state += $359d`, `x = hi ^ lo`, then `x ^= x<<3; x ^= x>>5; x ^= x<<4`.
  Verified against a reference algorithm for all states.
* `rng_init()` seeds the low byte from CIA1 timer A (`$dc04`) and the high byte from the raster line (`$d012`).
* History: the original `5x+1` generator reached only 32 of the 836 food cells; an intermediate 8-bit
  Weyl+scrambler had period 256.

### Known weakness

The first draw is exactly uniform over the full period, but consecutive draws are correlated: food cells come out
uneven (chi2 about 5000 against about 835 for an ideal source; some cells are hit 20 times, others 155, mean 78).
Combining two draws into a 16-bit value therefore does not improve uniformity.

### Range reduction: decision

`%` (Oscar64 `divmod`) is used because its timing is predictable:

| | cycles |
|---|---|
| `x % n` reduction, any n (measured) | 178 .. 194 |
| including the draw (86) | 264 .. 280 |
| `food_check` worst case: 4 slots x 5 tries, all failing (measured) | 12,267 .. 12,320 (fits one frame; 10 tries would not) |

Rejected alternatives (measured on the real generator):

* Capped mask-and-reject: worst case 423 cycles, only cheaper on average (about 180-200).
* Uncapped rejection: no runtime bound.
* Subtraction-loop modulo: fast for n >= 16, but its bound depends on n (11 * floor(255/n) + 6).
* 64-byte lagged-Fibonacci table generator: best statistics, about 78 cycles (est.), +67 bytes; not adopted.
* 16-bit counter with double scramble: chi2 about 2075, about 116 cycles (est.).

Single-byte modulo bias: 7:6 for n = 38, 12:11 for n = 22 (mild). For n > 128 it is always 2:1.
The comment "oscar64 modulo is faster than alternatives" in `food_check` is not accurate:
it is *predictable*, not the fastest option.

### Heart sprite y position (`event_add`)

* Current: `rng64 = rng_next() % 0x3f; ypos = SPR_OFFSET_Y + 8 + (rng64<<1) + (rng64>>1)`
  gives 63 positions, y = 58 .. 213, neighbouring gaps alternating 2 / 3 lines, about 96 % of the playfield
  height reachable.
* Weakness: with `% 63` the four topmost positions (58, 60, 63, 65) are 25 % more likely.
* **Open question:** if `0x3f` was meant as a mask, `& 0x3f` (64 values, maximum y = 215) is exactly flat and
  avoids the divmod call (about 180 cycles cheaper, est.). If 63 positions were intended, nothing needs to change.


## 4. Review findings

### Fixed since the review

* `snake_draw_tail(2)` used `snake1.end` (regression from commit 2130bd1; could write outside the screen tables).
* `gfx_exit` did not restore `$d018`; it is now saved and restored.
* Unsequenced `++event[i].animate` removed.
* `rng_next` asm: missing `eor` operand fixed.
* `rand()` replaced by the custom generator.

### Still open (none urgent)

* `snake_draw_tail` erases cell `end-1` even when the tail did not advance (growth); this can blank food, the head
  or the other snake (rare, needs a tightly coiled snake).
* The keyboard buffer is not flushed before `wait_for_key` in `game_menu`.
* CIA access race in `stop_pressed` / `snake_control` (already on the readme to-do list);
  `gfx_init` ends with an unconditional `cli`.
* Heart animation: `animate >> 2` selects images 51 .. 54 but only three heart sprites exist, so image 54 is blank
  and the heart disappears 25 % of the time (may be intended).
* No collision sound on a plain bump, only in `snake_punish` after `STUCK_TIMEOUT` (4) blocked ticks.
* Hazard map "four blocks" is one tile off-symmetric (x 5-12 vs 28-35, y 3-10 vs 14-21).
* Dead code: `snake_dir_score`, `wait_100ms` (`utils.c`), `snd_test`, `wait_frame`, `snd_play_timer_tick`,
  `snd_play_bounce` (`snd.c`), `#include <stdlib.h>`, non-const `SDIR_OPPOSITE`, `event_add` hardcodes 8
  instead of `EVENT_N`.
* Small text issues: comment above `gfx_draw_hazard` says "food"; typo "savee" in a `gfx.c` comment.
* Stray file `data/..\src\sprites.c` (old generator output, git-ignored because its name starts with a dot).
* Three logo glyphs have colour 0 on a black background (invisible; they come from the original art in `archive/`).
