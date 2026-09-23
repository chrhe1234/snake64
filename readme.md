# Snake64

## About

## To-Do

* Fix performance issue caused by event processing.

* Event spawning should be controlled and level-dependent. Levels range from 1 to 50 max.

* Wrap CIA access by sei/cli so they cannot be interrupted.

* Last time sound blip should be a slightly longer higher tone that signals the end of the level.

* Computer player: Keep the current 5×5 neighbourhood evaluation plus scan-ahead approach. Refine only when specific weaknesses show up during playtesting.

* Maybe cosmetic score feedback: Show brief +1, -1, etc. sprites where points are gained or lost.

## Design notes

* All graphics and the snakes are character based. We use some custom characters that are patched in after copying the character ROM to RAM $3800.

* Sprites are from $0C00 to $1000, which is enough space for 16 sprites.

## Done

* A sound for touching a barrel is missing. And we need to change the color for the barrel to something else.

* A lot of hits are still missed using the current single point check.

* Levels: Create obstacle layouts with progressively more difficult navigation. Decide how hazards are incorporated into level design. Corridors could be added. Maybe also 8 or more L-type shapes.

* Add another event (e.g. poisonous barrel) that makes the snake leave behind a hazardous trail for a few steps. Both in the same color as the hazards.

* Add a snake-shortening predator (e.g. scorpion) that attacks and shortens a snake.

* Add sprite-based events. A horizontally floating heart (+5 if hit with snake head) is implemented.

* Time blips should increase their frequency as time is counted down.

* There should be some game over screen.

* Hazard consequences: Decrease score when a hazard is encountered. Add clear visual/audio feedback for the penalty.

* Collision feedback: Add an audio signal when a player bumps into a wall, obstacle, or blocked snake segment.

* Implement quiting the game loop by pressing stop.

* Display last score in menu.

* Character set: Do not embed the whole 2k in the program. Instead copy the charset from ROM to 0x3800 and patch it in place. Reduces the program size by ~ 2k.

* Food system: Implement vsync-based spawn/despawn logic. Limit random placement attempts so spawning cannot get stuck.