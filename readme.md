# Snake64


## About


## To-Do

* Time blips should increase their frequency as time is counted down. And at the very end, there should be a slightly longer higher tone that signals the end of the level.

* Wrap CIA access by sei/cli so they cannot be interrupted.

* Levels: Create obstacle layouts with progressively more difficult navigation. Decide how hazards are incorporated into level design. Corridors could be added. Maybe also 8 or more L-type shapes.

* Sprite-based gameplay additions: Add a snake-shortening predator that attacks a snake and removes tail segments. Add temporary bonus food/rewards that appear occasionally and give a larger reward than normal food.

* Computer player: Keep the current 5×5 neighbourhood evaluation plus scan-ahead approach. Refine only when specific weaknesses show up during playtesting.

* Maybe cosmetic score feedback: Show brief +1, -1, etc. sprites where points are gained or lost.


## Done

* There should be some game over screen.

* Hazard consequences: Decrease score when a hazard is encountered. Add clear visual/audio feedback for the penalty.

* Collision feedback: Add an audio signal when a player bumps into a wall, obstacle, or blocked snake segment.

* Implement quiting the game loop by pressing stop.

* Display last score in menu.

* Character set: Do not embed the whole 2k in the program. Instead copy the charset from ROM to 0x3800 and patch it in place. Reduces the program size by ~ 2k.

* Food system: Implement vsync-based spawn/despawn logic. Limit random placement attempts so spawning cannot get stuck.

