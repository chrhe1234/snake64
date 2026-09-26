# Snake64

## About

## To-Do

* Last time sound blip should be a slightly longer higher tone that signals the end of the level.

## Design notes

* One player vs. computer or Two player modes.

* All graphics and the snakes are character based. We use some custom characters that are patched in after copying the
  character ROM to RAM \$3800. Screen RAM stays at \$0400.

* Events are sprite-bases. We have a scorpion (enemy), heart (reward), barrel (toxin, tactical, hazardous trail left behind.)

* Sprites are from \$0C00 to \$1000, which is enough space for 16 sprites.

## Done

* 2026-09-27: Spawning should be controlled and level-dependent. Levels range from 1 to 50 max.

* 2026-09-27: CIA access by sei/cli so they cannot be interrupted.

* 2026-09-26: Highscore tracking.

* 2026-09-26: Maybe cosmetic score feedback: Show brief +1, -1, etc. sprites where points are gained or lost. Not enough
  sprite slots for that.

* 2026-09-26: performance issue caused by event processing.

* 2026-09-26: Performance of computer player: Move the evaluation of the vicinity (of the snake head moving into a
  specific direction) into a separate function and also the variables for empty, hazard, food. Change the
  evaluation such that empty, food and anything else (always a hazard or the snake itself) is counted, in fact,
  the latter is n\_cells - n\_empty - n\_food and does not need to be counted. Reduce the number of investigated
  cells such that only what's forward is counted, otherwise we are repeatedly scanning the tiles that do not help
  in deciding where to go, e.g. if looking at the direction up, we only count x-2,y x-1,y x,y, x+1,y x+2,y
  x-2,y-1, ... x+2,y-2 (i.e. a horizontal 5x3 field), for moving left or right, this needs to be rotated. Scanning
  should be done in an optimized fashion, i.e. first the top left coordinate is established (x0, y0, clipped so we never
  move out of the screen), then we modify the screen character loading instruction lda $1234,x so that loads from line y0, next we move x0 into x, and load and
  count, for the next screen position we add an increment from a table to x (+1 for next character same line, +40
  for next character one line down, e.g. +1, +1, +38, +1, +1, +38, etc., it would fit because at most we start with
  x = 37 and add 200 + 2, which is still below 255), y could hold the index into that table lda table,y and add
  to x, or directly txa clc adc table,y tax, ... that should be a lot faster than the current algorithm, index
  in y could also be used to directly load the relative weight from a table instead of abs8 () + abs8 () ...

* A lot of hits are still missed using the current single point check.

* Levels: Create obstacle layouts with progressively more difficult navigation. Decide how hazards are incorporated into
  level design. Corridors could be added. Maybe also 8 or more L-type shapes.

* Add another event (e.g. poisonous barrel) that makes the snake leave behind a hazardous trail for a few steps. Both in
  the same color as the hazards.

* Add a snake-shortening predator (e.g. scorpion) that attacks and shortens a snake.

* Add sprite-based events. A horizontally floating heart (+5 if hit with snake head) is implemented.

* Time blips should increase their frequency as time is counted down.

* There should be some game over screen.

* Hazard consequences: Decrease score when a hazard is encountered. Add clear visual/audio feedback for the penalty.

* Collision feedback: Add an audio signal when a player bumps into a wall, obstacle, or blocked snake segment.

* Implement quiting the game loop by pressing stop.

* Display last score in menu.

* Character set: Do not embed the whole 2k in the program. Instead copy the charset from ROM to 0x3800 and patch it in
  place. Reduces the program size by ~ 2k.

* Food system: Implement vsync-based spawn/despawn logic. Limit random placement attempts so spawning cannot get stuck.