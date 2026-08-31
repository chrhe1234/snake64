; Compiled with 1.32.273
--------------------------------------------------------------------
startup: ; startup
0801 : 0b __ __ INV
0802 : 08 __ __ PHP
0803 : 0a __ __ ASL
0804 : 00 __ __ BRK
0805 : 9e __ __ INV
0806 : 32 __ __ INV
0807 : 30 36 __ BMI $083f ; (startup + 62)
0809 : 31 00 __ AND ($00),y 
080b : 00 __ __ BRK
080c : 00 __ __ BRK
080d : ba __ __ TSX
080e : 8e ce 15 STX $15ce ; (spentry + 0)
0811 : a2 28 __ LDX #$28
0813 : a0 00 __ LDY #$00
0815 : a9 00 __ LDA #$00
0817 : 85 19 __ STA IP + 0 
0819 : 86 1a __ STX IP + 1 
081b : e0 2c __ CPX #$2c
081d : f0 0b __ BEQ $082a ; (startup + 41)
081f : 91 19 __ STA (IP + 0),y 
0821 : c8 __ __ INY
0822 : d0 fb __ BNE $081f ; (startup + 30)
0824 : e8 __ __ INX
0825 : d0 f2 __ BNE $0819 ; (startup + 24)
0827 : 91 19 __ STA (IP + 0),y 
0829 : c8 __ __ INY
082a : c0 0c __ CPY #$0c
082c : d0 f9 __ BNE $0827 ; (startup + 38)
082e : a9 00 __ LDA #$00
0830 : a2 f7 __ LDX #$f7
0832 : d0 03 __ BNE $0837 ; (startup + 54)
0834 : 95 00 __ STA $00,x 
0836 : e8 __ __ INX
0837 : e0 f7 __ CPX #$f7
0839 : d0 f9 __ BNE $0834 ; (startup + 51)
083b : a9 fe __ LDA #$fe
083d : 85 23 __ STA SP + 0 
083f : a9 9f __ LDA #$9f
0841 : 85 24 __ STA SP + 1 
0843 : 20 00 0a JSR $0a00 ; (main.s4 + 0)
0846 : a9 4c __ LDA #$4c
0848 : 85 54 __ STA $54 
084a : a9 00 __ LDA #$00
084c : 85 13 __ STA P6 
084e : a9 19 __ LDA #$19
0850 : 85 16 __ STA P9 
0852 : 60 __ __ RTS
--------------------------------------------------------------------
main: ; main()->i16
; 418, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 419, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a00 : 20 83 0a JSR $0a83 ; (gfx_init.s4 + 0)
; 420, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a03 : 20 d4 0a JSR $0ad4 ; (gfx_draw_frame.s4 + 0)
; 422, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a06 : a9 23 __ LDA #$23
0a08 : 85 10 __ STA P3 
0a0a : a9 14 __ LDA #$14
0a0c : 85 11 __ STA P4 
0a0e : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 423, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a11 : a9 23 __ LDA #$23
0a13 : 85 10 __ STA P3 
0a15 : a9 05 __ LDA #$05
0a17 : 85 11 __ STA P4 
0a19 : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 424, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a1c : a9 05 __ LDA #$05
0a1e : 85 10 __ STA P3 
0a20 : a9 14 __ LDA #$14
0a22 : 85 11 __ STA P4 
0a24 : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 425, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a27 : a9 05 __ LDA #$05
0a29 : 85 10 __ STA P3 
0a2b : 85 11 __ STA P4 
0a2d : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 427, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a30 : a9 14 __ LDA #$14
0a32 : 85 10 __ STA P3 
0a34 : a9 03 __ LDA #$03
0a36 : 85 11 __ STA P4 
0a38 : 20 34 10 JSR $1034 ; (gfx_draw_hazard.s4 + 0)
; 428, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a3b : a9 14 __ LDA #$14
0a3d : 85 10 __ STA P3 
0a3f : 85 11 __ STA P4 
0a41 : 20 34 10 JSR $1034 ; (gfx_draw_hazard.s4 + 0)
; 430, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a44 : 20 52 10 JSR $1052 ; (snake_init.s4 + 0)
; 431, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a47 : a9 01 __ LDA #$01
0a49 : 85 10 __ STA P3 
0a4b : 20 68 11 JSR $1168 ; (snake_draw_head.s4 + 0)
; 432, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a4e : a9 01 __ LDA #$01
0a50 : 85 10 __ STA P3 
0a52 : 20 0e 12 JSR $120e ; (snake_draw_body.s4 + 0)
; 433, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a55 : a9 01 __ LDA #$01
0a57 : 85 10 __ STA P3 
0a59 : 20 8e 12 JSR $128e ; (snake_draw_tail.s4 + 0)
; 435, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a5c : a9 00 __ LDA #$00
0a5e : 85 49 __ STA T1 + 0 
.l5:
; 437, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a60 : 20 f3 0b JSR $0bf3 ; (wait_for_frame.s4 + 0)
; 438, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a63 : a9 01 __ LDA #$01
0a65 : 20 95 13 JSR $1395 ; (snake_control.s4 + 0)
; 440, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a68 : a5 49 __ LDA T1 + 0 
0a6a : c9 06 __ CMP #$06
0a6c : e6 49 __ INC T1 + 0 
0a6e : 90 f0 __ BCC $0a60 ; (main.l5 + 0)
.s6:
; 443, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a70 : a9 00 __ LDA #$00
0a72 : 85 49 __ STA T1 + 0 
; 441, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a74 : ad 00 28 LDA $2800 ; (snake1.status + 0)
0a77 : d0 e7 __ BNE $0a60 ; (main.l5 + 0)
.s7:
; 442, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a79 : a9 01 __ LDA #$01
0a7b : 85 11 __ STA P4 
0a7d : 20 27 14 JSR $1427 ; (snake_advance.s4 + 0)
0a80 : 4c 60 0a JMP $0a60 ; (main.l5 + 0)
--------------------------------------------------------------------
gfx_init: ; gfx_init()->void
;  43, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 211, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0a83 : ad 20 d0 LDA $d020 
0a86 : 8d cf 15 STA $15cf ; (gfx_old_border + 0)
0a89 : a9 00 __ LDA #$00
0a8b : 8d 20 d0 STA $d020 
0a8e : ad 21 d0 LDA $d021 
0a91 : 8d d0 15 STA $15d0 ; (gfx_old_background + 0)
0a94 : a9 00 __ LDA #$00
0a96 : 8d 21 d0 STA $d021 
0a99 : a9 18 __ LDA #$18
0a9b : 8d 18 d0 STA $d018 
; 224, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0a9e : a9 20 __ LDA #$20
0aa0 : 20 a8 0a JSR $0aa8 ; (gfx_scr_set.s4 + 0)
; 225, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0aa3 : a9 01 __ LDA #$01
0aa5 : 4c be 0a JMP $0abe ; (gfx_clr_set.s4 + 0)
--------------------------------------------------------------------
gfx_scr_set: ; gfx_scr_set(u8)->void
;  28, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
0aa8 : 85 0d __ STA P0 
; 131, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0aaa : a5 0d __ LDA P0 
0aac : a2 00 __ LDX #$00
0aae : 9d 00 04 STA $0400,x 
0ab1 : 9d 00 05 STA $0500,x 
0ab4 : 9d 00 06 STA $0600,x 
0ab7 : 9d e8 06 STA $06e8,x 
0aba : e8 __ __ INX
0abb : d0 f1 __ BNE $0aae ; (gfx_scr_set.s4 + 6)
.s3:
; 141, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0abd : 60 __ __ RTS
--------------------------------------------------------------------
gfx_clr_set: ; gfx_clr_set(u8)->void
;  37, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
0abe : 85 0d __ STA P0 
; 178, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0ac0 : a5 0d __ LDA P0 
0ac2 : a2 00 __ LDX #$00
0ac4 : 9d 00 d8 STA $d800,x 
0ac7 : 9d 00 d9 STA $d900,x 
0aca : 9d 00 da STA $da00,x 
0acd : 9d e8 da STA $dae8,x 
0ad0 : e8 __ __ INX
0ad1 : d0 f1 __ BNE $0ac4 ; (gfx_clr_set.s4 + 6)
.s3:
; 188, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0ad3 : 60 __ __ RTS
--------------------------------------------------------------------
gfx_draw_frame: ; gfx_draw_frame()->void
;  49, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 244, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0ad4 : a9 00 __ LDA #$00
0ad6 : 85 0d __ STA P0 
0ad8 : 85 0e __ STA P1 
0ada : a9 55 __ LDA #$55
0adc : 85 0f __ STA P2 
0ade : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 245, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0ae1 : a9 00 __ LDA #$00
0ae3 : 85 0d __ STA P0 
0ae5 : 85 0e __ STA P1 
0ae7 : a9 01 __ LDA #$01
0ae9 : 85 0f __ STA P2 
0aeb : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 246, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0aee : a9 27 __ LDA #$27
0af0 : 85 0d __ STA P0 
0af2 : a9 49 __ LDA #$49
0af4 : 85 0f __ STA P2 
0af6 : a9 00 __ LDA #$00
0af8 : 85 0e __ STA P1 
0afa : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 247, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0afd : a9 27 __ LDA #$27
0aff : 85 0d __ STA P0 
0b01 : a9 01 __ LDA #$01
0b03 : 85 0f __ STA P2 
0b05 : a9 00 __ LDA #$00
0b07 : 85 0e __ STA P1 
0b09 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 249, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b0c : a9 00 __ LDA #$00
0b0e : 85 0d __ STA P0 
0b10 : a9 4a __ LDA #$4a
0b12 : 85 0f __ STA P2 
0b14 : a9 17 __ LDA #$17
0b16 : 85 0e __ STA P1 
0b18 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 250, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b1b : a9 00 __ LDA #$00
0b1d : 85 0d __ STA P0 
0b1f : a9 01 __ LDA #$01
0b21 : 85 0f __ STA P2 
0b23 : a9 17 __ LDA #$17
0b25 : 85 0e __ STA P1 
0b27 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 251, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b2a : a9 27 __ LDA #$27
0b2c : 85 0d __ STA P0 
0b2e : a9 4b __ LDA #$4b
0b30 : 85 0f __ STA P2 
0b32 : a9 17 __ LDA #$17
0b34 : 85 0e __ STA P1 
0b36 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 252, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b39 : a9 01 __ LDA #$01
; 254, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b3b : 85 43 __ STA T1 + 0 
; 252, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b3d : 85 0f __ STA P2 
0b3f : a9 27 __ LDA #$27
0b41 : 85 0d __ STA P0 
0b43 : a9 17 __ LDA #$17
0b45 : 85 0e __ STA P1 
0b47 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 255, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b4a : a2 01 __ LDX #$01
.l7:
0b4c : 86 0e __ STX P1 
0b4e : a9 00 __ LDA #$00
0b50 : 85 0d __ STA P0 
0b52 : a9 42 __ LDA #$42
0b54 : 85 0f __ STA P2 
0b56 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 256, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b59 : a5 43 __ LDA T1 + 0 
0b5b : 85 0e __ STA P1 
0b5d : a9 27 __ LDA #$27
0b5f : 85 0d __ STA P0 
0b61 : a9 42 __ LDA #$42
0b63 : 85 0f __ STA P2 
0b65 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 257, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b68 : a5 43 __ LDA T1 + 0 
0b6a : 85 0e __ STA P1 
0b6c : a9 00 __ LDA #$00
0b6e : 85 0d __ STA P0 
0b70 : a9 01 __ LDA #$01
0b72 : 85 0f __ STA P2 
0b74 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 258, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b77 : a5 43 __ LDA T1 + 0 
0b79 : 85 0e __ STA P1 
0b7b : a9 27 __ LDA #$27
0b7d : 85 0d __ STA P0 
0b7f : a9 01 __ LDA #$01
0b81 : 85 0f __ STA P2 
0b83 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 254, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b86 : e6 43 __ INC T1 + 0 
0b88 : a6 43 __ LDX T1 + 0 
0b8a : e0 17 __ CPX #$17
0b8c : 90 be __ BCC $0b4c ; (gfx_draw_frame.l7 + 0)
.s5:
; 261, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b8e : a9 01 __ LDA #$01
0b90 : 85 43 __ STA T1 + 0 
.l6:
; 262, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b92 : 85 0d __ STA P0 
0b94 : a9 00 __ LDA #$00
0b96 : 85 0e __ STA P1 
0b98 : a9 43 __ LDA #$43
0b9a : 85 0f __ STA P2 
0b9c : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 263, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0b9f : a5 43 __ LDA T1 + 0 
0ba1 : 85 0d __ STA P0 
0ba3 : a9 17 __ LDA #$17
0ba5 : 85 0e __ STA P1 
0ba7 : a9 43 __ LDA #$43
0ba9 : 85 0f __ STA P2 
0bab : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 264, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0bae : a5 43 __ LDA T1 + 0 
0bb0 : 85 0d __ STA P0 
0bb2 : a9 00 __ LDA #$00
0bb4 : 85 0e __ STA P1 
0bb6 : a9 01 __ LDA #$01
0bb8 : 85 0f __ STA P2 
0bba : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 265, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0bbd : a5 43 __ LDA T1 + 0 
0bbf : 85 0d __ STA P0 
0bc1 : a9 17 __ LDA #$17
0bc3 : 85 0e __ STA P1 
0bc5 : a9 01 __ LDA #$01
0bc7 : 85 0f __ STA P2 
0bc9 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 261, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0bcc : e6 43 __ INC T1 + 0 
0bce : a5 43 __ LDA T1 + 0 
0bd0 : c9 27 __ CMP #$27
0bd2 : 90 be __ BCC $0b92 ; (gfx_draw_frame.l6 + 0)
.s3:
; 267, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0bd4 : 60 __ __ RTS
--------------------------------------------------------------------
gfx_scr_set_xy: ; gfx_scr_set_xy(u8,u8,u8)->void
;  31, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 146, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0bd5 : a4 0e __ LDY P1 
0bd7 : b9 d1 15 LDA $15d1,y ; (scr_row_low[0] + 0)
0bda : 8d e8 0b STA $0be8 ; (gfx_scr_set_xy.s4 + 19)
0bdd : b9 ea 15 LDA $15ea,y ; (scr_row_high[0] + 0)
0be0 : 8d e9 0b STA $0be9 ; (gfx_scr_set_xy.s4 + 20)
0be3 : a5 0f __ LDA P2 
0be5 : a6 0d __ LDX P0 
0be7 : 9d ff ff STA $ffff,x 
.s3:
; 156, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0bea : 60 __ __ RTS
--------------------------------------------------------------------
dec8: ; dec8(u8)->u8
; 141, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 142, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0beb : 38 __ __ SEC
0bec : e9 01 __ SBC #$01
.s3:
0bee : 60 __ __ RTS
--------------------------------------------------------------------
inc8: ; inc8(u8)->u8
; 137, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 138, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0bef : 18 __ __ CLC
0bf0 : 69 01 __ ADC #$01
.s3:
0bf2 : 60 __ __ RTS
--------------------------------------------------------------------
wait_for_frame: ; wait_for_frame()->void
; 369, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 371, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0bf3 : a9 fa __ LDA #$fa
0bf5 : cd 12 d0 CMP $d012 
0bf8 : d0 fb __ BNE $0bf5 ; (wait_for_frame.s4 + 2)
0bfa : cd 12 d0 CMP $d012 
0bfd : f0 fb __ BEQ $0bfa ; (wait_for_frame.s4 + 7)
.s3:
; 379, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0bff : 60 __ __ RTS
--------------------------------------------------------------------
gfx_clr_set_xy: ; gfx_clr_set_xy(u8,u8,u8)->void
;  40, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 193, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1000 : a4 0e __ LDY P1 
1002 : b9 03 16 LDA $1603,y ; (clr_row_low[0] + 0)
1005 : 8d 13 10 STA $1013 ; (gfx_clr_set_xy.s4 + 19)
1008 : b9 1c 16 LDA $161c,y ; (clr_row_high[0] + 0)
100b : 8d 14 10 STA $1014 ; (gfx_clr_set_xy.s4 + 20)
100e : a5 0f __ LDA P2 
1010 : a6 0d __ LDX P0 
1012 : 9d ff ff STA $ffff,x 
.s3:
; 203, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1015 : 60 __ __ RTS
--------------------------------------------------------------------
gfx_draw_food: ; gfx_draw_food(u8,u8)->void
;  52, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 271, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1016 : a5 10 __ LDA P3 ; (x + 0)
1018 : 85 0d __ STA P0 
101a : a9 53 __ LDA #$53
101c : 85 0f __ STA P2 
101e : a5 11 __ LDA P4 ; (y + 0)
1020 : 85 0e __ STA P1 
1022 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 272, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1025 : a5 10 __ LDA P3 ; (x + 0)
1027 : 85 0d __ STA P0 
1029 : a5 11 __ LDA P4 ; (y + 0)
102b : 85 0e __ STA P1 
102d : a9 05 __ LDA #$05
102f : 85 0f __ STA P2 
1031 : 4c 00 10 JMP $1000 ; (gfx_clr_set_xy.s4 + 0)
--------------------------------------------------------------------
gfx_draw_hazard: ; gfx_draw_hazard(u8,u8)->void
;  55, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 277, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1034 : a5 10 __ LDA P3 ; (x + 0)
1036 : 85 0d __ STA P0 
1038 : a9 56 __ LDA #$56
103a : 85 0f __ STA P2 
103c : a5 11 __ LDA P4 ; (y + 0)
103e : 85 0e __ STA P1 
1040 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 278, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1043 : a5 10 __ LDA P3 ; (x + 0)
1045 : 85 0d __ STA P0 
1047 : a5 11 __ LDA P4 ; (y + 0)
1049 : 85 0e __ STA P1 
104b : a9 0a __ LDA #$0a
104d : 85 0f __ STA P2 
104f : 4c 00 10 JMP $1000 ; (gfx_clr_set_xy.s4 + 0)
--------------------------------------------------------------------
snake_init: ; snake_init()->void
; 322, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 323, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1052 : a9 01 __ LDA #$01
1054 : 85 0d __ STA P0 
1056 : 20 b8 10 JSR $10b8 ; (snake_reset.s4 + 0)
; 324, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1059 : a9 00 __ LDA #$00
105b : 8d 00 28 STA $2800 ; (snake1.status + 0)
; 325, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
105e : a9 03 __ LDA #$03
1060 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
; 326, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1063 : a9 12 __ LDA #$12
1065 : 85 0e __ STA P1 
1067 : a9 0a __ LDA #$0a
1069 : 85 0f __ STA P2 
106b : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 327, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
106e : c6 0e __ DEC P1 
1070 : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 328, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1073 : c6 0e __ DEC P1 
1075 : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 329, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1078 : c6 0e __ DEC P1 
107a : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 330, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
107d : c6 0e __ DEC P1 
107f : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 331, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1082 : c6 0e __ DEC P1 
1084 : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 332, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1087 : a9 02 __ LDA #$02
1089 : e6 0d __ INC P0 
108b : 20 b8 10 JSR $10b8 ; (snake_reset.s4 + 0)
; 333, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
108e : a9 00 __ LDA #$00
1090 : 8d 06 2a STA $2a06 ; (snake2.status + 0)
; 334, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1093 : a9 01 __ LDA #$01
1095 : 8d 07 2a STA $2a07 ; (snake2.direction + 0)
; 335, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1098 : a9 16 __ LDA #$16
109a : 85 0e __ STA P1 
109c : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 336, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
109f : e6 0e __ INC P1 
10a1 : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 337, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10a4 : e6 0e __ INC P1 
10a6 : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 338, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10a9 : e6 0e __ INC P1 
10ab : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 339, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ae : e6 0e __ INC P1 
10b0 : 20 18 11 JSR $1118 ; (snake_add.s4 + 0)
; 340, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10b3 : e6 0e __ INC P1 
10b5 : 4c 18 11 JMP $1118 ; (snake_add.s4 + 0)
--------------------------------------------------------------------
snake_reset: ; snake_reset(u8)->void
;  77, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
;  78, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10b8 : c9 01 __ CMP #$01
10ba : d0 1c __ BNE $10d8 ; (snake_reset.s5 + 0)
.s9:
;  79, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10bc : a9 00 __ LDA #$00
;  85, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10be : 85 1b __ STA ACCU + 0 
;  79, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10c0 : 8d 00 28 STA $2800 ; (snake1.status + 0)
;  81, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10c3 : 8d 02 2a STA $2a02 ; (snake1.start + 0)
;  82, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10c6 : 8d 03 2a STA $2a03 ; (snake1.end + 0)
;  83, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10c9 : 8d 04 2a STA $2a04 ; (snake1.length + 0)
;  84, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10cc : 8d 05 2a STA $2a05 ; (snake1.grow + 0)
;  80, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10cf : a9 01 __ LDA #$01
10d1 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
;  86, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10d4 : a9 ff __ LDA #$ff
10d6 : d0 2f __ BNE $1107 ; (snake_reset.l10 + 0)
.s5:
;  93, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10d8 : c9 02 __ CMP #$02
10da : d0 2a __ BNE $1106 ; (snake_reset.s3 + 0)
.s6:
;  94, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10dc : a9 00 __ LDA #$00
; 100, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10de : 85 1b __ STA ACCU + 0 
;  94, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10e0 : 8d 06 2a STA $2a06 ; (snake2.status + 0)
;  96, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10e3 : 8d 08 2c STA $2c08 ; (snake2.start + 0)
;  97, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10e6 : 8d 09 2c STA $2c09 ; (snake2.end + 0)
;  98, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10e9 : 8d 0a 2c STA $2c0a ; (snake2.length + 0)
;  99, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ec : 8d 0b 2c STA $2c0b ; (snake2.grow + 0)
;  95, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ef : a9 01 __ LDA #$01
10f1 : 8d 07 2a STA $2a07 ; (snake2.direction + 0)
; 101, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10f4 : a9 ff __ LDA #$ff
10f6 : d0 02 __ BNE $10fa ; (snake_reset.l7 + 0)
.s8:
; 100, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10f8 : e6 1b __ INC ACCU + 0 
.l7:
; 101, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10fa : a6 1b __ LDX ACCU + 0 
10fc : 9d 08 2a STA $2a08,x ; (snake2.x[0] + 0)
; 102, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ff : 9d 08 2b STA $2b08,x ; (snake2.y[0] + 0)
; 103, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1102 : c5 1b __ CMP ACCU + 0 
1104 : d0 f2 __ BNE $10f8 ; (snake_reset.s8 + 0)
.s3:
;  91, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1106 : 60 __ __ RTS
.l10:
;  86, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1107 : a6 1b __ LDX ACCU + 0 
1109 : 9d 02 28 STA $2802,x ; (snake1.x[0] + 0)
;  87, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
110c : 9d 02 29 STA $2902,x ; (snake1.y[0] + 0)
;  88, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
110f : c5 1b __ CMP ACCU + 0 
1111 : f0 f3 __ BEQ $1106 ; (snake_reset.s3 + 0)
.s11:
;  85, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1113 : e6 1b __ INC ACCU + 0 
1115 : 4c 07 11 JMP $1107 ; (snake_reset.l10 + 0)
--------------------------------------------------------------------
snake_add: ; snake_add(u8,u8,u8)->void
; 111, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 112, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1118 : a5 0d __ LDA P0 ; (s + 0)
111a : c9 01 __ CMP #$01
111c : f0 27 __ BEQ $1145 ; (snake_add.s10 + 0)
.s5:
; 122, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
111e : c9 02 __ CMP #$02
1120 : d0 22 __ BNE $1144 ; (snake_add.s3 + 0)
.s6:
; 123, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1122 : ad 0a 2c LDA $2c0a ; (snake2.length + 0)
1125 : c9 f0 __ CMP #$f0
1127 : b0 1b __ BCS $1144 ; (snake_add.s3 + 0)
.s7:
1129 : 85 1b __ STA ACCU + 0 
; 125, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
112b : aa __ __ TAX
112c : f0 03 __ BEQ $1131 ; (snake_add.s8 + 0)
.s9:
; 126, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
112e : ee 08 2c INC $2c08 ; (snake2.start + 0)
.s8:
; 127, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1131 : a5 0e __ LDA P1 ; (x + 0)
1133 : ae 08 2c LDX $2c08 ; (snake2.start + 0)
1136 : 9d 08 2a STA $2a08,x ; (snake2.x[0] + 0)
; 128, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1139 : a5 0f __ LDA P2 ; (y + 0)
113b : 9d 08 2b STA $2b08,x ; (snake2.y[0] + 0)
; 129, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
113e : a6 1b __ LDX ACCU + 0 
1140 : e8 __ __ INX
1141 : 8e 0a 2c STX $2c0a ; (snake2.length + 0)
.s3:
; 114, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1144 : 60 __ __ RTS
.s10:
; 113, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1145 : ad 04 2a LDA $2a04 ; (snake1.length + 0)
1148 : c9 f0 __ CMP #$f0
114a : b0 f8 __ BCS $1144 ; (snake_add.s3 + 0)
.s11:
114c : 85 1b __ STA ACCU + 0 
; 115, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
114e : aa __ __ TAX
114f : f0 03 __ BEQ $1154 ; (snake_add.s12 + 0)
.s13:
; 116, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1151 : ee 02 2a INC $2a02 ; (snake1.start + 0)
.s12:
; 117, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1154 : a5 0e __ LDA P1 ; (x + 0)
1156 : ae 02 2a LDX $2a02 ; (snake1.start + 0)
1159 : 9d 02 28 STA $2802,x ; (snake1.x[0] + 0)
; 118, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
115c : a5 0f __ LDA P2 ; (y + 0)
115e : 9d 02 29 STA $2902,x ; (snake1.y[0] + 0)
; 119, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1161 : a6 1b __ LDX ACCU + 0 
1163 : e8 __ __ INX
1164 : 8e 04 2a STX $2a04 ; (snake1.length + 0)
1167 : 60 __ __ RTS
--------------------------------------------------------------------
snake_draw_head: ; snake_draw_head(u8)->void
; 146, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 147, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1168 : a5 10 __ LDA P3 ; (s + 0)
116a : c9 01 __ CMP #$01
116c : d0 48 __ BNE $11b6 ; (snake_draw_head.s5 + 0)
.s7:
; 148, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
116e : ae 02 2a LDX $2a02 ; (snake1.start + 0)
1171 : 86 44 __ STX T1 + 0 
1173 : a9 57 __ LDA #$57
1175 : 85 0f __ STA P2 
1177 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
117a : 85 45 __ STA T2 + 0 
117c : 85 0d __ STA P0 
117e : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
1181 : 85 43 __ STA T0 + 0 
1183 : 85 0e __ STA P1 
1185 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 149, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1188 : a5 45 __ LDA T2 + 0 
118a : 85 0d __ STA P0 
118c : a5 43 __ LDA T0 + 0 
118e : 85 0e __ STA P1 
1190 : a9 0d __ LDA #$0d
1192 : 85 0f __ STA P2 
1194 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 150, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1197 : a5 44 __ LDA T1 + 0 
1199 : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
119c : aa __ __ TAX
; 151, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
119d : a9 27 __ LDA #$27
119f : 85 0f __ STA P2 
11a1 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
11a4 : 85 44 __ STA T1 + 0 
11a6 : 85 0d __ STA P0 
11a8 : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
11ab : 85 43 __ STA T0 + 0 
11ad : 85 0e __ STA P1 
11af : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 152, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11b2 : a9 0d __ LDA #$0d
; 153, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11b4 : d0 4b __ BNE $1201 ; (snake_draw_head.s8 + 0)
.s5:
; 155, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11b6 : c9 02 __ CMP #$02
11b8 : f0 01 __ BEQ $11bb ; (snake_draw_head.s6 + 0)
.s3:
; 163, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11ba : 60 __ __ RTS
.s6:
; 156, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11bb : ae 08 2c LDX $2c08 ; (snake2.start + 0)
11be : 86 44 __ STX T1 + 0 
11c0 : a9 57 __ LDA #$57
11c2 : 85 0f __ STA P2 
11c4 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
11c7 : 85 45 __ STA T2 + 0 
11c9 : 85 0d __ STA P0 
11cb : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
11ce : 85 43 __ STA T0 + 0 
11d0 : 85 0e __ STA P1 
11d2 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 157, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11d5 : a5 45 __ LDA T2 + 0 
11d7 : 85 0d __ STA P0 
11d9 : a5 43 __ LDA T0 + 0 
11db : 85 0e __ STA P1 
11dd : a9 0e __ LDA #$0e
11df : 85 0f __ STA P2 
11e1 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 158, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11e4 : a5 44 __ LDA T1 + 0 
11e6 : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
11e9 : aa __ __ TAX
; 159, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11ea : a9 27 __ LDA #$27
11ec : 85 0f __ STA P2 
11ee : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
11f1 : 85 44 __ STA T1 + 0 
11f3 : 85 0d __ STA P0 
11f5 : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
11f8 : 85 43 __ STA T0 + 0 
11fa : 85 0e __ STA P1 
11fc : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 160, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11ff : a9 0e __ LDA #$0e
.s8:
; 152, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1201 : 85 0f __ STA P2 
1203 : a5 44 __ LDA T1 + 0 
1205 : 85 0d __ STA P0 
1207 : a5 43 __ LDA T0 + 0 
1209 : 85 0e __ STA P1 
120b : 4c 00 10 JMP $1000 ; (gfx_clr_set_xy.s4 + 0)
--------------------------------------------------------------------
snake_draw_body: ; snake_draw_body(u8)->void
; 196, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 197, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
120e : a5 10 __ LDA P3 ; (s + 0)
1210 : c9 01 __ CMP #$01
1212 : f0 3f __ BEQ $1253 ; (snake_draw_body.s7 + 0)
.s5:
; 207, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1214 : c9 02 __ CMP #$02
1216 : d0 3a __ BNE $1252 ; (snake_draw_body.s3 + 0)
.s6:
; 208, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1218 : ad 08 2c LDA $2c08 ; (snake2.start + 0)
121b : e9 02 __ SBC #$02
121d : 85 44 __ STA T1 + 0 
; 209, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
121f : aa __ __ TAX
.l9:
1220 : a9 27 __ LDA #$27
1222 : 85 0f __ STA P2 
1224 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
1227 : 85 45 __ STA T2 + 0 
1229 : 85 0d __ STA P0 
122b : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
122e : 85 43 __ STA T0 + 0 
1230 : 85 0e __ STA P1 
1232 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 210, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1235 : a5 45 __ LDA T2 + 0 
1237 : 85 0d __ STA P0 
1239 : a5 43 __ LDA T0 + 0 
123b : 85 0e __ STA P1 
123d : a9 0e __ LDA #$0e
123f : 85 0f __ STA P2 
1241 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 212, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1244 : ae 09 2c LDX $2c09 ; (snake2.end + 0)
1247 : e8 __ __ INX
1248 : 86 43 __ STX T0 + 0 
; 211, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
124a : c6 44 __ DEC T1 + 0 
; 212, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
124c : a6 44 __ LDX T1 + 0 
124e : e4 43 __ CPX T0 + 0 
1250 : d0 ce __ BNE $1220 ; (snake_draw_body.l9 + 0)
.s3:
; 205, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1252 : 60 __ __ RTS
.s7:
; 198, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1253 : ad 02 2a LDA $2a02 ; (snake1.start + 0)
1256 : e9 02 __ SBC #$02
1258 : 85 44 __ STA T1 + 0 
; 199, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
125a : aa __ __ TAX
.l8:
125b : a9 27 __ LDA #$27
125d : 85 0f __ STA P2 
125f : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
1262 : 85 45 __ STA T2 + 0 
1264 : 85 0d __ STA P0 
1266 : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
1269 : 85 43 __ STA T0 + 0 
126b : 85 0e __ STA P1 
126d : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 200, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1270 : a5 45 __ LDA T2 + 0 
1272 : 85 0d __ STA P0 
1274 : a5 43 __ LDA T0 + 0 
1276 : 85 0e __ STA P1 
1278 : a9 0d __ LDA #$0d
127a : 85 0f __ STA P2 
127c : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 202, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
127f : ae 03 2a LDX $2a03 ; (snake1.end + 0)
1282 : e8 __ __ INX
1283 : 86 43 __ STX T0 + 0 
; 201, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1285 : c6 44 __ DEC T1 + 0 
; 202, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1287 : a6 44 __ LDX T1 + 0 
1289 : e4 43 __ CPX T0 + 0 
128b : d0 ce __ BNE $125b ; (snake_draw_body.l8 + 0)
128d : 60 __ __ RTS
--------------------------------------------------------------------
snake_draw_tail: ; snake_draw_tail(u8)->void
; 166, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 167, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
128e : a5 10 __ LDA P3 ; (s + 0)
1290 : c9 01 __ CMP #$01
1292 : d0 03 __ BNE $1297 ; (snake_draw_tail.s5 + 0)
1294 : 4c 1e 13 JMP $131e ; (snake_draw_tail.s9 + 0)
.s5:
; 180, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1297 : c9 02 __ CMP #$02
1299 : f0 01 __ BEQ $129c ; (snake_draw_tail.s6 + 0)
129b : 60 __ __ RTS
.s6:
; 181, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
129c : ae 09 2c LDX $2c09 ; (snake2.end + 0)
129f : 86 44 __ STX T1 + 0 
12a1 : a9 5e __ LDA #$5e
12a3 : 85 0f __ STA P2 
12a5 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
12a8 : 85 45 __ STA T2 + 0 
12aa : 85 0d __ STA P0 
12ac : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
12af : 85 43 __ STA T0 + 0 
12b1 : 85 0e __ STA P1 
12b3 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 182, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12b6 : a5 45 __ LDA T2 + 0 
12b8 : 85 0d __ STA P0 
12ba : a5 43 __ LDA T0 + 0 
12bc : 85 0e __ STA P1 
12be : a9 0e __ LDA #$0e
12c0 : 85 0f __ STA P2 
12c2 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 183, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12c5 : a5 44 __ LDA T1 + 0 
12c7 : 20 ef 0b JSR $0bef ; (inc8.s4 + 0)
12ca : aa __ __ TAX
; 184, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12cb : a9 51 __ LDA #$51
12cd : 85 0f __ STA P2 
12cf : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
12d2 : 85 45 __ STA T2 + 0 
12d4 : 85 0d __ STA P0 
12d6 : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
12d9 : 85 43 __ STA T0 + 0 
12db : 85 0e __ STA P1 
12dd : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 185, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12e0 : a5 45 __ LDA T2 + 0 
12e2 : 85 0d __ STA P0 
12e4 : a5 43 __ LDA T0 + 0 
12e6 : 85 0e __ STA P1 
12e8 : a9 0e __ LDA #$0e
12ea : 85 0f __ STA P2 
12ec : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 186, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12ef : a5 44 __ LDA T1 + 0 
12f1 : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
; 187, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12f4 : aa __ __ TAX
12f5 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
12f8 : c9 ff __ CMP #$ff
12fa : f0 21 __ BEQ $131d ; (snake_draw_tail.s3 + 0)
.s7:
12fc : 85 45 __ STA T2 + 0 
; 188, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12fe : 85 0d __ STA P0 
1300 : a9 20 __ LDA #$20
1302 : 85 0f __ STA P2 
1304 : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
1307 : 85 43 __ STA T0 + 0 
1309 : 85 0e __ STA P1 
130b : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 189, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
130e : a9 0e __ LDA #$0e
.s8:
; 176, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1310 : 85 0f __ STA P2 
1312 : a5 45 __ LDA T2 + 0 
1314 : 85 0d __ STA P0 
1316 : a5 43 __ LDA T0 + 0 
1318 : 85 0e __ STA P1 
; 189, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
131a : 4c 00 10 JMP $1000 ; (gfx_clr_set_xy.s4 + 0)
.s3:
; 178, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
131d : 60 __ __ RTS
.s9:
; 168, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
131e : ae 03 2a LDX $2a03 ; (snake1.end + 0)
1321 : 86 44 __ STX T1 + 0 
1323 : a9 5e __ LDA #$5e
1325 : 85 0f __ STA P2 
1327 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
132a : 85 45 __ STA T2 + 0 
132c : 85 0d __ STA P0 
132e : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
1331 : 85 43 __ STA T0 + 0 
1333 : 85 0e __ STA P1 
1335 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 169, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1338 : a5 45 __ LDA T2 + 0 
133a : 85 0d __ STA P0 
133c : a5 43 __ LDA T0 + 0 
133e : 85 0e __ STA P1 
1340 : a9 0d __ LDA #$0d
1342 : 85 0f __ STA P2 
1344 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 170, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1347 : a5 44 __ LDA T1 + 0 
1349 : 20 ef 0b JSR $0bef ; (inc8.s4 + 0)
134c : aa __ __ TAX
; 171, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
134d : a9 51 __ LDA #$51
134f : 85 0f __ STA P2 
1351 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
1354 : 85 45 __ STA T2 + 0 
1356 : 85 0d __ STA P0 
1358 : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
135b : 85 43 __ STA T0 + 0 
135d : 85 0e __ STA P1 
135f : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 172, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1362 : a5 45 __ LDA T2 + 0 
1364 : 85 0d __ STA P0 
1366 : a5 43 __ LDA T0 + 0 
1368 : 85 0e __ STA P1 
136a : a9 0d __ LDA #$0d
136c : 85 0f __ STA P2 
136e : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 173, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1371 : a5 44 __ LDA T1 + 0 
1373 : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
; 174, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1376 : aa __ __ TAX
1377 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
137a : c9 ff __ CMP #$ff
137c : f0 9f __ BEQ $131d ; (snake_draw_tail.s3 + 0)
.s10:
137e : 85 45 __ STA T2 + 0 
; 175, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1380 : 85 0d __ STA P0 
1382 : a9 20 __ LDA #$20
1384 : 85 0f __ STA P2 
1386 : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
1389 : 85 43 __ STA T0 + 0 
138b : 85 0e __ STA P1 
138d : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 176, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1390 : a9 0d __ LDA #$0d
1392 : 4c 10 13 JMP $1310 ; (snake_draw_tail.s8 + 0)
--------------------------------------------------------------------
snake_control: ; snake_control(u8)->void
; 387, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 388, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1395 : c9 01 __ CMP #$01
1397 : f0 49 __ BEQ $13e2 ; (snake_control.s18 + 0)
.s5:
; 402, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1399 : c9 02 __ CMP #$02
139b : d0 36 __ BNE $13d3 ; (snake_control.s3 + 0)
.s6:
; 403, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
139d : ad 01 dc LDA $dc01 
13a0 : 49 ff __ EOR #$ff
13a2 : a8 __ __ TAY
; 404, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13a3 : 29 04 __ AND #$04
13a5 : f0 0b __ BEQ $13b2 ; (snake_control.s7 + 0)
.s16:
13a7 : ae 07 2a LDX $2a07 ; (snake2.direction + 0)
13aa : ca __ __ DEX
13ab : f0 05 __ BEQ $13b2 ; (snake_control.s7 + 0)
.s17:
; 405, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13ad : a9 03 __ LDA #$03
13af : 8d 07 2a STA $2a07 ; (snake2.direction + 0)
.s7:
; 406, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13b2 : 98 __ __ TYA
13b3 : 29 08 __ AND #$08
13b5 : f0 0c __ BEQ $13c3 ; (snake_control.s8 + 0)
.s14:
13b7 : ad 07 2a LDA $2a07 ; (snake2.direction + 0)
13ba : c9 03 __ CMP #$03
13bc : f0 05 __ BEQ $13c3 ; (snake_control.s8 + 0)
.s15:
; 407, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13be : a9 01 __ LDA #$01
13c0 : 8d 07 2a STA $2a07 ; (snake2.direction + 0)
.s8:
; 408, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13c3 : 98 __ __ TYA
13c4 : 4a __ __ LSR
13c5 : 90 0d __ BCC $13d4 ; (snake_control.s9 + 0)
.s12:
13c7 : ad 07 2a LDA $2a07 ; (snake2.direction + 0)
13ca : c9 02 __ CMP #$02
13cc : f0 06 __ BEQ $13d4 ; (snake_control.s9 + 0)
.s13:
; 409, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13ce : a9 00 __ LDA #$00
.s31:
; 411, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13d0 : 8d 07 2a STA $2a07 ; (snake2.direction + 0)
.s3:
; 400, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13d3 : 60 __ __ RTS
.s9:
; 410, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13d4 : 98 __ __ TYA
13d5 : 29 02 __ AND #$02
13d7 : f0 fa __ BEQ $13d3 ; (snake_control.s3 + 0)
.s10:
13d9 : ad 07 2a LDA $2a07 ; (snake2.direction + 0)
13dc : f0 f5 __ BEQ $13d3 ; (snake_control.s3 + 0)
.s11:
; 411, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13de : a9 02 __ LDA #$02
13e0 : d0 ee __ BNE $13d0 ; (snake_control.s31 + 0)
.s18:
; 389, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13e2 : ad 00 dc LDA $dc00 
13e5 : 49 ff __ EOR #$ff
13e7 : a8 __ __ TAY
; 390, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13e8 : 29 04 __ AND #$04
13ea : f0 0b __ BEQ $13f7 ; (snake_control.s19 + 0)
.s28:
13ec : ae 01 28 LDX $2801 ; (snake1.direction + 0)
13ef : ca __ __ DEX
13f0 : f0 05 __ BEQ $13f7 ; (snake_control.s19 + 0)
.s29:
; 391, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13f2 : a9 03 __ LDA #$03
13f4 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
.s19:
; 392, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13f7 : 98 __ __ TYA
13f8 : 29 08 __ AND #$08
13fa : f0 0c __ BEQ $1408 ; (snake_control.s20 + 0)
.s26:
13fc : ad 01 28 LDA $2801 ; (snake1.direction + 0)
13ff : c9 03 __ CMP #$03
1401 : f0 05 __ BEQ $1408 ; (snake_control.s20 + 0)
.s27:
; 393, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1403 : a9 01 __ LDA #$01
1405 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
.s20:
; 394, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1408 : 98 __ __ TYA
1409 : 4a __ __ LSR
140a : 90 07 __ BCC $1413 ; (snake_control.s21 + 0)
.s24:
140c : ad 01 28 LDA $2801 ; (snake1.direction + 0)
140f : c9 02 __ CMP #$02
1411 : d0 10 __ BNE $1423 ; (snake_control.s25 + 0)
.s21:
; 396, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1413 : 98 __ __ TYA
1414 : 29 02 __ AND #$02
1416 : f0 bb __ BEQ $13d3 ; (snake_control.s3 + 0)
.s22:
1418 : ad 01 28 LDA $2801 ; (snake1.direction + 0)
141b : f0 b6 __ BEQ $13d3 ; (snake_control.s3 + 0)
.s23:
; 397, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
141d : a9 02 __ LDA #$02
.s30:
141f : 8d 01 28 STA $2801 ; (snake1.direction + 0)
1422 : 60 __ __ RTS
.s25:
; 395, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1423 : a9 00 __ LDA #$00
1425 : f0 f8 __ BEQ $141f ; (snake_control.s30 + 0)
--------------------------------------------------------------------
snake_advance: ; snake_advance(u8)->void
; 247, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 249, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1427 : a5 11 __ LDA P4 ; (s + 0)
1429 : c9 01 __ CMP #$01
142b : d0 03 __ BNE $1430 ; (snake_advance.s5 + 0)
142d : 4c d0 14 JMP $14d0 ; (snake_advance.s20 + 0)
.s5:
; 283, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1430 : c9 02 __ CMP #$02
1432 : f0 03 __ BEQ $1437 ; (snake_advance.s7 + 0)
1434 : 4c c4 14 JMP $14c4 ; (snake_advance.s6 + 0)
.s7:
; 284, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1437 : ad 06 2a LDA $2a06 ; (snake2.status + 0)
143a : d0 44 __ BNE $1480 ; (snake_advance.s3 + 0)
.s8:
; 286, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
143c : ae 07 2a LDX $2a07 ; (snake2.direction + 0)
143f : bd 35 16 LDA $1635,x ; (ddx[0] + 0)
1442 : ac 08 2c LDY $2c08 ; (snake2.start + 0)
1445 : 84 48 __ STY T5 + 0 
1447 : 18 __ __ CLC
1448 : 79 08 2a ADC $2a08,y ; (snake2.x[0] + 0)
144b : 85 47 __ STA T3 + 0 
; 288, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
144d : 85 0d __ STA P0 
; 287, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
144f : bd 39 16 LDA $1639,x ; (ddy[0] + 0)
1452 : 18 __ __ CLC
1453 : 79 08 2b ADC $2b08,y ; (snake2.y[0] + 0)
1456 : 85 46 __ STA T1 + 0 
; 288, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1458 : 85 0e __ STA P1 
145a : 20 5e 15 JSR $155e ; (gfx_scr_get_xy.s4 + 0)
; 289, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
145d : c9 20 __ CMP #$20
145f : f0 3a __ BEQ $149b ; (snake_advance.s9 + 0)
.s13:
; 290, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1461 : c9 53 __ CMP #$53
1463 : d0 17 __ BNE $147c ; (snake_advance.s14 + 0)
.s19:
; 291, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1465 : a9 02 __ LDA #$02
1467 : 8d 0b 2c STA $2c0b ; (snake2.grow + 0)
; 292, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
146a : a5 47 __ LDA T3 + 0 
146c : 85 0d __ STA P0 
146e : a5 46 __ LDA T1 + 0 
1470 : 85 0e __ STA P1 
1472 : a9 20 __ LDA #$20
1474 : 85 0f __ STA P2 
1476 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
1479 : 4c 9b 14 JMP $149b ; (snake_advance.s9 + 0)
.s14:
; 294, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
147c : c9 56 __ CMP #$56
147e : f0 01 __ BEQ $1481 ; (snake_advance.s15 + 0)
.s3:
; 319, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1480 : 60 __ __ RTS
.s15:
; 297, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1481 : a2 02 __ LDX #$02
1483 : 86 10 __ STX P3 
; 295, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1485 : ad 0a 2c LDA $2c0a ; (snake2.length + 0)
1488 : c9 06 __ CMP #$06
148a : b0 06 __ BCS $1492 ; (snake_advance.s16 + 0)
.s17:
; 296, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
148c : 8e 06 2a STX $2a06 ; (snake2.status + 0)
.s18:
; 297, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
148f : 4c 7a 15 JMP $157a ; (snake_set_dead_color.s4 + 0)
.s16:
; 299, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1492 : ce 0a 2c DEC $2c0a ; (snake2.length + 0)
; 300, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1495 : ee 09 2c INC $2c09 ; (snake2.end + 0)
.s32:
; 318, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1498 : 4c 8e 12 JMP $128e ; (snake_draw_tail.s4 + 0)
.s9:
; 307, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
149b : a6 48 __ LDX T5 + 0 
149d : e8 __ __ INX
149e : 8e 08 2c STX $2c08 ; (snake2.start + 0)
; 308, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14a1 : a5 47 __ LDA T3 + 0 
14a3 : 9d 08 2a STA $2a08,x ; (snake2.x[0] + 0)
; 309, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14a6 : a5 46 __ LDA T1 + 0 
14a8 : 9d 08 2b STA $2b08,x ; (snake2.y[0] + 0)
; 310, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14ab : ad 0b 2c LDA $2c0b ; (snake2.grow + 0)
14ae : f0 0f __ BEQ $14bf ; (snake_advance.s10 + 0)
.s11:
14b0 : ad 0a 2c LDA $2c0a ; (snake2.length + 0)
14b3 : c9 f0 __ CMP #$f0
14b5 : b0 08 __ BCS $14bf ; (snake_advance.s10 + 0)
.s12:
; 311, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14b7 : ce 0b 2c DEC $2c0b ; (snake2.grow + 0)
; 312, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14ba : ee 0a 2c INC $2c0a ; (snake2.length + 0)
14bd : 90 03 __ BCC $14c2 ; (snake_advance.s34 + 0)
.s10:
; 314, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14bf : ee 09 2c INC $2c09 ; (snake2.end + 0)
.s34:
; 317, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14c2 : a9 02 __ LDA #$02
.s6:
14c4 : 85 10 __ STA P3 
14c6 : 20 68 11 JSR $1168 ; (snake_draw_head.s4 + 0)
; 318, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14c9 : a5 11 __ LDA P4 ; (s + 0)
14cb : 85 10 __ STA P3 
; 319, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14cd : 4c 98 14 JMP $1498 ; (snake_advance.s32 + 0)
.s20:
; 250, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14d0 : ad 00 28 LDA $2800 ; (snake1.status + 0)
14d3 : d0 ab __ BNE $1480 ; (snake_advance.s3 + 0)
.s21:
; 252, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14d5 : ae 01 28 LDX $2801 ; (snake1.direction + 0)
14d8 : bd 35 16 LDA $1635,x ; (ddx[0] + 0)
14db : ac 02 2a LDY $2a02 ; (snake1.start + 0)
14de : 84 48 __ STY T5 + 0 
14e0 : 18 __ __ CLC
14e1 : 79 02 28 ADC $2802,y ; (snake1.x[0] + 0)
14e4 : 85 47 __ STA T3 + 0 
; 254, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14e6 : 85 0d __ STA P0 
; 253, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14e8 : bd 39 16 LDA $1639,x ; (ddy[0] + 0)
14eb : 18 __ __ CLC
14ec : 79 02 29 ADC $2902,y ; (snake1.y[0] + 0)
14ef : 85 46 __ STA T1 + 0 
; 254, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14f1 : 85 0e __ STA P1 
14f3 : 20 5e 15 JSR $155e ; (gfx_scr_get_xy.s4 + 0)
; 255, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14f6 : c9 20 __ CMP #$20
14f8 : f0 38 __ BEQ $1532 ; (snake_advance.s22 + 0)
.s26:
; 256, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14fa : c9 53 __ CMP #$53
14fc : f0 20 __ BEQ $151e ; (snake_advance.s31 + 0)
.s27:
; 260, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14fe : c9 56 __ CMP #$56
1500 : f0 01 __ BEQ $1503 ; (snake_advance.s28 + 0)
1502 : 60 __ __ RTS
.s28:
; 261, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1503 : ad 04 2a LDA $2a04 ; (snake1.length + 0)
1506 : c9 06 __ CMP #$06
; 263, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1508 : a9 01 __ LDA #$01
150a : 85 10 __ STA P3 
; 261, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
150c : 90 08 __ BCC $1516 ; (snake_advance.s30 + 0)
.s29:
; 265, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
150e : ce 04 2a DEC $2a04 ; (snake1.length + 0)
; 266, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1511 : ee 03 2a INC $2a03 ; (snake1.end + 0)
1514 : b0 82 __ BCS $1498 ; (snake_advance.s32 + 0)
.s30:
; 262, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1516 : a9 02 __ LDA #$02
1518 : 8d 00 28 STA $2800 ; (snake1.status + 0)
151b : 4c 8f 14 JMP $148f ; (snake_advance.s18 + 0)
.s31:
; 257, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
151e : a9 02 __ LDA #$02
1520 : 8d 05 2a STA $2a05 ; (snake1.grow + 0)
; 258, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1523 : a5 47 __ LDA T3 + 0 
1525 : 85 0d __ STA P0 
1527 : a5 46 __ LDA T1 + 0 
1529 : 85 0e __ STA P1 
152b : a9 20 __ LDA #$20
152d : 85 0f __ STA P2 
152f : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
.s22:
; 273, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1532 : a6 48 __ LDX T5 + 0 
1534 : e8 __ __ INX
1535 : 8e 02 2a STX $2a02 ; (snake1.start + 0)
; 274, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1538 : a5 47 __ LDA T3 + 0 
153a : 9d 02 28 STA $2802,x ; (snake1.x[0] + 0)
; 275, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
153d : a5 46 __ LDA T1 + 0 
153f : 9d 02 29 STA $2902,x ; (snake1.y[0] + 0)
; 276, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1542 : ad 05 2a LDA $2a05 ; (snake1.grow + 0)
1545 : f0 0f __ BEQ $1556 ; (snake_advance.s23 + 0)
.s24:
1547 : ad 04 2a LDA $2a04 ; (snake1.length + 0)
154a : c9 f0 __ CMP #$f0
154c : b0 08 __ BCS $1556 ; (snake_advance.s23 + 0)
.s25:
; 277, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
154e : ce 05 2a DEC $2a05 ; (snake1.grow + 0)
; 278, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1551 : ee 04 2a INC $2a04 ; (snake1.length + 0)
1554 : 90 03 __ BCC $1559 ; (snake_advance.s33 + 0)
.s23:
; 280, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1556 : ee 03 2a INC $2a03 ; (snake1.end + 0)
.s33:
; 317, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1559 : a9 01 __ LDA #$01
155b : 4c c4 14 JMP $14c4 ; (snake_advance.s6 + 0)
--------------------------------------------------------------------
gfx_scr_get_xy: ; gfx_scr_get_xy(u8,u8)->u8
;  34, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 161, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
155e : a4 0e __ LDY P1 
1560 : b9 d1 15 LDA $15d1,y ; (scr_row_low[0] + 0)
1563 : 8d 6f 15 STA $156f ; (gfx_scr_get_xy.s4 + 17)
1566 : b9 ea 15 LDA $15ea,y ; (scr_row_high[0] + 0)
1569 : 8d 70 15 STA $1570 ; (gfx_scr_get_xy.s4 + 18)
156c : a6 0d __ LDX P0 
156e : bd ff ff LDA $ffff,x 
1571 : 85 1b __ STA ACCU + 0 
1573 : a9 00 __ LDA #$00
1575 : 85 1c __ STA ACCU + 1 
.s3:
1577 : a5 1b __ LDA ACCU + 0 
; 173, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1579 : 60 __ __ RTS
--------------------------------------------------------------------
snake_set_dead_color: ; snake_set_dead_color(u8)->void
; 220, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 221, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
157a : a5 10 __ LDA P3 ; (s + 0)
157c : c9 01 __ CMP #$01
157e : f0 29 __ BEQ $15a9 ; (snake_set_dead_color.s7 + 0)
.s5:
; 230, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1580 : c9 02 __ CMP #$02
1582 : d0 24 __ BNE $15a8 ; (snake_set_dead_color.s3 + 0)
.s6:
; 231, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1584 : ac 08 2c LDY $2c08 ; (snake2.start + 0)
1587 : 84 43 __ STY T2 + 0 
.l9:
; 232, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1589 : b9 08 2a LDA $2a08,y ; (snake2.x[0] + 0)
158c : 85 0d __ STA P0 
158e : a9 0b __ LDA #$0b
1590 : 85 0f __ STA P2 
1592 : b9 08 2b LDA $2b08,y ; (snake2.y[0] + 0)
1595 : 85 0e __ STA P1 
1597 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 234, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
159a : ae 09 2c LDX $2c09 ; (snake2.end + 0)
159d : ca __ __ DEX
159e : 86 1b __ STX ACCU + 0 
; 233, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15a0 : c6 43 __ DEC T2 + 0 
; 234, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15a2 : a4 43 __ LDY T2 + 0 
15a4 : c4 1b __ CPY ACCU + 0 
15a6 : d0 e1 __ BNE $1589 ; (snake_set_dead_color.l9 + 0)
.s3:
; 228, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15a8 : 60 __ __ RTS
.s7:
; 222, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15a9 : ac 02 2a LDY $2a02 ; (snake1.start + 0)
15ac : 84 43 __ STY T2 + 0 
.l8:
; 223, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15ae : b9 02 28 LDA $2802,y ; (snake1.x[0] + 0)
15b1 : 85 0d __ STA P0 
15b3 : a9 0b __ LDA #$0b
15b5 : 85 0f __ STA P2 
15b7 : b9 02 29 LDA $2902,y ; (snake1.y[0] + 0)
15ba : 85 0e __ STA P1 
15bc : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 225, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15bf : ae 03 2a LDX $2a03 ; (snake1.end + 0)
15c2 : ca __ __ DEX
15c3 : 86 1b __ STX ACCU + 0 
; 224, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15c5 : c6 43 __ DEC T2 + 0 
; 225, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
15c7 : a4 43 __ LDY T2 + 0 
15c9 : c4 1b __ CPY ACCU + 0 
15cb : d0 e1 __ BNE $15ae ; (snake_set_dead_color.l8 + 0)
15cd : 60 __ __ RTS
--------------------------------------------------------------------
spentry:
15ce : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
gfx_old_border:
15cf : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
gfx_old_background:
15d0 : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
scr_row_low:
15d1 : __ __ __ BYT 00 28 50 78 a0 c8 f0 18 40 68 90 b8 e0 08 30 58 : .(Px....@h....0X
15e1 : __ __ __ BYT 80 a8 d0 f8 20 48 70 98 c0                      : .... Hp..
--------------------------------------------------------------------
scr_row_high:
15ea : __ __ __ BYT 04 04 04 04 04 04 04 05 05 05 05 05 05 06 06 06 : ................
15fa : __ __ __ BYT 06 06 06 06 07 07 07 07 07                      : .........
--------------------------------------------------------------------
clr_row_low:
1603 : __ __ __ BYT 00 28 50 78 a0 c8 f0 18 40 68 90 b8 e0 08 30 58 : .(Px....@h....0X
1613 : __ __ __ BYT 80 a8 d0 f8 20 48 70 98 c0                      : .... Hp..
--------------------------------------------------------------------
clr_row_high:
161c : __ __ __ BYT d8 d8 d8 d8 d8 d8 d8 d9 d9 d9 d9 d9 d9 da da da : ................
162c : __ __ __ BYT da da da da db db db db db                      : .........
--------------------------------------------------------------------
ddx:
1635 : __ __ __ BYT 00 01 00 ff                                     : ....
--------------------------------------------------------------------
ddy:
1639 : __ __ __ BYT ff 00 01 00                                     : ....
--------------------------------------------------------------------
charset:
2000 : __ __ __ BYT 3c 66 6e 6e 60 62 3c 00 18 3c 66 7e 66 66 66 00 : <fnn`b<..<f~fff.
2010 : __ __ __ BYT 7c 66 66 7c 66 66 7c 00 3c 66 60 60 60 66 3c 00 : |ff|ff|.<f```f<.
2020 : __ __ __ BYT 78 6c 66 66 66 6c 78 00 7e 60 60 78 60 60 7e 00 : xlffflx.~``x``~.
2030 : __ __ __ BYT 7e 60 60 78 60 60 60 00 3c 66 60 6e 66 66 3c 00 : ~``x```.<f`nff<.
2040 : __ __ __ BYT 66 66 66 7e 66 66 66 00 3c 18 18 18 18 18 3c 00 : fff~fff.<.....<.
2050 : __ __ __ BYT 1e 0c 0c 0c 0c 6c 38 00 66 6c 78 70 78 6c 66 00 : .....l8.flxpxlf.
2060 : __ __ __ BYT 60 60 60 60 60 60 7e 00 63 77 7f 6b 63 63 63 00 : ``````~.cw.kccc.
2070 : __ __ __ BYT 66 76 7e 7e 6e 66 66 00 3c 66 66 66 66 66 3c 00 : fv~~nff.<fffff<.
2080 : __ __ __ BYT 7c 66 66 7c 60 60 60 00 3c 66 66 66 66 3c 0e 00 : |ff|```.<ffff<..
2090 : __ __ __ BYT 7c 66 66 7c 78 6c 66 00 3c 66 60 3c 06 66 3c 00 : |ff|xlf.<f`<.f<.
20a0 : __ __ __ BYT 7e 18 18 18 18 18 18 00 66 66 66 66 66 66 3c 00 : ~.......ffffff<.
20b0 : __ __ __ BYT 66 66 66 66 66 3c 18 00 63 63 63 6b 7f 77 63 00 : fffff<..ccck.wc.
20c0 : __ __ __ BYT 66 66 3c 18 3c 66 66 00 66 66 66 3c 18 18 18 00 : ff<.<ff.fff<....
20d0 : __ __ __ BYT 7e 06 0c 18 30 60 7e 00 3c 30 30 30 30 30 3c 00 : ~...0`~.<00000<.
20e0 : __ __ __ BYT 00 00 00 18 18 00 00 00 3c 0c 0c 0c 0c 0c 3c 00 : ........<.....<.
20f0 : __ __ __ BYT 00 18 3c 7e 18 18 18 18 00 10 30 7f 7f 30 10 00 : ..<~......0..0..
2100 : __ __ __ BYT 00 00 00 00 00 00 00 00 18 18 18 18 00 00 18 00 : ................
2110 : __ __ __ BYT 66 66 66 00 00 00 00 00 66 66 ff 66 ff 66 66 00 : fff.....ff.f.ff.
2120 : __ __ __ BYT 18 3e 60 3c 06 7c 18 00 62 66 0c 18 30 66 46 00 : .>`<.|..bf..0fF.
2130 : __ __ __ BYT 3c 66 3c 38 67 66 3f 00 3c 7e ff ff ff ff 7e 3c : <f<8gf?.<~....~<
2140 : __ __ __ BYT 0c 18 30 30 30 18 0c 00 30 18 0c 0c 0c 18 30 00 : ..000...0.....0.
2150 : __ __ __ BYT 00 66 3c ff 3c 66 00 00 00 18 18 7e 18 18 00 00 : .f<.<f.....~....
2160 : __ __ __ BYT 00 00 00 00 00 18 18 30 00 00 00 7e 00 00 00 00 : .......0...~....
2170 : __ __ __ BYT 00 00 00 00 00 18 18 00 00 03 06 0c 18 30 60 00 : .............0`.
2180 : __ __ __ BYT 3c 66 6e 76 66 66 3c 00 18 18 38 18 18 18 7e 00 : <fnvff<...8...~.
2190 : __ __ __ BYT 3c 66 06 0c 30 60 7e 00 3c 66 06 1c 06 66 3c 00 : <f..0`~.<f...f<.
21a0 : __ __ __ BYT 06 0e 1e 66 7f 06 06 00 7e 60 7c 06 06 66 3c 00 : ...f....~`|..f<.
21b0 : __ __ __ BYT 3c 66 60 7c 66 66 3c 00 7e 66 0c 18 18 18 18 00 : <f`|ff<.~f......
21c0 : __ __ __ BYT 3c 66 66 3c 66 66 3c 00 3c 66 66 3e 06 66 3c 00 : <ff<ff<.<ff>.f<.
21d0 : __ __ __ BYT 00 00 18 00 00 18 00 00 00 00 18 00 00 18 18 30 : ...............0
21e0 : __ __ __ BYT 0e 18 30 60 30 18 0e 00 00 00 7e 00 7e 00 00 00 : ..0`0.....~.~...
21f0 : __ __ __ BYT 70 18 0c 06 0c 18 70 00 3c 66 06 0c 18 00 18 00 : p.....p.<f......
2200 : __ __ __ BYT 00 00 00 ff ff 00 00 00 08 1c 3e 7f 7f 1c 3e 00 : ..........>...>.
2210 : __ __ __ BYT 18 18 18 18 18 18 18 18 00 00 00 ff ff 00 00 00 : ................
2220 : __ __ __ BYT 00 00 ff ff 00 00 00 00 00 ff ff 00 00 00 00 00 : ................
2230 : __ __ __ BYT 00 00 00 00 ff ff 00 00 30 30 30 30 30 30 30 30 : ........00000000
2240 : __ __ __ BYT 0c 0c 0c 0c 0c 0c 0c 0c 00 00 00 e0 f0 38 18 18 : .............8..
2250 : __ __ __ BYT 18 18 1c 0f 07 00 00 00 18 18 38 f0 e0 00 00 00 : ..........8.....
2260 : __ __ __ BYT c0 c0 c0 c0 c0 c0 ff ff c0 e0 70 38 1c 0e 07 03 : ..........p8....
2270 : __ __ __ BYT 03 07 0e 1c 38 70 e0 c0 ff ff c0 c0 c0 c0 c0 c0 : ....8p..........
2280 : __ __ __ BYT ff ff 03 03 03 03 03 03 00 3c 7e 7e 7e 7e 3c 00 : .........<~~~~<.
2290 : __ __ __ BYT 00 00 00 00 00 ff ff 00 36 7f 7f 7f 3e 1c 08 00 : ........6...>...
22a0 : __ __ __ BYT 60 60 60 60 60 60 60 60 00 00 00 07 0f 1c 18 18 : ````````........
22b0 : __ __ __ BYT c3 e7 7e 3c 3c 7e e7 c3 00 3c 7e 66 66 7e 3c 00 : ..~<<~...<~ff~<.
22c0 : __ __ __ BYT 18 18 66 66 18 18 3c 00 06 06 06 06 06 06 06 06 : ..ff..<.........
22d0 : __ __ __ BYT 08 1c 3e 7f 3e 1c 08 00 18 18 18 ff ff 18 18 18 : ..>.>...........
22e0 : __ __ __ BYT c0 c0 30 30 c0 c0 30 30 18 18 18 18 18 18 18 18 : ..00..00........
22f0 : __ __ __ BYT 00 00 18 3c 3c 18 00 00 ff 7f 3f 1f 0f 07 03 01 : ...<<.....?.....
2300 : __ __ __ BYT 00 00 00 00 00 00 00 00 f0 f0 f0 f0 f0 f0 f0 f0 : ................
2310 : __ __ __ BYT 00 00 00 00 ff ff ff ff ff 00 00 00 00 00 00 00 : ................
2320 : __ __ __ BYT 00 00 00 00 00 00 00 ff c0 c0 c0 c0 c0 c0 c0 c0 : ................
2330 : __ __ __ BYT cc cc 33 33 cc cc 33 33 03 03 03 03 03 03 03 03 : ..33..33........
2340 : __ __ __ BYT 00 00 00 00 cc cc 33 33 ff fe fc f8 f0 e0 c0 80 : ......33........
2350 : __ __ __ BYT 03 03 03 03 03 03 03 03 18 18 18 1f 1f 18 18 18 : ................
2360 : __ __ __ BYT 00 00 00 00 0f 0f 0f 0f 18 18 18 1f 1f 00 00 00 : ................
2370 : __ __ __ BYT 00 00 00 f8 f8 18 18 18 00 00 00 00 00 00 ff ff : ................
2380 : __ __ __ BYT 00 00 00 1f 1f 18 18 18 18 18 18 ff ff 00 00 00 : ................
2390 : __ __ __ BYT 00 00 00 ff ff 18 18 18 18 18 18 f8 f8 18 18 18 : ................
23a0 : __ __ __ BYT c0 c0 c0 c0 c0 c0 c0 c0 e0 e0 e0 e0 e0 e0 e0 e0 : ................
23b0 : __ __ __ BYT 07 07 07 07 07 07 07 07 ff ff 00 00 00 00 00 00 : ................
23c0 : __ __ __ BYT ff ff ff 00 00 00 00 00 00 00 00 00 00 ff ff ff : ................
23d0 : __ __ __ BYT 03 03 03 03 03 03 ff ff 00 00 00 00 f0 f0 f0 f0 : ................
23e0 : __ __ __ BYT 0f 0f 0f 0f 00 00 00 00 18 18 18 f8 f8 00 00 00 : ................
23f0 : __ __ __ BYT f0 f0 f0 f0 00 00 00 00 f0 f0 f0 f0 0f 0f 0f 0f : ................
2400 : __ __ __ BYT c3 99 91 91 9f 99 c3 ff e7 c3 99 81 99 99 99 ff : ................
2410 : __ __ __ BYT 83 99 99 83 99 99 83 ff c3 99 9f 9f 9f 99 c3 ff : ................
2420 : __ __ __ BYT 87 93 99 99 99 93 87 ff 81 9f 9f 87 9f 9f 81 ff : ................
2430 : __ __ __ BYT 81 9f 9f 87 9f 9f 9f ff c3 99 9f 91 99 99 c3 ff : ................
2440 : __ __ __ BYT 99 99 99 81 99 99 99 ff c3 e7 e7 e7 e7 e7 c3 ff : ................
2450 : __ __ __ BYT e1 f3 f3 f3 f3 93 c7 ff 99 93 87 8f 87 93 99 ff : ................
2460 : __ __ __ BYT 9f 9f 9f 9f 9f 9f 81 ff 9c 88 80 94 9c 9c 9c ff : ................
2470 : __ __ __ BYT 99 89 81 81 91 99 99 ff c3 99 99 99 99 99 c3 ff : ................
2480 : __ __ __ BYT 83 99 99 83 9f 9f 9f ff c3 99 99 99 99 c3 f1 ff : ................
2490 : __ __ __ BYT 83 99 99 83 87 93 99 ff c3 99 9f c3 f9 99 c3 ff : ................
24a0 : __ __ __ BYT 81 e7 e7 e7 e7 e7 e7 ff 99 99 99 99 99 99 c3 ff : ................
24b0 : __ __ __ BYT 99 99 99 99 99 c3 e7 ff 9c 9c 9c 94 80 88 9c ff : ................
24c0 : __ __ __ BYT 99 99 c3 e7 c3 99 99 ff 99 99 99 c3 e7 e7 e7 ff : ................
24d0 : __ __ __ BYT 81 f9 f3 e7 cf 9f 81 ff c3 cf cf cf cf cf c3 ff : ................
24e0 : __ __ __ BYT f3 ed cf 83 cf 9d 03 ff c3 f3 f3 f3 f3 f3 c3 ff : ................
24f0 : __ __ __ BYT ff e7 c3 81 e7 e7 e7 e7 ff ef cf 80 80 cf ef ff : ................
2500 : __ __ __ BYT ff ff ff ff ff ff ff ff e7 e7 e7 e7 ff ff e7 ff : ................
2510 : __ __ __ BYT 99 99 99 ff ff ff ff ff 99 99 00 99 00 99 99 ff : ................
2520 : __ __ __ BYT e7 c1 9f c3 f9 83 e7 ff 9d 99 f3 e7 cf 99 b9 ff : ................
2530 : __ __ __ BYT c3 99 c3 c7 98 99 c0 ff f9 f3 e7 ff ff ff ff ff : ................
2540 : __ __ __ BYT f3 e7 cf cf cf e7 f3 ff cf e7 f3 f3 f3 e7 cf ff : ................
2550 : __ __ __ BYT ff 99 c3 00 c3 99 ff ff ff e7 e7 81 e7 e7 ff ff : ................
2560 : __ __ __ BYT ff ff ff ff ff e7 e7 cf ff ff ff 81 ff ff ff ff : ................
2570 : __ __ __ BYT ff ff ff ff ff e7 e7 ff ff fc f9 f3 e7 cf 9f ff : ................
2580 : __ __ __ BYT c3 99 91 89 99 99 c3 ff e7 e7 c7 e7 e7 e7 81 ff : ................
2590 : __ __ __ BYT c3 99 f9 f3 cf 9f 81 ff c3 99 f9 e3 f9 99 c3 ff : ................
25a0 : __ __ __ BYT f9 f1 e1 99 80 f9 f9 ff 81 9f 83 f9 f9 99 c3 ff : ................
25b0 : __ __ __ BYT c3 99 9f 83 99 99 c3 ff 81 99 f3 e7 e7 e7 e7 ff : ................
25c0 : __ __ __ BYT c3 99 99 c3 99 99 c3 ff c3 99 99 c1 f9 99 c3 ff : ................
25d0 : __ __ __ BYT ff ff e7 ff ff e7 ff ff ff ff e7 ff ff e7 e7 cf : ................
25e0 : __ __ __ BYT f1 e7 cf 9f cf e7 f1 ff ff ff 81 ff 81 ff ff ff : ................
25f0 : __ __ __ BYT 8f e7 f3 f9 f3 e7 8f ff c3 99 f9 f3 e7 ff e7 ff : ................
2600 : __ __ __ BYT ff ff ff 00 00 ff ff ff f7 e3 c1 80 80 e3 c1 ff : ................
2610 : __ __ __ BYT e7 e7 e7 e7 e7 e7 e7 e7 ff ff ff 00 00 ff ff ff : ................
2620 : __ __ __ BYT ff ff 00 00 ff ff ff ff ff 00 00 ff ff ff ff ff : ................
2630 : __ __ __ BYT ff ff ff ff 00 00 ff ff cf cf cf cf cf cf cf cf : ................
2640 : __ __ __ BYT f3 f3 f3 f3 f3 f3 f3 f3 ff ff ff 1f 0f c7 e7 e7 : ................
2650 : __ __ __ BYT e7 e7 e3 f0 f8 ff ff ff e7 e7 c7 0f 1f ff ff ff : ................
2660 : __ __ __ BYT 3f 3f 3f 3f 3f 3f 00 00 3f 1f 8f c7 e3 f1 f8 fc : ??????..?.......
2670 : __ __ __ BYT fc f8 f1 e3 c7 8f 1f 3f 00 00 3f 3f 3f 3f 3f 3f : .......?..??????
2680 : __ __ __ BYT 00 00 fc fc fc fc fc fc ff c3 81 81 81 81 c3 ff : ................
2690 : __ __ __ BYT ff ff ff ff ff 00 00 ff c9 80 80 80 c1 e3 f7 ff : ................
26a0 : __ __ __ BYT 9f 9f 9f 9f 9f 9f 9f 9f ff ff ff f8 f0 e3 e7 e7 : ................
26b0 : __ __ __ BYT 3c 18 81 c3 c3 81 18 3c ff c3 81 99 99 81 c3 ff : <......<........
26c0 : __ __ __ BYT e7 e7 99 99 e7 e7 c3 ff f9 f9 f9 f9 f9 f9 f9 f9 : ................
26d0 : __ __ __ BYT f7 e3 c1 80 c1 e3 f7 ff e7 e7 e7 00 00 e7 e7 e7 : ................
26e0 : __ __ __ BYT 3f 3f cf cf 3f 3f cf cf e7 e7 e7 e7 e7 e7 e7 e7 : ??..??..........
26f0 : __ __ __ BYT ff ff fc c1 89 c9 c9 ff 00 80 c0 e0 f0 f8 fc fe : ................
2700 : __ __ __ BYT ff ff ff ff ff ff ff ff 0f 0f 0f 0f 0f 0f 0f 0f : ................
2710 : __ __ __ BYT ff ff ff ff 00 00 00 00 00 ff ff ff ff ff ff ff : ................
2720 : __ __ __ BYT ff ff ff ff ff ff ff 00 3f 3f 3f 3f 3f 3f 3f 3f : ........????????
2730 : __ __ __ BYT 33 33 cc cc 33 33 cc cc fc fc fc fc fc fc fc fc : 33..33..........
2740 : __ __ __ BYT ff ff ff ff 33 33 cc cc 00 01 03 07 0f 1f 3f 7f : ....33........?.
2750 : __ __ __ BYT fc fc fc fc fc fc fc fc e7 e7 e7 e0 e0 e7 e7 e7 : ................
2760 : __ __ __ BYT ff ff ff ff f0 f0 f0 f0 e7 e7 e7 e0 e0 ff ff ff : ................
2770 : __ __ __ BYT ff ff ff 07 07 e7 e7 e7 ff ff ff ff ff ff 00 00 : ................
2780 : __ __ __ BYT ff ff ff e0 e0 e7 e7 e7 e7 e7 e7 00 00 ff ff ff : ................
2790 : __ __ __ BYT ff ff ff 00 00 e7 e7 e7 e7 e7 e7 07 07 e7 e7 e7 : ................
27a0 : __ __ __ BYT 3f 3f 3f 3f 3f 3f 3f 3f 1f 1f 1f 1f 1f 1f 1f 1f : ????????........
27b0 : __ __ __ BYT f8 f8 f8 f8 f8 f8 f8 f8 00 00 ff ff ff ff ff ff : ................
27c0 : __ __ __ BYT 00 00 00 ff ff ff ff ff ff ff ff ff ff 00 00 00 : ................
27d0 : __ __ __ BYT fc fc fc fc fc fc 00 00 ff ff ff ff 0f 0f 0f 0f : ................
27e0 : __ __ __ BYT f0 f0 f0 f0 ff ff ff ff e7 e7 e7 07 07 ff ff ff : ................
27f0 : __ __ __ BYT 0f 0f 0f 0f ff ff ff ff 0f 0f 0f 0f f0 f0 f0 f0 : ................
--------------------------------------------------------------------
snake1:
2800 : __ __ __ BSS	518
--------------------------------------------------------------------
snake2:
2a06 : __ __ __ BSS	518
