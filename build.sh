#!/bin/bash

# oscar64 -g src/snake.c src/sprites.c src/gfx.c src/snd.c src/utils.c -o=snake64.prg -d64=snake64.d64

oscar64 -O2 -g src/snake.c src/sprites.c src/gfx.c src/snd.c src/utils.c -o=snake64.prg -d64=snake64.d64
