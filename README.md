# Snake64

## About

This is a variant of the well-known snake game for the C64 for one or two players. It's my first attempt at a more
complete game for the C64.

The player controls a snake that is constantly moving and needs to avoid obstacles (e.g. objects, the other snake,
itself) while at the same time collecting food (heart) to grow. Hitting an obstacle or being attacked by a predator
(scorpion) costs food and shortens the snake. If the snake gets too short it dies. If both snakes die the game is over.
If a poisonous barrel is hit, the snake will leave a poisonous trail (obstacle) behind for some time.

The title screen should be self-explanatory. In the game, the snakes are controlled by joysticks (port 2 for 1st
player = left = green and port 1 for 2nd player = right = blue) or, if selected, by the computer. Press RUN/STOP for
exiting the game. The frequency of events increases with level and they become increasingly disadvantageous.

That's all there is to it for now.

The game is written mostly in C and some assembly language and can be compiled with Oscar64
(https://github.com/drmortalwombat/oscar64). You can use the included build script in Linux. Or simply use/run the disk
image or the prg file.

## To-Do

* Flush keyboard buffer before `wait_for_key` in `game_menu`?

## Design notes

* One player vs. computer or two player modes. Levels range from 1 to 50 max. Players can obstruct each other if they
  want.

* All graphics (except for events) and the snakes are character based. Use some custom characters that are patched in
  after copying the character ROM to RAM \$3800. Screen RAM stays at \$0400. Character and color RAM also function as level map and game
  state.

* Snakes are implemented as ring buffers.

* Events are sprite-based (max 8). We have a scorpion (enemy), heart (reward), barrel (toxin, tactical, hazardous trail
  left behind.)
    * Collision (`event_check_collision`): reads the two character columns `xc`, `xc+1` over rows `yc`, `yc+1` and
      reports a snake when the character is a snake part and the colour is `S1_COLOR` / `S2_COLOR`. `skip_left` /
      `skip_right` suppress columns outside the screen. Each column reads `yc` and `yc+1` with two
      self-modified `lda $ffff,x`, both patched with row `yc`'s address; the second read adds 40 to X instead of a
      second row-table lookup (the row tables are strict `base + row*40`).
      Both instructions must be patched.
    * HEART -> food, SCORPION -> punish, BARREL -> trail

* Food spawning/`food_check()` (every `FOOD_TICKS` = 50 frames, only in frames without advance, computer move or spawn):
  only the first inactive slot gets the spawn search per call (`search_performed`), with `FOOD_SPAWN_TRIES` = 5
  random tries at `1 + % 38`, `1 + % 22`; active slots age and despawn after `FOOD_DURATION + % FOOD_DURATION`
  checks (`FOOD_DURATION` = 16).

* A bit of text because it took some thought and time for the 6502. The computer player has no persistent model of the
  map/games. Each decision is based on the current screen contents around the snake head. The decision consists of an
  immediate collision/food test followed by a score for every available direction (up, right, down, left). The direction
  opposite
  to the current heading is always marked as blocked because the snake cannot reverse by 180 degrees.
    * For each of the other directions, the cell immediately next to the head is classified as follows: `TILE_FOOD` ->
      **forced**, `TILE_EMPTY` -> **available**, anything else (borders, hazard, snake, etc.) -> **blocked**
    * If food is found immediately next to the snake, the computer takes it immediately.
    * If no direction is available, i.e. head is blocked/locked-in, the old heading is kept. The next `snake_advance()`
      will attempt the current direction; if it is still blocked, the normal stuck/punishment mechanism handles that
      situation.
    * Without forced moves and with available direction -> evaluation of each available direction:
        * Straight-line look-ahead: measures how far it can continue in a straight line (max 6). To favor directions
          that lead into a longer open corridor.
        * Direction-oriented local environment: The computer evaluates a 15-cell rectangular area around and in front of
          the head. The footprint is wider across the direction of travel than along it: up/down: 5x3 cells;
          left/right: 3x5 cells. Near a screen edge, the top-left coordinate (cx, cy) is shifted so that the complete
          15-cell rectangle remains on screen (shift, no clip). Each cell (int the 3x5 field) is classified as: empty,
          food, hazard (anything but empty or food). Food and hazards are weighted according to position (decreases with
          distance to head, max 6 = head).
            * Performance-oriented implementation in `snake_computer_explore()`. Results are stored in the global
              variables. The critical scan itself is written in 6502 assembly language. Before the scan begins, it looks
              up the address of screen row `cy` through `scr_row_low[]` and `scr_row_high[]` and patches the code (LDA
              \$XXXX,X). `X`  is then initialized with the leftmost column `cx`. All position in the 5x3/3x5 area are
              then scanned by continuously adding offsets to `X`. The offsets are read from `sce_offset[]` (e.g. +1 -> move right one
              char, +1 -> once more, +38; next row). The use of an 8-bit `X` index is safe. The largest relative offset
              reached by the 3x5 scan is 199 (with `cx <= 37`, giving a maximum `X` value of 37 + 4 * 40 + 2 = 199, wrap
              past 255). `Y` indexes the appropriate 15-entry part of the weight table `sce_weight[]`. The four direction-specific sections of both
              tables start at indices 0, 15, 30 and 45.
        * The final score is a combination of empty cells ahead, and, in the 5x3/3x5 area ahead, empty, food and
          hazard with a bit of randomness and "stickiness". The random value prevents completely deterministic movement.
          The stickiness bonus discourages unnecessary zig-zagging. The available direction with the highest score
          becomes the new heading.

* Sprites are from \$0C00 to \$1000, which is enough space for 16 sprites.

* Using `%` where absolutely needed is ok because Oscar64's `divmod` is efficient and timeing is predictable.

## Done

* Time sound blip is now lightly longer higher tone that signals the end of the level.

* Event spawning is now controlled by settings and level-dependent.

* Introduced CIA access by sei/cli so they cannot be interrupted.

* Highscore tracking is done. Not saved to disk for the time being.

* Maybe cosmetic score feedback: Show brief +1, -1, etc. sprites where points are gained or lost? Not enough
  sprite slots for that.

* Fixed performance issue caused by slow event processing.

* Improved performance of computer player by redesigning and rewriting parts in assembly language (see above).

* Fixed: A lot of hits are still missed using the current single point check.

* Done: Create obstacle layouts/levels with progressively more difficult navigation. Decide how hazards are incorporated
  into
  level design. Corridors could be added. Maybe also 8 or more L-type shapes.

* Done: Add another event (e.g. poisonous barrel) that makes the snake leave behind a hazardous trail for a few steps.
  Both in the same color as the hazards.

* Done: Add a snake-shortening predator (e.g. scorpion) that attacks and shortens a snake.

* Added sprite-based events. A horizontally floating heart (+5 if hit with snake head) is implemented.

* Done: Time blips should increase their frequency as time is counted down.

* There should be some game over screen.

* Hazard consequences: Decrease score when a hazard is encountered. Add clear visual/audio feedback for the penalty.

* Collision feedback: Add an audio signal when a player bumps into a wall, obstacle, or blocked snake segment.

* Implement quiting the game loop by pressing stop.

* Display last score in menu.

* Character set: Do not embed the whole 2k in the program. Instead copy the charset from ROM to 0x3800 and patch it in
  place. Reduces the program size by ~ 2k.

* Food system: Implement vsync-based spawn/despawn logic. Limit random placement attempts so spawning cannot get stuck.