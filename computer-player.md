# Snake64 - the computer player

This describes how the computer-controlled snake (`snake_computer()` in `src/snake.c`) decides where to go.
It always controls snake 2; snake 1 is always the human player. It only runs in "player vs. computer" mode.

## When it decides

The computer player doesn't reconsider its direction every frame. `game_loop()` only calls it every third
frame that isn't also a snake-advance frame (`COMPUTER_TICKS = 3`), so its decision cadence is independent of,
and coarser than, how often the snake actually moves. Between decisions, it just keeps heading the way it was
last told to.

## Step 1: what's immediately next to the head

For each of the four directions (up, right, down, left), except the one that would reverse into the snake's
own neck (the snake can never do a 180-degree turn in place), it looks at the single cell one step away and classifies it:

* a hazard tile -> blocked
* food -> forced
* anything else that isn't empty -> blocked (this includes both snakes' bodies, the border, and hazardous
  trail cells)
* empty -> available

If nothing is immediately forced, every direction still marked *available* moves on to step 2. If none are
available (surrounded on all sides that aren't blocked outright), the snake keeps its current heading and
drives into whatever is there - there's no separate "stuck" behaviour.

## Step 2: scoring the remaining candidates

Every *available* direction gets a score, and the highest-scoring one is taken. The score has three parts.

### A straight-line look-ahead (up to 6 cells)

Starting one cell past the immediate neighbour already checked in step 1, the snake looks straight ahead in
that direction for up to 6 more cells, counting how many in a row are empty or food before hitting the edge of
the map or something solid. This rewards directions that open into a long clear corridor, independent of what
the wider surroundings look like.

### A weighted footprint (15 cells) around the space just ahead

This is the main spatial-awareness term. Rather than looking at a plain square, the footprint is shaped to
match the direction of travel: 5 cells wide by 3 cells deep when heading up or down, or 3 cells wide by 5
cells deep when heading left or right - wider sideways than forward when moving vertically, and vice versa.
Every cell in that footprint is classified as empty, food, or hazard (again, "hazard" here means anything
that isn't empty or food - other snake segments, the border, trail, included), and each is added into one of
three running totals:

* empty cells count flat, one point each, regardless of position;
* food and hazard cells are weighted by where they sit in the footprint - closer positions contribute more,
  distant ones less. The weighting is centred not on the very first cell of the footprint but one step further
  in - practically, this means the cell closest to the snake's own current position is weighted slightly
  *higher* than the cell directly ahead of it, and weight tapers off from there in every direction across the
  footprint.

The direction's contribution to the score is `empty + food - hazard`: nearby open space and nearby food raise
the score, nearby hazards - of any kind - lower it, and how far away things are matters more than how many
there are.

### A small nudge to keep moving straight, plus a pinch of randomness

A small fixed bonus is added if a direction matches the snake's current heading, so the snake doesn't
zig-zag between two similarly-scored directions on every decision tick, or accept a marginal improvement in
one direction and immediately reconsider on the next tick. A small random value (0-3) is also added to every
direction's score, mostly there to break exact ties unpredictably rather than to meaningfully influence
otherwise-clear decisions.

The direction with the highest total score becomes the new heading. Ties are broken by check order (up, right,
down, left) - the earlier direction wins.

## In short

The computer player is short-sighted but not blind: it grabs adjacent food immediately without weighing
anything else, otherwise it looks a modest distance ahead (a handful of cells in a straight line, plus a
15-cell wedge shaped by its own direction of travel) and prefers directions that are more open and have more
nearby food, treating literally anything solid - not just decorative hazards - as something to steer away
from. It has a mild preference for continuing straight rather than turning, and no memory beyond its current
heading and whatever the board looks like right now.