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
080e : 8e 19 15 STX $1519 ; (spentry + 0)
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
; 381, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 382, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a00 : 20 83 0a JSR $0a83 ; (gfx_init.s4 + 0)
; 383, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a03 : 20 d4 0a JSR $0ad4 ; (gfx_draw_frame.s4 + 0)
; 385, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a06 : a9 23 __ LDA #$23
0a08 : 85 10 __ STA P3 
0a0a : a9 14 __ LDA #$14
0a0c : 85 11 __ STA P4 
0a0e : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 386, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a11 : a9 23 __ LDA #$23
0a13 : 85 10 __ STA P3 
0a15 : a9 05 __ LDA #$05
0a17 : 85 11 __ STA P4 
0a19 : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 387, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a1c : a9 05 __ LDA #$05
0a1e : 85 10 __ STA P3 
0a20 : a9 14 __ LDA #$14
0a22 : 85 11 __ STA P4 
0a24 : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 388, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a27 : a9 05 __ LDA #$05
0a29 : 85 10 __ STA P3 
0a2b : 85 11 __ STA P4 
0a2d : 20 16 10 JSR $1016 ; (gfx_draw_food.s4 + 0)
; 390, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a30 : a9 14 __ LDA #$14
0a32 : 85 10 __ STA P3 
0a34 : a9 03 __ LDA #$03
0a36 : 85 11 __ STA P4 
0a38 : 20 34 10 JSR $1034 ; (gfx_draw_hazard.s4 + 0)
; 391, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a3b : a9 14 __ LDA #$14
0a3d : 85 10 __ STA P3 
0a3f : 85 11 __ STA P4 
0a41 : 20 34 10 JSR $1034 ; (gfx_draw_hazard.s4 + 0)
; 393, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a44 : 20 52 10 JSR $1052 ; (snake_init.s4 + 0)
; 394, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a47 : a9 01 __ LDA #$01
0a49 : 85 10 __ STA P3 
0a4b : 20 3c 11 JSR $113c ; (snake_draw_head.s4 + 0)
; 395, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a4e : a9 01 __ LDA #$01
0a50 : 85 10 __ STA P3 
0a52 : 20 e2 11 JSR $11e2 ; (snake_draw_body.s4 + 0)
; 396, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a55 : a9 01 __ LDA #$01
0a57 : 85 10 __ STA P3 
0a59 : 20 62 12 JSR $1262 ; (snake_draw_tail.s4 + 0)
; 398, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a5c : a9 00 __ LDA #$00
0a5e : 85 49 __ STA T1 + 0 
.l5:
; 400, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a60 : 20 f3 0b JSR $0bf3 ; (wait_for_frame.s4 + 0)
; 401, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a63 : a9 01 __ LDA #$01
0a65 : 20 69 13 JSR $1369 ; (snake_control.s4 + 0)
; 402, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a68 : a5 49 __ LDA T1 + 0 
0a6a : c9 06 __ CMP #$06
0a6c : e6 49 __ INC T1 + 0 
0a6e : 90 f0 __ BCC $0a60 ; (main.l5 + 0)
.s6:
; 405, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a70 : a9 00 __ LDA #$00
0a72 : 85 49 __ STA T1 + 0 
; 403, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a74 : ad 00 28 LDA $2800 ; (snake1.status + 0)
0a77 : d0 e7 __ BNE $0a60 ; (main.l5 + 0)
.s7:
; 404, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0a79 : a9 01 __ LDA #$01
0a7b : 85 11 __ STA P4 
0a7d : 20 b2 13 JSR $13b2 ; (snake_advance.s4 + 0)
0a80 : 4c 60 0a JMP $0a60 ; (main.l5 + 0)
--------------------------------------------------------------------
gfx_init: ; gfx_init()->void
;  43, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 211, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
0a83 : ad 20 d0 LDA $d020 
0a86 : 8d 1a 15 STA $151a ; (gfx_old_border + 0)
0a89 : a9 00 __ LDA #$00
0a8b : 8d 20 d0 STA $d020 
0a8e : ad 21 d0 LDA $d021 
0a91 : 8d 1b 15 STA $151b ; (gfx_old_background + 0)
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
0bd7 : b9 1c 15 LDA $151c,y ; (scr_row_low[0] + 0)
0bda : 8d e8 0b STA $0be8 ; (gfx_scr_set_xy.s4 + 19)
0bdd : b9 35 15 LDA $1535,y ; (scr_row_high[0] + 0)
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
; 346, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 348, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0bf3 : a9 fa __ LDA #$fa
0bf5 : cd 12 d0 CMP $d012 
0bf8 : d0 fb __ BNE $0bf5 ; (wait_for_frame.s4 + 2)
0bfa : cd 12 d0 CMP $d012 
0bfd : f0 fb __ BEQ $0bfa ; (wait_for_frame.s4 + 7)
.s3:
; 356, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
0bff : 60 __ __ RTS
--------------------------------------------------------------------
gfx_clr_set_xy: ; gfx_clr_set_xy(u8,u8,u8)->void
;  40, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 193, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
1000 : a4 0e __ LDY P1 
1002 : b9 4e 15 LDA $154e,y ; (clr_row_low[0] + 0)
1005 : 8d 13 10 STA $1013 ; (gfx_clr_set_xy.s4 + 19)
1008 : b9 67 15 LDA $1567,y ; (clr_row_high[0] + 0)
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
; 307, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 308, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1052 : a9 01 __ LDA #$01
1054 : 85 0d __ STA P0 
1056 : 20 8c 10 JSR $108c ; (snake_reset.s4 + 0)
; 309, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1059 : a9 00 __ LDA #$00
105b : 8d 00 28 STA $2800 ; (snake1.status + 0)
; 310, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
105e : a9 03 __ LDA #$03
1060 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
; 311, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1063 : a9 0f __ LDA #$0f
1065 : 85 0e __ STA P1 
1067 : a9 0a __ LDA #$0a
1069 : 85 0f __ STA P2 
106b : 20 ec 10 JSR $10ec ; (snake_add.s4 + 0)
; 312, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
106e : c6 0e __ DEC P1 
1070 : 20 ec 10 JSR $10ec ; (snake_add.s4 + 0)
; 313, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1073 : c6 0e __ DEC P1 
1075 : 20 ec 10 JSR $10ec ; (snake_add.s4 + 0)
; 314, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1078 : c6 0e __ DEC P1 
107a : 20 ec 10 JSR $10ec ; (snake_add.s4 + 0)
; 315, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
107d : c6 0e __ DEC P1 
107f : 20 ec 10 JSR $10ec ; (snake_add.s4 + 0)
; 316, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1082 : c6 0e __ DEC P1 
1084 : 20 ec 10 JSR $10ec ; (snake_add.s4 + 0)
; 317, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1087 : a9 02 __ LDA #$02
1089 : 4c 8c 10 JMP $108c ; (snake_reset.s4 + 0)
--------------------------------------------------------------------
snake_reset: ; snake_reset(u8)->void
;  77, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
;  78, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
108c : c9 01 __ CMP #$01
108e : d0 1c __ BNE $10ac ; (snake_reset.s5 + 0)
.s9:
;  79, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1090 : a9 00 __ LDA #$00
;  85, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1092 : 85 1b __ STA ACCU + 0 
;  79, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1094 : 8d 00 28 STA $2800 ; (snake1.status + 0)
;  81, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1097 : 8d 02 2a STA $2a02 ; (snake1.start + 0)
;  82, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
109a : 8d 03 2a STA $2a03 ; (snake1.end + 0)
;  83, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
109d : 8d 04 2a STA $2a04 ; (snake1.length + 0)
;  84, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10a0 : 8d 05 2a STA $2a05 ; (snake1.grow + 0)
;  80, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10a3 : a9 01 __ LDA #$01
10a5 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
;  86, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10a8 : a9 ff __ LDA #$ff
10aa : d0 2f __ BNE $10db ; (snake_reset.l10 + 0)
.s5:
;  93, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ac : c9 02 __ CMP #$02
10ae : d0 2a __ BNE $10da ; (snake_reset.s3 + 0)
.s6:
;  94, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10b0 : a9 00 __ LDA #$00
; 100, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10b2 : 85 1b __ STA ACCU + 0 
;  94, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10b4 : 8d 06 2a STA $2a06 ; (snake2.status + 0)
;  96, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10b7 : 8d 08 2c STA $2c08 ; (snake2.start + 0)
;  97, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ba : 8d 09 2c STA $2c09 ; (snake2.end + 0)
;  98, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10bd : 8d 0a 2c STA $2c0a ; (snake2.length + 0)
;  99, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10c0 : 8d 0b 2c STA $2c0b ; (snake2.grow + 0)
;  95, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10c3 : a9 01 __ LDA #$01
10c5 : 8d 07 2a STA $2a07 ; (snake2.direction + 0)
; 101, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10c8 : a9 ff __ LDA #$ff
10ca : d0 02 __ BNE $10ce ; (snake_reset.l7 + 0)
.s8:
; 100, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10cc : e6 1b __ INC ACCU + 0 
.l7:
; 101, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ce : a6 1b __ LDX ACCU + 0 
10d0 : 9d 08 2a STA $2a08,x ; (snake2.x[0] + 0)
; 102, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10d3 : 9d 08 2b STA $2b08,x ; (snake2.y[0] + 0)
; 103, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10d6 : c5 1b __ CMP ACCU + 0 
10d8 : d0 f2 __ BNE $10cc ; (snake_reset.s8 + 0)
.s3:
;  91, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10da : 60 __ __ RTS
.l10:
;  86, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10db : a6 1b __ LDX ACCU + 0 
10dd : 9d 02 28 STA $2802,x ; (snake1.x[0] + 0)
;  87, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10e0 : 9d 02 29 STA $2902,x ; (snake1.y[0] + 0)
;  88, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10e3 : c5 1b __ CMP ACCU + 0 
10e5 : f0 f3 __ BEQ $10da ; (snake_reset.s3 + 0)
.s11:
;  85, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10e7 : e6 1b __ INC ACCU + 0 
10e9 : 4c db 10 JMP $10db ; (snake_reset.l10 + 0)
--------------------------------------------------------------------
snake_add: ; snake_add(u8,u8,u8)->void
; 111, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 112, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ec : a5 0d __ LDA P0 ; (s + 0)
10ee : c9 01 __ CMP #$01
10f0 : f0 27 __ BEQ $1119 ; (snake_add.s10 + 0)
.s5:
; 122, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10f2 : c9 02 __ CMP #$02
10f4 : d0 22 __ BNE $1118 ; (snake_add.s3 + 0)
.s6:
; 123, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10f6 : ad 0a 2c LDA $2c0a ; (snake2.length + 0)
10f9 : c9 f0 __ CMP #$f0
10fb : b0 1b __ BCS $1118 ; (snake_add.s3 + 0)
.s7:
10fd : 85 1b __ STA ACCU + 0 
; 125, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
10ff : aa __ __ TAX
1100 : f0 03 __ BEQ $1105 ; (snake_add.s8 + 0)
.s9:
; 126, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1102 : ee 08 2c INC $2c08 ; (snake2.start + 0)
.s8:
; 127, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1105 : a5 0e __ LDA P1 ; (x + 0)
1107 : ae 08 2c LDX $2c08 ; (snake2.start + 0)
110a : 9d 08 2a STA $2a08,x ; (snake2.x[0] + 0)
; 128, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
110d : a5 0f __ LDA P2 ; (y + 0)
110f : 9d 08 2b STA $2b08,x ; (snake2.y[0] + 0)
; 129, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1112 : a6 1b __ LDX ACCU + 0 
1114 : e8 __ __ INX
1115 : 8e 0a 2c STX $2c0a ; (snake2.length + 0)
.s3:
; 114, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1118 : 60 __ __ RTS
.s10:
; 113, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1119 : ad 04 2a LDA $2a04 ; (snake1.length + 0)
111c : c9 f0 __ CMP #$f0
111e : b0 f8 __ BCS $1118 ; (snake_add.s3 + 0)
.s11:
1120 : 85 1b __ STA ACCU + 0 
; 115, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1122 : aa __ __ TAX
1123 : f0 03 __ BEQ $1128 ; (snake_add.s12 + 0)
.s13:
; 116, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1125 : ee 02 2a INC $2a02 ; (snake1.start + 0)
.s12:
; 117, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1128 : a5 0e __ LDA P1 ; (x + 0)
112a : ae 02 2a LDX $2a02 ; (snake1.start + 0)
112d : 9d 02 28 STA $2802,x ; (snake1.x[0] + 0)
; 118, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1130 : a5 0f __ LDA P2 ; (y + 0)
1132 : 9d 02 29 STA $2902,x ; (snake1.y[0] + 0)
; 119, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1135 : a6 1b __ LDX ACCU + 0 
1137 : e8 __ __ INX
1138 : 8e 04 2a STX $2a04 ; (snake1.length + 0)
113b : 60 __ __ RTS
--------------------------------------------------------------------
snake_draw_head: ; snake_draw_head(u8)->void
; 146, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 147, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
113c : a5 10 __ LDA P3 ; (s + 0)
113e : c9 01 __ CMP #$01
1140 : d0 48 __ BNE $118a ; (snake_draw_head.s5 + 0)
.s7:
; 148, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1142 : ae 02 2a LDX $2a02 ; (snake1.start + 0)
1145 : 86 44 __ STX T1 + 0 
1147 : a9 57 __ LDA #$57
1149 : 85 0f __ STA P2 
114b : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
114e : 85 45 __ STA T2 + 0 
1150 : 85 0d __ STA P0 
1152 : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
1155 : 85 43 __ STA T0 + 0 
1157 : 85 0e __ STA P1 
1159 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 149, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
115c : a5 45 __ LDA T2 + 0 
115e : 85 0d __ STA P0 
1160 : a5 43 __ LDA T0 + 0 
1162 : 85 0e __ STA P1 
1164 : a9 0d __ LDA #$0d
1166 : 85 0f __ STA P2 
1168 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 150, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
116b : a5 44 __ LDA T1 + 0 
116d : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
1170 : aa __ __ TAX
; 151, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1171 : a9 27 __ LDA #$27
1173 : 85 0f __ STA P2 
1175 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
1178 : 85 44 __ STA T1 + 0 
117a : 85 0d __ STA P0 
117c : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
117f : 85 43 __ STA T0 + 0 
1181 : 85 0e __ STA P1 
1183 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 152, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1186 : a9 0d __ LDA #$0d
; 153, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1188 : d0 4b __ BNE $11d5 ; (snake_draw_head.s8 + 0)
.s5:
; 155, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
118a : c9 02 __ CMP #$02
118c : f0 01 __ BEQ $118f ; (snake_draw_head.s6 + 0)
.s3:
; 163, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
118e : 60 __ __ RTS
.s6:
; 156, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
118f : ae 08 2c LDX $2c08 ; (snake2.start + 0)
1192 : 86 44 __ STX T1 + 0 
1194 : a9 57 __ LDA #$57
1196 : 85 0f __ STA P2 
1198 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
119b : 85 45 __ STA T2 + 0 
119d : 85 0d __ STA P0 
119f : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
11a2 : 85 43 __ STA T0 + 0 
11a4 : 85 0e __ STA P1 
11a6 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 157, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11a9 : a5 45 __ LDA T2 + 0 
11ab : 85 0d __ STA P0 
11ad : a5 43 __ LDA T0 + 0 
11af : 85 0e __ STA P1 
11b1 : a9 0e __ LDA #$0e
11b3 : 85 0f __ STA P2 
11b5 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 158, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11b8 : a5 44 __ LDA T1 + 0 
11ba : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
11bd : aa __ __ TAX
; 159, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11be : a9 27 __ LDA #$27
11c0 : 85 0f __ STA P2 
11c2 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
11c5 : 85 44 __ STA T1 + 0 
11c7 : 85 0d __ STA P0 
11c9 : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
11cc : 85 43 __ STA T0 + 0 
11ce : 85 0e __ STA P1 
11d0 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 160, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11d3 : a9 0e __ LDA #$0e
.s8:
; 152, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11d5 : 85 0f __ STA P2 
11d7 : a5 44 __ LDA T1 + 0 
11d9 : 85 0d __ STA P0 
11db : a5 43 __ LDA T0 + 0 
11dd : 85 0e __ STA P1 
11df : 4c 00 10 JMP $1000 ; (gfx_clr_set_xy.s4 + 0)
--------------------------------------------------------------------
snake_draw_body: ; snake_draw_body(u8)->void
; 196, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 197, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11e2 : a5 10 __ LDA P3 ; (s + 0)
11e4 : c9 01 __ CMP #$01
11e6 : f0 3f __ BEQ $1227 ; (snake_draw_body.s7 + 0)
.s5:
; 207, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11e8 : c9 02 __ CMP #$02
11ea : d0 3a __ BNE $1226 ; (snake_draw_body.s3 + 0)
.s6:
; 208, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11ec : ad 08 2c LDA $2c08 ; (snake2.start + 0)
11ef : e9 02 __ SBC #$02
11f1 : 85 44 __ STA T1 + 0 
; 209, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
11f3 : aa __ __ TAX
.l9:
11f4 : a9 27 __ LDA #$27
11f6 : 85 0f __ STA P2 
11f8 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
11fb : 85 45 __ STA T2 + 0 
11fd : 85 0d __ STA P0 
11ff : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
1202 : 85 43 __ STA T0 + 0 
1204 : 85 0e __ STA P1 
1206 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 210, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1209 : a5 45 __ LDA T2 + 0 
120b : 85 0d __ STA P0 
120d : a5 43 __ LDA T0 + 0 
120f : 85 0e __ STA P1 
1211 : a9 0e __ LDA #$0e
1213 : 85 0f __ STA P2 
1215 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 212, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1218 : ae 09 2c LDX $2c09 ; (snake2.end + 0)
121b : e8 __ __ INX
121c : 86 43 __ STX T0 + 0 
; 211, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
121e : c6 44 __ DEC T1 + 0 
; 212, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1220 : a6 44 __ LDX T1 + 0 
1222 : e4 43 __ CPX T0 + 0 
1224 : d0 ce __ BNE $11f4 ; (snake_draw_body.l9 + 0)
.s3:
; 205, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1226 : 60 __ __ RTS
.s7:
; 198, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1227 : ad 02 2a LDA $2a02 ; (snake1.start + 0)
122a : e9 02 __ SBC #$02
122c : 85 44 __ STA T1 + 0 
; 199, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
122e : aa __ __ TAX
.l8:
122f : a9 27 __ LDA #$27
1231 : 85 0f __ STA P2 
1233 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
1236 : 85 45 __ STA T2 + 0 
1238 : 85 0d __ STA P0 
123a : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
123d : 85 43 __ STA T0 + 0 
123f : 85 0e __ STA P1 
1241 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 200, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1244 : a5 45 __ LDA T2 + 0 
1246 : 85 0d __ STA P0 
1248 : a5 43 __ LDA T0 + 0 
124a : 85 0e __ STA P1 
124c : a9 0d __ LDA #$0d
124e : 85 0f __ STA P2 
1250 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 202, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1253 : ae 03 2a LDX $2a03 ; (snake1.end + 0)
1256 : e8 __ __ INX
1257 : 86 43 __ STX T0 + 0 
; 201, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1259 : c6 44 __ DEC T1 + 0 
; 202, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
125b : a6 44 __ LDX T1 + 0 
125d : e4 43 __ CPX T0 + 0 
125f : d0 ce __ BNE $122f ; (snake_draw_body.l8 + 0)
1261 : 60 __ __ RTS
--------------------------------------------------------------------
snake_draw_tail: ; snake_draw_tail(u8)->void
; 166, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 167, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1262 : a5 10 __ LDA P3 ; (s + 0)
1264 : c9 01 __ CMP #$01
1266 : d0 03 __ BNE $126b ; (snake_draw_tail.s5 + 0)
1268 : 4c f2 12 JMP $12f2 ; (snake_draw_tail.s9 + 0)
.s5:
; 180, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
126b : c9 02 __ CMP #$02
126d : f0 01 __ BEQ $1270 ; (snake_draw_tail.s6 + 0)
126f : 60 __ __ RTS
.s6:
; 181, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1270 : ae 09 2c LDX $2c09 ; (snake2.end + 0)
1273 : 86 44 __ STX T1 + 0 
1275 : a9 5e __ LDA #$5e
1277 : 85 0f __ STA P2 
1279 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
127c : 85 45 __ STA T2 + 0 
127e : 85 0d __ STA P0 
1280 : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
1283 : 85 43 __ STA T0 + 0 
1285 : 85 0e __ STA P1 
1287 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 182, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
128a : a5 45 __ LDA T2 + 0 
128c : 85 0d __ STA P0 
128e : a5 43 __ LDA T0 + 0 
1290 : 85 0e __ STA P1 
1292 : a9 0e __ LDA #$0e
1294 : 85 0f __ STA P2 
1296 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 183, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1299 : a5 44 __ LDA T1 + 0 
129b : 20 ef 0b JSR $0bef ; (inc8.s4 + 0)
129e : aa __ __ TAX
; 184, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
129f : a9 51 __ LDA #$51
12a1 : 85 0f __ STA P2 
12a3 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
12a6 : 85 45 __ STA T2 + 0 
12a8 : 85 0d __ STA P0 
12aa : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
12ad : 85 43 __ STA T0 + 0 
12af : 85 0e __ STA P1 
12b1 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 185, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12b4 : a5 45 __ LDA T2 + 0 
12b6 : 85 0d __ STA P0 
12b8 : a5 43 __ LDA T0 + 0 
12ba : 85 0e __ STA P1 
12bc : a9 0e __ LDA #$0e
12be : 85 0f __ STA P2 
12c0 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 186, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12c3 : a5 44 __ LDA T1 + 0 
12c5 : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
; 187, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12c8 : aa __ __ TAX
12c9 : bd 08 2a LDA $2a08,x ; (snake2.x[0] + 0)
12cc : c9 ff __ CMP #$ff
12ce : f0 21 __ BEQ $12f1 ; (snake_draw_tail.s3 + 0)
.s7:
12d0 : 85 45 __ STA T2 + 0 
; 188, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12d2 : 85 0d __ STA P0 
12d4 : a9 20 __ LDA #$20
12d6 : 85 0f __ STA P2 
12d8 : bd 08 2b LDA $2b08,x ; (snake2.y[0] + 0)
12db : 85 43 __ STA T0 + 0 
12dd : 85 0e __ STA P1 
12df : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 189, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12e2 : a9 0e __ LDA #$0e
.s8:
; 176, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12e4 : 85 0f __ STA P2 
12e6 : a5 45 __ LDA T2 + 0 
12e8 : 85 0d __ STA P0 
12ea : a5 43 __ LDA T0 + 0 
12ec : 85 0e __ STA P1 
; 189, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12ee : 4c 00 10 JMP $1000 ; (gfx_clr_set_xy.s4 + 0)
.s3:
; 178, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12f1 : 60 __ __ RTS
.s9:
; 168, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
12f2 : ae 03 2a LDX $2a03 ; (snake1.end + 0)
12f5 : 86 44 __ STX T1 + 0 
12f7 : a9 5e __ LDA #$5e
12f9 : 85 0f __ STA P2 
12fb : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
12fe : 85 45 __ STA T2 + 0 
1300 : 85 0d __ STA P0 
1302 : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
1305 : 85 43 __ STA T0 + 0 
1307 : 85 0e __ STA P1 
1309 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 169, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
130c : a5 45 __ LDA T2 + 0 
130e : 85 0d __ STA P0 
1310 : a5 43 __ LDA T0 + 0 
1312 : 85 0e __ STA P1 
1314 : a9 0d __ LDA #$0d
1316 : 85 0f __ STA P2 
1318 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 170, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
131b : a5 44 __ LDA T1 + 0 
131d : 20 ef 0b JSR $0bef ; (inc8.s4 + 0)
1320 : aa __ __ TAX
; 171, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1321 : a9 51 __ LDA #$51
1323 : 85 0f __ STA P2 
1325 : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
1328 : 85 45 __ STA T2 + 0 
132a : 85 0d __ STA P0 
132c : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
132f : 85 43 __ STA T0 + 0 
1331 : 85 0e __ STA P1 
1333 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 172, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1336 : a5 45 __ LDA T2 + 0 
1338 : 85 0d __ STA P0 
133a : a5 43 __ LDA T0 + 0 
133c : 85 0e __ STA P1 
133e : a9 0d __ LDA #$0d
1340 : 85 0f __ STA P2 
1342 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 173, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1345 : a5 44 __ LDA T1 + 0 
1347 : 20 eb 0b JSR $0beb ; (dec8.s4 + 0)
; 174, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
134a : aa __ __ TAX
134b : bd 02 28 LDA $2802,x ; (snake1.x[0] + 0)
134e : c9 ff __ CMP #$ff
1350 : f0 9f __ BEQ $12f1 ; (snake_draw_tail.s3 + 0)
.s10:
1352 : 85 45 __ STA T2 + 0 
; 175, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1354 : 85 0d __ STA P0 
1356 : a9 20 __ LDA #$20
1358 : 85 0f __ STA P2 
135a : bd 02 29 LDA $2902,x ; (snake1.y[0] + 0)
135d : 85 43 __ STA T0 + 0 
135f : 85 0e __ STA P1 
1361 : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
; 176, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1364 : a9 0d __ LDA #$0d
1366 : 4c e4 12 JMP $12e4 ; (snake_draw_tail.s8 + 0)
--------------------------------------------------------------------
snake_control: ; snake_control(u8)->void
; 364, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 365, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1369 : c9 01 __ CMP #$01
136b : d0 36 __ BNE $13a3 ; (snake_control.s3 + 0)
.s5:
; 366, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
136d : ad 00 dc LDA $dc00 
1370 : 49 ff __ EOR #$ff
1372 : a8 __ __ TAY
; 367, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1373 : 29 04 __ AND #$04
1375 : f0 0b __ BEQ $1382 ; (snake_control.s6 + 0)
.s15:
1377 : ae 01 28 LDX $2801 ; (snake1.direction + 0)
137a : ca __ __ DEX
137b : f0 05 __ BEQ $1382 ; (snake_control.s6 + 0)
.s16:
; 368, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
137d : a9 03 __ LDA #$03
137f : 8d 01 28 STA $2801 ; (snake1.direction + 0)
.s6:
; 369, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1382 : 98 __ __ TYA
1383 : 29 08 __ AND #$08
1385 : f0 0c __ BEQ $1393 ; (snake_control.s7 + 0)
.s13:
1387 : ad 01 28 LDA $2801 ; (snake1.direction + 0)
138a : c9 03 __ CMP #$03
138c : f0 05 __ BEQ $1393 ; (snake_control.s7 + 0)
.s14:
; 370, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
138e : a9 01 __ LDA #$01
1390 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
.s7:
; 371, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1393 : 98 __ __ TYA
1394 : 4a __ __ LSR
1395 : 90 0d __ BCC $13a4 ; (snake_control.s8 + 0)
.s11:
1397 : ad 01 28 LDA $2801 ; (snake1.direction + 0)
139a : c9 02 __ CMP #$02
139c : f0 06 __ BEQ $13a4 ; (snake_control.s8 + 0)
.s12:
; 372, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
139e : a9 00 __ LDA #$00
.s17:
; 374, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13a0 : 8d 01 28 STA $2801 ; (snake1.direction + 0)
.s3:
; 379, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13a3 : 60 __ __ RTS
.s8:
; 373, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13a4 : 98 __ __ TYA
13a5 : 29 02 __ AND #$02
13a7 : f0 fa __ BEQ $13a3 ; (snake_control.s3 + 0)
.s9:
13a9 : ad 01 28 LDA $2801 ; (snake1.direction + 0)
13ac : f0 f5 __ BEQ $13a3 ; (snake_control.s3 + 0)
.s10:
; 374, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13ae : a9 02 __ LDA #$02
13b0 : d0 ee __ BNE $13a0 ; (snake_control.s17 + 0)
--------------------------------------------------------------------
snake_advance: ; snake_advance(u8)->void
; 247, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 249, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13b2 : a5 11 __ LDA P4 ; (s + 0)
13b4 : c9 01 __ CMP #$01
13b6 : f0 64 __ BEQ $141c ; (snake_advance.s13 + 0)
.s5:
; 283, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13b8 : c9 02 __ CMP #$02
13ba : d0 54 __ BNE $1410 ; (snake_advance.s6 + 0)
.s7:
; 284, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13bc : ad 06 2a LDA $2a06 ; (snake2.status + 0)
13bf : d0 25 __ BNE $13e6 ; (snake_advance.s3 + 0)
.s8:
; 286, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13c1 : ae 07 2a LDX $2a07 ; (snake2.direction + 0)
13c4 : bd 80 15 LDA $1580,x ; (ddx[0] + 0)
13c7 : ac 08 2c LDY $2c08 ; (snake2.start + 0)
13ca : 84 48 __ STY T5 + 0 
13cc : 18 __ __ CLC
13cd : 79 08 2a ADC $2a08,y ; (snake2.x[0] + 0)
13d0 : 85 47 __ STA T3 + 0 
; 288, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13d2 : 85 0d __ STA P0 
; 287, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13d4 : bd 84 15 LDA $1584,x ; (ddy[0] + 0)
13d7 : 18 __ __ CLC
13d8 : 79 08 2b ADC $2b08,y ; (snake2.y[0] + 0)
13db : 85 46 __ STA T1 + 0 
; 288, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13dd : 85 0e __ STA P1 
13df : 20 a9 14 JSR $14a9 ; (gfx_scr_get_xy.s4 + 0)
; 289, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13e2 : c9 20 __ CMP #$20
13e4 : f0 01 __ BEQ $13e7 ; (snake_advance.s9 + 0)
.s3:
; 304, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13e6 : 60 __ __ RTS
.s9:
; 292, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13e7 : a6 48 __ LDX T5 + 0 
13e9 : e8 __ __ INX
13ea : 8e 08 2c STX $2c08 ; (snake2.start + 0)
; 293, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13ed : a5 47 __ LDA T3 + 0 
13ef : 9d 08 2a STA $2a08,x ; (snake2.x[0] + 0)
; 294, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13f2 : a5 46 __ LDA T1 + 0 
13f4 : 9d 08 2b STA $2b08,x ; (snake2.y[0] + 0)
; 295, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
13f7 : ad 0b 2c LDA $2c0b ; (snake2.grow + 0)
13fa : f0 0f __ BEQ $140b ; (snake_advance.s10 + 0)
.s11:
13fc : ad 0a 2c LDA $2c0a ; (snake2.length + 0)
13ff : c9 f0 __ CMP #$f0
1401 : b0 08 __ BCS $140b ; (snake_advance.s10 + 0)
.s12:
; 296, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1403 : ce 0b 2c DEC $2c0b ; (snake2.grow + 0)
; 297, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1406 : ee 0a 2c INC $2c0a ; (snake2.length + 0)
1409 : 90 03 __ BCC $140e ; (snake_advance.s27 + 0)
.s10:
; 299, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
140b : ee 09 2c INC $2c09 ; (snake2.end + 0)
.s27:
; 302, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
140e : a9 02 __ LDA #$02
.s6:
1410 : 85 10 __ STA P3 
1412 : 20 3c 11 JSR $113c ; (snake_draw_head.s4 + 0)
; 303, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1415 : a5 11 __ LDA P4 ; (s + 0)
1417 : 85 10 __ STA P3 
.s25:
1419 : 4c 62 12 JMP $1262 ; (snake_draw_tail.s4 + 0)
.s13:
; 250, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
141c : ad 00 28 LDA $2800 ; (snake1.status + 0)
141f : d0 c5 __ BNE $13e6 ; (snake_advance.s3 + 0)
.s14:
; 252, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1421 : ae 01 28 LDX $2801 ; (snake1.direction + 0)
1424 : bd 80 15 LDA $1580,x ; (ddx[0] + 0)
1427 : ac 02 2a LDY $2a02 ; (snake1.start + 0)
142a : 84 48 __ STY T5 + 0 
142c : 18 __ __ CLC
142d : 79 02 28 ADC $2802,y ; (snake1.x[0] + 0)
1430 : 85 47 __ STA T3 + 0 
; 254, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1432 : 85 0d __ STA P0 
; 253, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1434 : bd 84 15 LDA $1584,x ; (ddy[0] + 0)
1437 : 18 __ __ CLC
1438 : 79 02 29 ADC $2902,y ; (snake1.y[0] + 0)
143b : 85 46 __ STA T1 + 0 
; 254, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
143d : 85 0e __ STA P1 
143f : 20 a9 14 JSR $14a9 ; (gfx_scr_get_xy.s4 + 0)
; 255, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1442 : c9 20 __ CMP #$20
1444 : f0 37 __ BEQ $147d ; (snake_advance.s15 + 0)
.s19:
; 256, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1446 : c9 53 __ CMP #$53
1448 : f0 1f __ BEQ $1469 ; (snake_advance.s24 + 0)
.s20:
; 260, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
144a : c9 56 __ CMP #$56
144c : d0 98 __ BNE $13e6 ; (snake_advance.s3 + 0)
.s21:
; 261, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
144e : ad 04 2a LDA $2a04 ; (snake1.length + 0)
1451 : c9 06 __ CMP #$06
; 263, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1453 : a9 01 __ LDA #$01
1455 : 85 10 __ STA P3 
; 261, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1457 : 90 08 __ BCC $1461 ; (snake_advance.s23 + 0)
.s22:
; 265, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1459 : ce 04 2a DEC $2a04 ; (snake1.length + 0)
; 266, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
145c : ee 03 2a INC $2a03 ; (snake1.end + 0)
145f : b0 b8 __ BCS $1419 ; (snake_advance.s25 + 0)
.s23:
; 262, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1461 : a9 02 __ LDA #$02
1463 : 8d 00 28 STA $2800 ; (snake1.status + 0)
; 263, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1466 : 4c c5 14 JMP $14c5 ; (snake_set_dead_color.s4 + 0)
.s24:
; 257, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1469 : a9 02 __ LDA #$02
146b : 8d 05 2a STA $2a05 ; (snake1.grow + 0)
; 258, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
146e : a5 47 __ LDA T3 + 0 
1470 : 85 0d __ STA P0 
1472 : a5 46 __ LDA T1 + 0 
1474 : 85 0e __ STA P1 
1476 : a9 20 __ LDA #$20
1478 : 85 0f __ STA P2 
147a : 20 d5 0b JSR $0bd5 ; (gfx_scr_set_xy.s4 + 0)
.s15:
; 273, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
147d : a6 48 __ LDX T5 + 0 
147f : e8 __ __ INX
1480 : 8e 02 2a STX $2a02 ; (snake1.start + 0)
; 274, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1483 : a5 47 __ LDA T3 + 0 
1485 : 9d 02 28 STA $2802,x ; (snake1.x[0] + 0)
; 275, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1488 : a5 46 __ LDA T1 + 0 
148a : 9d 02 29 STA $2902,x ; (snake1.y[0] + 0)
; 276, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
148d : ad 05 2a LDA $2a05 ; (snake1.grow + 0)
1490 : f0 0f __ BEQ $14a1 ; (snake_advance.s16 + 0)
.s17:
1492 : ad 04 2a LDA $2a04 ; (snake1.length + 0)
1495 : c9 f0 __ CMP #$f0
1497 : b0 08 __ BCS $14a1 ; (snake_advance.s16 + 0)
.s18:
; 277, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1499 : ce 05 2a DEC $2a05 ; (snake1.grow + 0)
; 278, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
149c : ee 04 2a INC $2a04 ; (snake1.length + 0)
149f : 90 03 __ BCC $14a4 ; (snake_advance.s26 + 0)
.s16:
; 280, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14a1 : ee 03 2a INC $2a03 ; (snake1.end + 0)
.s26:
; 302, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14a4 : a9 01 __ LDA #$01
14a6 : 4c 10 14 JMP $1410 ; (snake_advance.s6 + 0)
--------------------------------------------------------------------
gfx_scr_get_xy: ; gfx_scr_get_xy(u8,u8)->u8
;  34, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.h"
.s4:
; 161, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
14a9 : a4 0e __ LDY P1 
14ab : b9 1c 15 LDA $151c,y ; (scr_row_low[0] + 0)
14ae : 8d ba 14 STA $14ba ; (gfx_scr_get_xy.s4 + 17)
14b1 : b9 35 15 LDA $1535,y ; (scr_row_high[0] + 0)
14b4 : 8d bb 14 STA $14bb ; (gfx_scr_get_xy.s4 + 18)
14b7 : a6 0d __ LDX P0 
14b9 : bd ff ff LDA $ffff,x 
14bc : 85 1b __ STA ACCU + 0 
14be : a9 00 __ LDA #$00
14c0 : 85 1c __ STA ACCU + 1 
.s3:
14c2 : a5 1b __ LDA ACCU + 0 
; 173, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/gfx.c"
14c4 : 60 __ __ RTS
--------------------------------------------------------------------
snake_set_dead_color: ; snake_set_dead_color(u8)->void
; 220, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
.s4:
; 221, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14c5 : a5 10 __ LDA P3 ; (s + 0)
14c7 : c9 01 __ CMP #$01
14c9 : f0 29 __ BEQ $14f4 ; (snake_set_dead_color.s7 + 0)
.s5:
; 230, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14cb : c9 02 __ CMP #$02
14cd : d0 24 __ BNE $14f3 ; (snake_set_dead_color.s3 + 0)
.s6:
; 231, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14cf : ac 08 2c LDY $2c08 ; (snake2.start + 0)
14d2 : 84 43 __ STY T2 + 0 
.l9:
; 232, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14d4 : b9 08 2a LDA $2a08,y ; (snake2.x[0] + 0)
14d7 : 85 0d __ STA P0 
14d9 : a9 0b __ LDA #$0b
14db : 85 0f __ STA P2 
14dd : b9 08 2b LDA $2b08,y ; (snake2.y[0] + 0)
14e0 : 85 0e __ STA P1 
14e2 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 234, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14e5 : ae 09 2c LDX $2c09 ; (snake2.end + 0)
14e8 : ca __ __ DEX
14e9 : 86 1b __ STX ACCU + 0 
; 233, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14eb : c6 43 __ DEC T2 + 0 
; 234, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14ed : a4 43 __ LDY T2 + 0 
14ef : c4 1b __ CPY ACCU + 0 
14f1 : d0 e1 __ BNE $14d4 ; (snake_set_dead_color.l9 + 0)
.s3:
; 228, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14f3 : 60 __ __ RTS
.s7:
; 222, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14f4 : ac 02 2a LDY $2a02 ; (snake1.start + 0)
14f7 : 84 43 __ STY T2 + 0 
.l8:
; 223, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
14f9 : b9 02 28 LDA $2802,y ; (snake1.x[0] + 0)
14fc : 85 0d __ STA P0 
14fe : a9 0b __ LDA #$0b
1500 : 85 0f __ STA P2 
1502 : b9 02 29 LDA $2902,y ; (snake1.y[0] + 0)
1505 : 85 0e __ STA P1 
1507 : 20 00 10 JSR $1000 ; (gfx_clr_set_xy.s4 + 0)
; 225, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
150a : ae 03 2a LDX $2a03 ; (snake1.end + 0)
150d : ca __ __ DEX
150e : 86 1b __ STX ACCU + 0 
; 224, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1510 : c6 43 __ DEC T2 + 0 
; 225, "/home/christian/DataEXT4/Offline/C64/Projects/snake64/snake.c"
1512 : a4 43 __ LDY T2 + 0 
1514 : c4 1b __ CPY ACCU + 0 
1516 : d0 e1 __ BNE $14f9 ; (snake_set_dead_color.l8 + 0)
1518 : 60 __ __ RTS
--------------------------------------------------------------------
spentry:
1519 : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
gfx_old_border:
151a : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
gfx_old_background:
151b : __ __ __ BYT 00                                              : .
--------------------------------------------------------------------
scr_row_low:
151c : __ __ __ BYT 00 28 50 78 a0 c8 f0 18 40 68 90 b8 e0 08 30 58 : .(Px....@h....0X
152c : __ __ __ BYT 80 a8 d0 f8 20 48 70 98 c0                      : .... Hp..
--------------------------------------------------------------------
scr_row_high:
1535 : __ __ __ BYT 04 04 04 04 04 04 04 05 05 05 05 05 05 06 06 06 : ................
1545 : __ __ __ BYT 06 06 06 06 07 07 07 07 07                      : .........
--------------------------------------------------------------------
clr_row_low:
154e : __ __ __ BYT 00 28 50 78 a0 c8 f0 18 40 68 90 b8 e0 08 30 58 : .(Px....@h....0X
155e : __ __ __ BYT 80 a8 d0 f8 20 48 70 98 c0                      : .... Hp..
--------------------------------------------------------------------
clr_row_high:
1567 : __ __ __ BYT d8 d8 d8 d8 d8 d8 d8 d9 d9 d9 d9 d9 d9 da da da : ................
1577 : __ __ __ BYT da da da da db db db db db                      : .........
--------------------------------------------------------------------
ddx:
1580 : __ __ __ BYT 00 01 00 ff                                     : ....
--------------------------------------------------------------------
ddy:
1584 : __ __ __ BYT ff 00 01 00                                     : ....
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
