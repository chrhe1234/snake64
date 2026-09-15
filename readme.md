# Snake64


## About



## To-Do

* Display last score in menu

* Implement quiting the game loop by pressing stop

* Hazard consequences: Decrease score when a hazard is encountered. Add clear visual/audio feedback for the penalty.

* Collision feedback: Add an audio signal when a player bumps into a wall, obstacle, or blocked snake segment.

* Levels: Create obstacle layouts with progressively more difficult navigation. Decide how hazards are incorporated into level design.

* Sprite-based gameplay additions: Add a snake-shortening predator that attacks a snake and removes tail segments. Add temporary bonus food/rewards that appear occasionally and give a larger reward than normal food.

* Computer player: Keep the current 5×5 neighbourhood evaluation plus scan-ahead approach. Refine only when specific weaknesses show up during playtesting.

* Cosmetic score feedback: Show brief +1, -1, etc. sprites where points are gained or lost.


## Done

* Character set: Do not embed the whole 2k in the program. Instead copy the charset from ROM to 0x3800 and patch it in place. Reduces the program size by ~ 2k.

* Food system: Implement vsync-based spawn/despawn logic. Limit random placement attempts so spawning cannot get stuck.

