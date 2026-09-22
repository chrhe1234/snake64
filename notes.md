# Snake64 - working notes

Snapshot of the code review and the random-number / score work done on 2026-09-17 .. 2026-09-20
(second review pass: 2026-09-20, build of 21:49; third pass: 2026-09-22, covering the new `BARREL`
event/hazardous-trail feature and the event spawn y-position).
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
  Always compare source and build times first: a listing older than the source says nothing about new code.
* Cycle counts and exhaustive checks: a tiny 6502 emulator (NMOS timings, branch page-cross penalties) running the
  real bytes of `snake64.prg` (`rng_next`, `divmod`, `food_check`, `gfx_scr_get_xy`, `snake_inc_score`).
  The scripts were temporary and are not kept.
* Oscar64 conventions observed:
  * a `uint8_t` result is returned in A; an asm-only function stores it in `accu` ($1b) and the compiler appends
    `lda accu / rts`; the first `uint8_t` argument arrives in A;
  * `accu` / `accu+1` are free scratch in inline asm;
  * `x % n` always compiles to `jsr divmod+53` (constants are not strength-reduced);
  * constant arguments are propagated into the callee: `snake_inc_score(s, v)` is compiled with `v == 1`
    hard-wired because every caller passes 1 (the parameter is never read). The function is regenerated
    automatically as soon as a caller passes another value;
  * `arr[(uint8_t)(i+1)]` may be compiled as `arr+1,x` without wrap-around (see `inc8`/`dec8` in `snake.c`);
    use separate index counters instead;
  * `static` variables and bare `asl` / `lsr` work in inline asm; a variable referenced only from asm is kept.


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

Single-byte modulo bias: 7:6 for n = 38, 12:11 for n = 22 (mild). For n > 128 it is always 2:1
(this was the `% 171` heart-y problem). The comment "oscar64 modulo is sufficiently fast" in `food_check`
is fine; `%` is *predictable*, not the fastest option.

### Event sprite y position (`event_add`) - updated 2026-09-22

Now: `row = (rng_next() % 22) + 1; ypos = (row << 3) + SPR_OFFSET_Y + 11`. Reason for the change: the
collision checks in `event_process` reduce `ypos` to a character row via `(ypos - SPR_OFFSET_Y + 10) >> 3`;
with the old formula (below) that reduction's remainder mod 8 was essentially arbitrary, so some spawns
landed close enough to a row boundary that the sprite visually overlapped a snake segment without the
collision registering (reported as "looks like touching but not detected"). The new formula centres `ypos`
in the middle of row `row`: `(row*8 + 21) >> 3` always equals `row + 2` with remainder 21 mod 8 = 5, i.e.
solidly mid-cell for every `row`, so the boundary case cannot occur. It reuses the same `1 + rng_next() % 22`
range and mild bias already accepted for food placement (`food_check`), so no new bias profile is introduced.
Coarser than before (22 rows instead of 64 y-positions), but `ypos` never changes after spawn (events only
move horizontally), so this only reduces spawn-row variety, not motion smoothness.

History (original resolution, superseded by the above): `rng64 = rng_next() & 0x3f;
ypos = SPR_OFFSET_Y + 8 + (rng64<<1) + (rng64>>1)` gave 64 positions, y = 58 .. 215, neighbouring gaps
alternating 2 / 3 lines, exactly flat (4 hits per 256 for every position), no divmod call, about 99 % of the
playfield height reachable by the heart's inked rows. (The earlier `% 0x3f` variant gave the top four
positions 25 % extra weight.)


## 4. Score handling

* `Snake.score` is `int8_t score[4]`, ones digit first (`src/snake.h`); `SNAKE_SCORE_OFF` = 519 is the hand-computed
  byte offset of that array inside the 523-byte struct, used by the asm in `gfx_update_score()`.
* `snake_inc_score(s, v)`: `v` is clamped to 10; a single carry is then always enough; overflow saturates at 9999.
  Verified exhaustively: source semantics for all 10,000 scores x every `v` 0..255 (0 errors), and the compiled
  bytes of the 21:49 build for both snakes x all scores with `v == 1` (0 errors, 29 .. 116 cycles, other snake untouched).
* `snake_dec_score(s)`: floors at 0000; verified for all scores on the model.
* Display: `snake_advance` / `snake_punish` only set `update_score = 1`; `gfx_update_score()` (asm, 8 digit writes,
  about 100 cycles) runs at the top of the next game-loop iteration and once at level start.
  Verified in the listing: snake 1 digits read from `$4210..`, snake 2 from `$441a..`, written to `$07c1-$07c4`
  and `$07e3-$07e6` (row 24, columns 1-4 and 35-38), each digit + 48.


## 5. Review findings

### Fixed since the first review

* `snake_draw_tail(2)` used `snake1.end` (regression from commit 2130bd1; could write outside the screen tables).
* `gfx_exit` did not restore `$d018`; it is now saved and restored.
* Unsequenced `++event[i].animate` removed; heart animation reworked (`heart_animate = {3,4,5,4,3}`,
  images 51..53 only), which also removes the blank animation frame.
* `rng_next` asm: missing `eor` operand fixed. `rand()` replaced by the custom generator.
* `snake_inc_score` range problem (`v > 10` produced invalid digits): clamp added.
* Stale comments and typos in `gfx.c` / `gfx.h` fixed; stray file `data/..\src\sprites.c` and `data/sprites.c` removed
  (git still lists `data/sprites.c` as deleted until committed).
* `gfx.c` reordered (`gfx_init` before the drawing primitives); builds fine because the prototypes are in `gfx.h`.
* (2026-09-22) `snake_draw_tail` erased cell `end-1` even when the tail did not advance (growth); this could blank
  food, the head or the other snake. Fixed as part of the `trail`/`BARREL` work below (`tail_moved` guard) - the
  fix is unconditional, so this is resolved generally, not just for the trail case.

### Still open (none urgent)

* The keyboard buffer is not flushed before `wait_for_key` in `game_menu`.
* CIA access race in `stop_pressed` / `snake_control` (already on the readme to-do list);
  `gfx_init` ends with an unconditional `cli`.
* No collision sound on a plain bump, only in `snake_punish` after `STUCK_TIMEOUT` (4) blocked ticks.
* Hazard map "four blocks" is one tile off-symmetric (x 5-12 vs 28-35, y 3-10 vs 14-21).
* `SNAKE_SCORE_OFF` is a magic number: a change of the `Snake` layout silently breaks `gfx_update_score()`.
  A compile-time check on `offsetof(Snake, score)` would catch it.
* A score change made in the very last loop iteration of a level (timer end / both snakes dead) is not drawn before
  the fade-out (cosmetic; the menu reads the variables). The score is also drawn twice at level start (harmless).
* Dead code: `snake_dir_score`, `SNAKE_INACTIVE`, `wait_100ms` (`utils.c`), `snd_test`, `wait_frame`,
  `snd_play_timer_tick`, `snd_play_bounce` (`snd.c`), `#include <stdlib.h>`, non-const `SDIR_OPPOSITE`,
  `event_add` hardcodes 8 instead of `EVENT_N`.
* Three logo glyphs have colour 0 on a black background (invisible; they come from the original art in `archive/`).


## 6. Superseded: heart vs. snake head collision design

**Status: implemented for real.** `event_process` now has live collision handling for all three event types
(`HEART`, `SCORPION`, `BARREL`; the "spider predator" mentioned below became `SCORPION`, and `BARREL` was
added later, see section 7). The actual implementation is simpler than the geometry below: it compares
`gfx_scr_get_xy`/`gfx_clr_get_xy` at the event's cell against `SP_HEAD`/`SP_BODY`/`SP_TAIL1`/`SP_TAIL2` and
`S1_COLOR`/`S2_COLOR`, not the ink-centred dx/dy test. The design notes are kept below for the rationale
(placement of the check inside `event_process`, cost estimate, rejected alternatives), which still applies.

### Planned: heart vs. snake head collision (design only, nothing implemented) - historical

**Where:** inside `event_process()`, in `case HEART`, in the `if (event[i].active)` branch, after `xpos` has been
moved and before the sprite is drawn. The existing placeholder comment `// check collision with snake head -> consume`
sits after the if/else and would also run for a heart that was just deactivated at the screen edge - move it inside.
Reasons: the loop already runs every frame over the active events and owns `xpos` / `ypos`; hearts and later
event types (spider predator) need different reactions, so the reaction belongs in the per-type `case`;
the check uses the fresh position (no one-frame lag); it costs nothing when no event is active.
`event_process` runs before `snake_advance` in the loop, so a head that just moved is seen one frame later (irrelevant).

**Geometry (measured from `sprites.c`):** the ink of all three heart frames is centred at (11.5, 10) relative to the
sprite origin (ink 16x15, 14x13, 12x10 px), so one centre-based test works for every animation frame.
With the head cell centre at (8*hx + 28, 8*hy + 54): `dx = xpos - 8*hx - 16`, `dy = ypos - 8*hy - 44`;
hit when `|dx| <= ~10` and `|dy| <= ~9` (or compare cell coordinates `(xpos-12)>>3`, `(ypos-40)>>3` with the head cell).
Test y first (8 bit, cheap reject). Hearts fly 1 px per frame and a head stays in its cell for 6 frames, so a per-frame
check cannot tunnel.

**Details to get right:**
* only snakes with `status == SNAKE_ACTIVE` collect; head = `snakeN.x/y[snakeN.start]`;
* `xpos` is 16 bit and can be below 12 (heart partly off the left edge): compare in 16 bit or range-check first,
  do not cast the shifted value to `uint8_t` blindly;
* consume: `active = 0`, `spr_show(i, 0)` (skip the draw), `snake_inc_score(s, v)` with `v <= 10`, `update_score = 1`,
  a sound (`snd_play_eat` shares voice 1 with normal food); snake 1 is tested first, so a tie goes to snake 1;
* estimated cost about 150-250 cycles per active heart per frame (not compiled); normally at most 2-3 hearts are on screen.

**Rejected alternatives:** checking inside `snake_advance` (only every 6th frame, on the heaviest frame, needs an inner
loop over the events per snake, delays hits by up to 6 frames); a separate `event_check_collisions()` called from the
game loop is a fine refactoring if `event_process` grows, but duplicates the loop and re-reads the event fields.


## 7. `BARREL` event / hazardous trail - review finding and fix (2026-09-22)

A third event type, `BARREL`, was added (`enum EventType` in `snake.c`, spawn logic shared with `HEART`/
`SCORPION` in `event_add`): on collision with a snake it sets `Snake.trail = 5` (new field, `snake.h`).
`snake_draw_tail` then lays a red `SP_TAIL2` hazard tile at the cell the tail just vacated instead of erasing
it, once per genuine tail advance, decrementing `trail` each time - a trail of up to 5 hazardous cells left
behind the snake for both snakes to run into (including the one that dropped it).

**Bug found in review:** `snake_draw_tail` is called unconditionally from `snake_advance` on every advance,
but `end` (the tail index) only actually moves when the snake isn't growing (`grow == 0`) or has hit
`SNAKE_MAX`. On a growth tick, `snake_draw_tail` still computed `p2 = dec8(end)` and touched it - but since
`end` hadn't moved, `p2` was still a live, occupied body cell, not a newly vacated one. With `trail > 0`
active this stamped a still-live segment with the red hazard tile and silently decremented the trail budget
without laying a real hazard behind the snake; this is also a more-frequent variant of the older "still open"
`end-1` erase bug (section 5), since food-growth is common and a tightly coiled snake is not.

**Fix applied:** `snake_draw_tail(s, tail_moved)` gained a `tail_moved` parameter; the erase-or-trail branch
that touches `p2` now runs only when `tail_moved` is set. `snake_advance` computes it per call (`1` unless the
tail was suppressed by growth, i.e. `grow > 0 && length < SNAKE_MAX`), and in that same branch immediately
sets `snake.trail = 0` - confirmed intentional: growth cancels an active trail outright rather than pausing
it. The two `snake_punish` call sites and the initial per-level draw always pass `1` (the tail genuinely
moved, or it's the first draw of the level).

Design considered and rejected: pausing the trail (skip laying a cell on a growth tick, keep the remaining
budget for later) - decided against; growth should cancel the effect immediately instead.
