;*******************************************************************************
; DESERT GUN (1977)
;*******************************************************************************
; Arcade target-shooting game for Midway Intel 8080 hardware.
;
; Developer : Dave Nutting Associates (DNA)
; Publisher : Midway Manufacturing
; CPU       : Intel 8080
; Software  : Native 8080 services and indexed-command interpreter
;
; ROM       : 9316.1h / 9316.1g / 9316.1f / desertgu.e
; Interpreter dispatch $11D0; native word vectors $0F61; script PC $2000
;*******************************************************************************

        ORG $0000
; ROM device 9316.1h, SHA1 4d0a3a59d4f8181c6e30966a6b1d19ba5b29c398

; Reset entry: establish the native stack and execute power-on diagnostics.
RESET_ENTRY:
        NOP
        NOP
        LD SP,$2400
        JP BOOT_RAM_ROM_TEST
; Interrupt vector $08: preserve registers and dispatch periodic I/O services.
IRQ_VECTOR_08:
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
        JP IRQ_08_SERVICE

IRQ08_VECTOR_PAD:
        DB $00
; Interrupt vector $10: preserve registers and dispatch secondary I/O services.
IRQ_VECTOR_10:
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
        JP IRQ_10_SERVICE

IRQ10_VECTOR_PAD:
        DB $00
; Power-on RAM/ROM tests; operator inputs select the normal boot path.
BOOT_RAM_ROM_TEST:
        IN A,($02)
        AND $30
        CP $30
        JP NZ,BOOT_MAIN_ENTRY
        DI
        LD B,$01
        LD DE,$0000

TEST_RAM_PATTERN_START:
        LD HL,$2000

TEST_RAM_FORWARD_SCAN:
        OUT ($04),A
        LD (HL),B
        LD A,(HL)
        XOR B
        JP Z,RAM_TEST_ADVANCE_FORWARD
        LD C,A
        LD A,L
        AND $01
        LD A,C
        JP NZ,RAM_TEST_RECORD_ODD_MISMATCH
        OR D
        LD D,A
        JP RAM_TEST_ADVANCE_FORWARD

RAM_TEST_RECORD_ODD_MISMATCH:
        OR E
        LD E,A

RAM_TEST_ADVANCE_FORWARD:
        INC HL
        LD A,H
        CP $40
        JP NZ,TEST_RAM_FORWARD_SCAN

TEST_RAM_REVERSE_SCAN:
        OUT ($04),A
        DEC HL
        LD A,H
        CP $1F
        JP Z,TEST_RAM_FINAL_SCAN
        LD A,(HL)
        XOR B
        JP Z,RAM_TEST_WRITE_COMPLEMENT
        LD C,A
        LD A,L
        AND $01
        LD A,C
        JP NZ,RAM_TEST_RECORD_REVERSE_MISMATCH
        OR D
        LD D,A
        JP RAM_TEST_WRITE_COMPLEMENT

RAM_TEST_RECORD_REVERSE_MISMATCH:
        OR E
        LD E,A

RAM_TEST_WRITE_COMPLEMENT:
        LD A,B
        CPL
        LD (HL),A
        XOR (HL)
        JP Z,TEST_RAM_REVERSE_SCAN
        LD C,A
        LD A,L
        AND $01
        LD A,C
        JP NZ,RAM_TEST_RECORD_COMPLEMENT_MISMATCH
        OR D
        LD D,A
        JP RAM_TEST_RESUME_REVERSE

RAM_TEST_RECORD_COMPLEMENT_MISMATCH:
        OR E
        LD E,A

RAM_TEST_RESUME_REVERSE:
        JP TEST_RAM_REVERSE_SCAN

TEST_RAM_FINAL_SCAN:
        OUT ($04),A
        INC HL
        LD A,H
        CP $40
        JP Z,TEST_RAM_RESULT
        LD A,B
        CPL
        XOR (HL)
        JP Z,RAM_TEST_CLEAR_NEXT_BYTE
        LD C,A
        LD A,L
        AND $01
        LD A,C
        JP NZ,RAM_TEST_RECORD_CLEAR_MISMATCH
        OR D
        LD D,A
        JP RAM_TEST_CLEAR_NEXT_BYTE

RAM_TEST_RECORD_CLEAR_MISMATCH:
        OR E
        LD E,A

RAM_TEST_CLEAR_NEXT_BYTE:
        XOR A
        LD (HL),A
        JP TEST_RAM_FINAL_SCAN

TEST_RAM_RESULT:
        IN A,($02)
        AND $30
        CP $30
        JP NZ,RESET_ENTRY
        LD A,B
        RLCA
        LD B,A
        JP NC,TEST_RAM_PATTERN_START
        LD A,D
        OR E
        JP Z,TEST_ROM_CHECKSUM
        EX DE,HL
        LD SP,HL
        LD DE,$2000
        LD B,$00

RAM_TEST_ERROR_DISPLAY_BIT:
        LD HL,$0000
        ADD HL,SP
        LD C,$10

RAM_TEST_OUTPUT_ERROR_PIXEL:
        XOR A
        ADD HL,HL
        JP C,RAM_TEST_ERROR_DISPLAY_ADVANCE
        CPL

RAM_TEST_ERROR_DISPLAY_ADVANCE:
        LD (DE),A
        INC DE
        LD A,$18
        LD (DE),A
        INC DE
        DEC C
        JP NZ,RAM_TEST_OUTPUT_ERROR_PIXEL
        DEC B
        JP NZ,RAM_TEST_ERROR_DISPLAY_BIT
        JP TEST_FAILURE_HALT
; ROM-bank checksum reference list begins at $0121.
TEST_ROM_CHECKSUM:
        LD SP,$2400
        LD HL,$280C
        PUSH HL
        LD HL,$0000
        LD DE,$0121

TEST_ROM_BANK_LOOP:
        LD BC,$0800
        LD A,(DE)
        INC DE

TEST_ROM_BYTE_LOOP:
        ADD A,(HL)
        OUT ($04),A
        INC HL
        DEC C
        JP NZ,TEST_ROM_BYTE_LOOP
        DEC B
        JP NZ,TEST_ROM_BYTE_LOOP
        INC A
        JP Z,ROM_CHECKSUM_ADVANCE_DEVICE
        EX (SP),HL
        EX DE,HL
        LD A,$01
        CALL DRAW_ENCODED_GRAPHIC
        EX DE,HL
        EX (SP),HL
        DEC DE

ROM_CHECKSUM_ADVANCE_DEVICE:
        INC DE
        LD A,H
        CP $20
        JP NZ,TEST_ROM_BANK_LOOP
        POP HL
        LD A,L
        CP $0C
        JP NZ,TEST_FAILURE_HALT
        IN A,($02)
        RLA
        JP C,RESET_ENTRY
        JP TEST_DISPLAY_ENTRY

TEST_FAILURE_HALT:
        OUT ($04),A
        JP TEST_FAILURE_HALT

ROM_CHECKSUM_REFERENCE:
        DB $00,$48,$D0,$47,$35,$46,$97,$45,$72,$44,$C2,$43
        DB $3E,$42,$58,$41,$88
; Draw compact encoded character/shape data to video memory.
DRAW_ENCODED_GRAPHIC:
        PUSH AF

DRAW_GRAPHIC_COMMAND_FETCH:
        LD A,(HL)
        INC HL
        SUB $30
        JP P,DRAW_GLYPH_TILE
        LD B,A

DRAW_ADVANCE_VIDEO_CURSOR:
        INC DE
        LD A,E
        AND $1F
        JP NZ,DRAW_ADVANCE_LOOP
        INC D
        INC D

DRAW_ADVANCE_LOOP:
        INC B
        JP NZ,DRAW_ADVANCE_VIDEO_CURSOR
        JP DRAW_GRAPHIC_COMMAND_FETCH

DRAW_GLYPH_TILE:
        PUSH HL
        PUSH DE
        CALL DRAW_LOOKUP_GLYPH
        LD C,$20
        LD A,$0A

DRAW_GLYPH_TILE_ROW:
        PUSH AF
        LD A,(DE)
        INC DE
        LD (HL),A
        ADD HL,BC
        POP AF
        DEC A
        JP NZ,DRAW_GLYPH_TILE_ROW
        POP DE
        POP HL
        INC DE
        POP AF
        DEC A
        JP NZ,DRAW_ENCODED_GRAPHIC
        RET
; Draw alternate format/continuation using render state.
DRAW_GRAPHIC_MODE_B:
        PUSH AF
        LD A,(HL)
        SUB $30
        INC HL
        PUSH HL
        CALL DRAW_LOOKUP_GLYPH
        LD A,$0A

DRAW_ALTERNATE_GLYPH_ROW:
        PUSH AF
        LD BC,$0020
        LD A,(DE)
        INC DE
        PUSH DE
        LD D,A
        LD E,$04

DRAW_ALTERNATE_GLYPH_PIXELS:
        PUSH DE
        LD A,D
        AND $03
        LD DE,$01C2

DRAW_ALTERNATE_GLYPH_WRITE:
        INC DE
        DEC A
        JP P,DRAW_ALTERNATE_GLYPH_WRITE
        LD A,(DE)
        PUSH HL
        LD (HL),A
        ADD HL,BC
        LD (HL),A
        ADD HL,BC
        LD (HL),A
        ADD HL,BC
        LD (HL),A
        POP HL
        INC HL
        POP DE
        LD A,D
        RRCA
        RRCA
        LD D,A
        DEC E
        JP NZ,DRAW_ALTERNATE_GLYPH_PIXELS
        LD C,$7C
        ADD HL,BC
        POP DE
        POP AF
        DEC A
        JP NZ,DRAW_ALTERNATE_GLYPH_ROW
        LD BC,$FB04
        ADD HL,BC
        EX DE,HL
        POP HL
        POP AF
        DEC A
        JP NZ,DRAW_GRAPHIC_MODE_B
        RET
; Shift DE right three bits, then adjust display high byte.
SHIFT_VIDEO_ADDRESS_THREE:
        LD B,$03

ADJUST_VIDEO_ADDRESS_LOOP:
        XOR A
        LD A,D
        RRA
        LD D,A
        LD A,E
        RRA
        LD E,A
        DEC B
        JP NZ,ADJUST_VIDEO_ADDRESS_LOOP
        LD A,D
        ADD A,$24
        LD D,A
        RET

DISPLAY_TEST_MASKS:
        DB $00,$0F,$F0,$FF
; Stage the display diagnostic continuation in HL before clearing video memory.
TEST_DISPLAY_ENTRY:
        LD HL,$01D0
        LD SP,$4000
        JP CLEAR_VIDEO_STACK_LOOP_START
; Native display test continuation reached via $01C7 -> $0FD7 -> JP (HL).
; Display diagnostic resumes from clear-video helper; exercises screen RAM and hardware input.
TEST_DISPLAY_AFTER_RAM_CLEAR:
        EI
        LD HL,$2400
        CALL TEST_DISPLAY_PREPARE_RAM

TEST_DISPLAY_PIXEL_LOOP:
        INC HL
        LD A,H
        CP $3F
        JP NZ,TEST_DISPLAY_WRITE_PATTERN
        LD A,L
        CP $C0
        JP Z,TEST_DISPLAY_AFTER_FILL

TEST_DISPLAY_WRITE_PATTERN:
        OUT ($04),A
        LD A,L
        AND $1F
        LD (HL),$01
        JP Z,TEST_DISPLAY_PIXEL_LOOP
        LD (HL),$80
        CP $1F
        JP Z,TEST_DISPLAY_PIXEL_LOOP
        LD (HL),$00
        JP TEST_DISPLAY_PIXEL_LOOP

TEST_DISPLAY_AFTER_FILL:
        CALL TEST_DISPLAY_PREPARE_RAM
        LD HL,$026F
        LD DE,$240F
        LD A,$01
        CALL DRAW_ENCODED_GRAPHIC
        INC A
        LD DE,$3200
        CALL DRAW_ENCODED_GRAPHIC
        INC A
        LD DE,$321F
        CALL DRAW_ENCODED_GRAPHIC
        INC A
        LD DE,$3EAF
        CALL DRAW_ENCODED_GRAPHIC
        LD HL,$0180
        LD ($31EF),HL
        LD ($320F),HL

TEST_DISPLAY_IO_POLL:
        CALL $0234
        IN A,($02)
        RLA
        JP NC,TEST_DISPLAY_ENTRY
        OUT ($04),A
        JP TEST_DISPLAY_IO_POLL
        LD A,($2014)
        LD E,A
        AND $07
        JP NZ,TEST_DISPLAY_INPUT_HANDLE
        INC A

TEST_DISPLAY_INPUT_HANDLE:
        LD C,A
        LD A,($2015)
        LD D,A
        CALL SHIFT_VIDEO_ADDRESS_THREE
        LD HL,$0267
        ADD HL,BC
        LD A,(HL)
        EX DE,HL
        LD (HL),A
        LD C,$20
        ADD HL,BC
        LD (HL),A
        XOR A

TEST_DISPLAY_DELAY_LOOP:
        DEC A
        JP NZ,TEST_DISPLAY_DELAY_LOOP
        LD DE,$FFE0
        LD (HL),A
        ADD HL,DE
        LD (HL),A
        RET
; Prepare diagnostic RAM for display test.
TEST_DISPLAY_PREPARE_RAM:
        LD DE,$20FF

TEST_DISPLAY_CLEAR_RAM_LOOP:
        LD (HL),E
        INC HL
        DEC D
        JP NZ,TEST_DISPLAY_CLEAR_RAM_LOOP
        DEC HL
        RET

DISPLAY_TEST_GLYPH_STEPS:
        DB $03,$06,$0C,$18,$30,$60,$C0,$50,$52,$53,$51

DRAW_LOOKUP_GLYPH:
        INC A
        CP $0B
        JP M,SELECT_FONT_GLYPH_BASE
        SUB $06

SELECT_FONT_GLYPH_BASE:
        LD HL,$027E
        LD BC,$000A

DRAW_LOOKUP_REPEAT:
        ADD HL,BC
        DEC A
        JP NZ,DRAW_LOOKUP_REPEAT
        EX DE,HL
        RET
; 8x10 display font. One source byte per raster row; # = set pixel, . = clear.
; Ten digits, blank, twenty-six letters, and one additional symbol.

; font digit 0 — 8x10
FONT_DIGIT_0:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font digit 1 — 8x10
FONT_DIGIT_1:
        DB $18  ; ...##...
        DB $1C  ; ...###..
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $3C  ; ..####..
        DB $3C  ; ..####..

; font digit 2 — 8x10
FONT_DIGIT_2:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $60  ; .##.....
        DB $7C  ; .#####..
        DB $3E  ; ..#####.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $7E  ; .######.
        DB $7E  ; .######.

; font digit 3 — 8x10
FONT_DIGIT_3:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $60  ; .##.....
        DB $38  ; ..###...
        DB $78  ; .####...
        DB $60  ; .##.....
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font digit 4 — 8x10
FONT_DIGIT_4:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $60  ; .##.....
        DB $60  ; .##.....
        DB $60  ; .##.....
        DB $60  ; .##.....

; font digit 5 — 8x10
FONT_DIGIT_5:
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $3E  ; ..#####.
        DB $7E  ; .######.
        DB $60  ; .##.....
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font digit 6 — 8x10
FONT_DIGIT_6:
        DB $3C  ; ..####..
        DB $3E  ; ..#####.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $3E  ; ..#####.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font digit 7 — 8x10
FONT_DIGIT_7:
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $60  ; .##.....
        DB $70  ; .###....
        DB $30  ; ..##....
        DB $38  ; ..###...
        DB $18  ; ...##...
        DB $1C  ; ...###..
        DB $0C  ; ....##..
        DB $0C  ; ....##..

; font digit 8 — 8x10
FONT_DIGIT_8:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font digit 9 — 8x10
FONT_DIGIT_9:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $7C  ; .#####..
        DB $60  ; .##.....
        DB $60  ; .##.....
        DB $7C  ; .#####..
        DB $3C  ; ..####..

; font blank — 8x10
FONT_BLANK:
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........
        DB $00  ; ........

; font letter a — 8x10
FONT_LETTER_A:
        DB $18  ; ...##...
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.

; font letter b — 8x10
FONT_LETTER_B:
        DB $3E  ; ..#####.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $3E  ; ..#####.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3E  ; ..#####.

; font letter c — 8x10
FONT_LETTER_C:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font letter d — 8x10
FONT_LETTER_D:
        DB $3E  ; ..#####.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3E  ; ..#####.

; font letter e — 8x10
FONT_LETTER_E:
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $7E  ; .######.
        DB $7E  ; .######.

; font letter f — 8x10
FONT_LETTER_F:
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.

; font letter g — 8x10
FONT_LETTER_G:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $76  ; .###.##.
        DB $76  ; .###.##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font letter h — 8x10
FONT_LETTER_H:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.

; font letter i — 8x10
FONT_LETTER_I:
        DB $3C  ; ..####..
        DB $3C  ; ..####..
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $3C  ; ..####..
        DB $3C  ; ..####..

; font letter j — 8x10
FONT_LETTER_J:
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $00  ; ........
        DB $00  ; ........
        DB $18  ; ...##...
        DB $18  ; ...##...

; font letter k — 8x10
FONT_LETTER_K:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $76  ; .###.##.
        DB $3E  ; ..#####.
        DB $1E  ; ...####.
        DB $1E  ; ...####.
        DB $3E  ; ..#####.
        DB $76  ; .###.##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.

; font letter l — 8x10
FONT_LETTER_L:
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $7E  ; .######.
        DB $7E  ; .######.

; font letter m — 8x10
FONT_LETTER_M:
        DB $C3  ; ##....##
        DB $C3  ; ##....##
        DB $E7  ; ###..###
        DB $E7  ; ###..###
        DB $FF  ; ########
        DB $FF  ; ########
        DB $DB  ; ##.##.##
        DB $C3  ; ##....##
        DB $C3  ; ##....##
        DB $C3  ; ##....##

; font letter n — 8x10
FONT_LETTER_N:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $6E  ; .##.###.
        DB $6E  ; .##.###.
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $76  ; .###.##.
        DB $76  ; .###.##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.

; font letter o — 8x10
FONT_LETTER_O:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font letter p — 8x10
FONT_LETTER_P:
        DB $3E  ; ..#####.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3E  ; ..#####.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.
        DB $06  ; .....##.

; font letter q — 8x10
FONT_LETTER_Q:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $36  ; ..##.##.
        DB $76  ; .###.##.
        DB $6C  ; .##.##..

; font letter r — 8x10
FONT_LETTER_R:
        DB $3E  ; ..#####.
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3E  ; ..#####.
        DB $76  ; .###.##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.

; font letter s — 8x10
FONT_LETTER_S:
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $06  ; .....##.
        DB $3E  ; ..#####.
        DB $7C  ; .#####..
        DB $60  ; .##.....
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font letter t — 8x10
FONT_LETTER_T:
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...

; font letter u — 8x10
FONT_LETTER_U:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..

; font letter v — 8x10
FONT_LETTER_V:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..
        DB $3C  ; ..####..
        DB $18  ; ...##...
        DB $18  ; ...##...

; font letter w — 8x10
FONT_LETTER_W:
        DB $C3  ; ##....##
        DB $C3  ; ##....##
        DB $C3  ; ##....##
        DB $DB  ; ##.##.##
        DB $FF  ; ########
        DB $FF  ; ########
        DB $E7  ; ###..###
        DB $E7  ; ###..###
        DB $C3  ; ##....##
        DB $C3  ; ##....##

; font letter x — 8x10
FONT_LETTER_X:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $3C  ; ..####..
        DB $7E  ; .######.
        DB $66  ; .##..##.
        DB $66  ; .##..##.

; font letter y — 8x10
FONT_LETTER_Y:
        DB $66  ; .##..##.
        DB $66  ; .##..##.
        DB $7E  ; .######.
        DB $3C  ; ..####..
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...
        DB $18  ; ...##...

; font letter z — 8x10
FONT_LETTER_Z:
        DB $7E  ; .######.
        DB $7E  ; .######.
        DB $60  ; .##.....
        DB $70  ; .###....
        DB $38  ; ..###...
        DB $1C  ; ...###..
        DB $0E  ; ....###.
        DB $06  ; .....##.
        DB $7E  ; .######.
        DB $7E  ; .######.

; font extra symbol — 8x10
FONT_EXTRA_SYMBOL:
        DB $08  ; ....#...
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $3E  ; ..#####.
        DB $7F  ; .#######
        DB $7F  ; .#######
IRQ_08_SERVICE:
        CALL SERVICE_TIMER_207C
        CALL APPLY_RENDER_MODE_2031
        CALL SAMPLE_INPUT_BIT6_EDGE
        CALL IRQ_SERVICE_TIMER_201F
        EI
        LD HL,$2004
        INC (HL)
        LD A,(HL)
        RRA
        JP NC,IRQ10_PROCESS_TIMER_STATE
        RRA
        LD HL,$2040
        JP C,IRQ08_PROCESS_INPUT_STATE
        LD HL,$204F

IRQ08_PROCESS_INPUT_STATE:
        LD A,(HL)
        AND A
        JP P,IRQ10_PROCESS_TIMER_STATE
        PUSH HL
        CALL IRQ_PROCESS_ACTIVE_OBJECT
        POP HL
        LD A,(HL)
        AND A
        JP P,IRQ10_PROCESS_TIMER_STATE
        LD A,($2004)
        AND $02
        LD HL,$205E
        JP NZ,IRQ08_UPDATE_OBJECT_STATE
        LD HL,$206D

IRQ08_UPDATE_OBJECT_STATE:
        LD A,(HL)
        AND A
        CALL M,IRQ_PROCESS_ACTIVE_OBJECT
        JP IRQ10_PROCESS_TIMER_STATE
; Save descriptor pointer and call native object update helpers.
IRQ_PROCESS_ACTIVE_OBJECT:
        PUSH HL
        PUSH HL
        CALL CLEAR_OBJECT_PENDING_BIT5
        POP HL
        CALL PROCESS_OBJECT_BIT6_FLAGS
        POP HL
        JP TEST_RENDER_FLAG_BIT2
; IRQ 10 native input/output service.
IRQ_10_SERVICE:
        CALL ADVANCE_COUNTER_207F
        EI
        LD A,($2004)
        RRA
        JP NC,IRQ10_PROCESS_TIMER_STATE
        LD B,A
        RRA
        LD HL,$2040
        JP C,IRQ10_PROCESS_INPUT_STATE
        LD HL,$204F

IRQ10_PROCESS_INPUT_STATE:
        LD A,(HL)
        AND A
        JP M,IRQ10_PROCESS_TIMER_STATE
        LD A,B
        RRA
        LD HL,$205E
        JP C,IRQ10_UPDATE_INPUT_FLAGS
        LD HL,$206D

IRQ10_UPDATE_INPUT_FLAGS:
        LD A,(HL)
        AND A
        CALL M,IRQ_PROCESS_ACTIVE_OBJECT

IRQ10_PROCESS_TIMER_STATE:
        POP HL
        POP DE
        POP BC
        POP AF
        RET
; Check countdown RAM $201F and update secondary input state.
IRQ_SERVICE_TIMER_201F:
        LD A,($201F)
        AND A
        RET Z
        LD HL,$200F
        LD A,(HL)
        AND A
        JP Z,IRQ10_SERVICE_NEXT_TIMER
        DEC (HL)
        RET

IRQ10_SERVICE_NEXT_TIMER:
        INC HL
        LD A,(HL)
        AND A
        JP Z,IRQ10_UPDATE_OBJECT_TIMER
        DEC (HL)
        DEC HL
        LD A,($200E)
        LD (HL),A
        RET

IRQ10_UPDATE_OBJECT_TIMER:
        INC HL
        LD A,(HL)
        AND A
        JP Z,IRQ10_ADVANCE_GAME_STATE
        DEC (HL)
        XOR A
        OUT ($05),A
        RET

IRQ10_ADVANCE_GAME_STATE:
        LD HL,($2012)
        LD A,(HL)
        AND A
        JP NZ,IRQ10_PROCESS_OBJECT_STATE
        XOR A
        OUT ($05),A
        LD ($201F),A
        LD A,($200D)
        AND A
        RET NZ
        OUT ($03),A
        RET

IRQ10_PROCESS_OBJECT_STATE:
        JP P,IRQ10_COMPLETE_INPUT_SERVICE
        AND $7F
        LD ($200E),A
        INC HL
        LD A,(HL)

IRQ10_COMPLETE_INPUT_SERVICE:
        LD ($2010),A
        INC HL
        LD A,($200E)
        LD B,A
        LD A,(HL)
        AND A
        JP M,IRQ10_EXIT_SERVICE
        LD A,$01
        LD ($2011),A
        DEC B

IRQ10_EXIT_SERVICE:
        LD A,B
        LD ($200F),A
        LD A,(HL)
        INC HL
        LD ($2012),HL
        AND $7F
        LD C,A
        LD B,$00
        LD HL,$04FB
        ADD HL,BC
        ADD HL,BC
        LD A,(HL)
        OUT ($05),A
        INC HL
        LD A,(HL)
        OUT ($06),A
        RET

SCREEN_POSITION_LOOKUP:
        DB $00,$00,$3F,$13,$1D,$16,$33,$18,$3F,$1A,$05,$1D
        DB $01,$1F,$39,$20,$27,$22,$11,$24,$35,$25,$13,$27
        DB $2B,$28,$3F,$29,$0F,$2B,$19,$2C,$1F,$2D,$21,$2E
        DB $21,$2F,$1D,$30,$15,$31,$09,$32,$3B,$32,$29,$33
        DB $17,$34,$3F,$34,$27,$35,$0D,$36,$31,$36,$11,$37
        DB $31,$37,$0F,$38,$2B,$38,$05,$39,$1D,$39,$35,$39
        DB $0B,$3A,$21,$3A
; Process object entry only when bit $40 is set; update activity flags.
PROCESS_OBJECT_BIT6_FLAGS:
        LD A,(HL)
        AND $40
        RET Z
        PUSH HL
        LD A,(HL)
        OR $20
        LD (HL),A
        AND $10
        LD C,A
        INC HL
        INC HL
        INC HL
        LD E,(HL)
        INC HL
        INC HL
        INC HL
        INC HL
        LD D,(HL)
        INC HL
        INC HL
        LD A,E
        AND $07
        DEC C
        JP M,SHIFT_OUTPUT_AND_READ_OBJECT_DESCRIPTOR
        CPL

SHIFT_OUTPUT_AND_READ_OBJECT_DESCRIPTOR:
        OUT ($01),A
        CALL SHIFT_VIDEO_ADDRESS_THREE
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        PUSH DE
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        LD A,(BC)
        INC BC
        LD E,A
        INC A
        LD (HL),A
        INC HL
        LD A,(BC)
        INC BC
        LD D,A
        LD (HL),A
        POP HL
        EX (SP),HL
        LD A,(HL)
        POP HL
        AND $10
        JP NZ,ADVANCE_INPUT_RECORD_OFFSET

PREPARE_INPUT_PORT3_RECORD:
        PUSH DE
        PUSH HL

COPY_INPUT_PORT3_RECORD_BYTE:
        LD A,(BC)
        INC BC
        OUT ($02),A
        IN A,($03)
        LD (HL),A
        INC HL
        DEC E
        JP NZ,COPY_INPUT_PORT3_RECORD_BYTE
        XOR A
        OUT ($02),A
        IN A,($03)
        LD (HL),A
        POP HL
        LD DE,$0020
        ADD HL,DE
        POP DE
        DEC D
        JP NZ,PREPARE_INPUT_PORT3_RECORD
        RET

ADVANCE_INPUT_RECORD_OFFSET:
        LD A,E
        ADD A,L
        LD L,A

PREPARE_INPUT_PORT0_RECORD:
        PUSH DE
        PUSH HL

COPY_INPUT_PORT0_RECORD_BYTE:
        LD A,(BC)
        INC BC
        OUT ($02),A
        IN A,($00)
        LD (HL),A
        DEC HL
        DEC E
        JP NZ,COPY_INPUT_PORT0_RECORD_BYTE
        XOR A
        OUT ($02),A
        IN A,($00)
        LD (HL),A
        POP HL
        LD DE,$0020
        ADD HL,DE
        POP DE
        DEC D
        JP NZ,PREPARE_INPUT_PORT0_RECORD
        RET
; Inspect and clear object flag bit $20 when active.
CLEAR_OBJECT_PENDING_BIT5:
        LD A,(HL)
        AND $20
        RET Z
        LD A,(HL)
        AND $DF
        LD (HL),A
        AND $08
        JP NZ,READ_OBJECT_DESCRIPTOR_POINTER
        LD (HL),A

READ_OBJECT_DESCRIPTOR_POINTER:
        LD DE,$000B
        ADD HL,DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD C,(HL)
        INC HL
        LD B,(HL)
        EX DE,HL
        LD DE,$0020
        XOR A

PREPARE_OBJECT_FIELD_FILL:
        PUSH BC
        PUSH HL

FILL_OBJECT_FIELD_BYTES:
        LD (HL),A
        INC HL
        DEC C
        JP NZ,FILL_OBJECT_FIELD_BYTES
        POP HL
        ADD HL,DE
        POP BC
        DEC B
        JP NZ,PREPARE_OBJECT_FIELD_FILL
        RET
; Guard on RAM $207C and update game service counters.
SERVICE_TIMER_207C:
        LD A,($207C)
        AND A
        RET NZ
        LD B,A
        LD HL,$2002
        DEC (HL)
        RET NZ
        LD (HL),$3C
        LD A,($2003)
        AND A
        JP NZ,RELOAD_TIMER_207C
        LD HL,$2008
        LD A,(HL)
        AND A
        JP Z,RELOAD_TIMER_207C
        ADD A,$99
        DAA
        LD (HL),A
        JP NZ,RELOAD_TIMER_207C
        LD B,$01

RELOAD_TIMER_207C:
        LD C,$01
        LD HL,$2030
        CALL DECREMENT_NONZERO_TIMER_BYTE
        LD ($207C),A
        RET
; Decrement pointed timer if positive and advance game state.
DECREMENT_NONZERO_TIMER_BYTE:
        LD A,(HL)
        AND A
        JP Z,ROTATE_OBJECT_FIELD_BITS
        DEC (HL)
        JP NZ,ROTATE_OBJECT_FIELD_BITS
        SCF

ROTATE_OBJECT_FIELD_BITS:
        LD A,B
        RLA
        LD B,A
        INC HL
        DEC C
        JP NZ,DECREMENT_NONZERO_TIMER_BYTE
        RET
; Check RAM $207D, then operate on render mode at $2031.
APPLY_RENDER_MODE_2031:
        LD HL,$2031
        LD A,($207D)
        AND A
        RET NZ
        LD B,A
        LD C,$08
        CALL DECREMENT_NONZERO_TIMER_BYTE
        LD ($207D),A
        LD A,($207E)
        AND A
        RET NZ
        LD B,A
        LD C,$07
        CALL DECREMENT_NONZERO_TIMER_BYTE
        LD ($207E),A
        RET

TEST_RENDER_FLAG_BIT2:
        LD A,(HL)
        AND $04
        RET Z
        PUSH HL
        INC HL
        LD C,(HL)
        LD B,$00
        INC HL
        LD A,(HL)
        LD D,A
        INC HL
        ADD A,(HL)
        LD (HL),A
        DEC D
        JP P,COMPARE_GUN_SHAPE_TABLE_BYTE
        CP $F0
        JP NC,CLEAR_OBJECT_FLAG_BIT3
        JP READ_OBJECT_POINTER_BYTES

COMPARE_GUN_SHAPE_TABLE_BYTE:
        PUSH HL
        LD HL,GRAPHIC_RESOURCE_06DC
        ADD HL,BC
        CP (HL)
        POP HL
        JP C,READ_OBJECT_POINTER_BYTES

CLEAR_OBJECT_FLAG_BIT3:
        EX (SP),HL
        LD A,(HL)
        AND $F7
        LD (HL),A
        EX (SP),HL

READ_OBJECT_POINTER_BYTES:
        INC HL
        LD D,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD A,(HL)
        INC HL
        LD B,(HL)
        ADD A,(HL)
        LD (HL),A
        CP D
        JP C,STORE_OBJECT_FIELD_AND_TEST_BIT1
        CP E
        JP C,INCREMENT_OBJECT_FIELD_COUNTER

STORE_OBJECT_FIELD_AND_TEST_BIT1:
        LD (HL),B
        EX (SP),HL
        LD A,(HL)
        AND $02
        EX (SP),HL
        JP NZ,CLEAR_PRIOR_OBJECT_FIELD
        DEC HL
        LD A,(HL)
        CPL
        INC A
        LD (HL),A
        INC HL

INCREMENT_OBJECT_FIELD_COUNTER:
        INC HL
        INC (HL)
        POP HL
        RET

CLEAR_PRIOR_OBJECT_FIELD:
        DEC HL
        LD (HL),$00
        INC HL
        JP INCREMENT_OBJECT_FIELD_COUNTER
; Increment RAM $207F and update related state.
ADVANCE_COUNTER_207F:
        LD HL,$207F
        INC (HL)
        LD A,(HL)
        LD DE,$2014
        LD BC,$007F
        RRA
        JP C,SAMPLE_INPUT_PORT1_AND_CLAMP
        LD BC,$086F
        INC DE

SAMPLE_INPUT_PORT1_AND_CLAMP:
        IN A,($01)
        SUB $10
        JP NC,CLAMP_INPUT_TO_COUNTER
        XOR A

CLAMP_INPUT_TO_COUNTER:
        CP C
        JP C,STORE_SHIFTED_INPUT_BYTE
        LD A,C

STORE_SHIFTED_INPUT_BYTE:
        RLA
        LD (DE),A
        INC HL
        LD A,(HL)
        AND $F7
        OR B
        LD (HL),A
        OUT ($07),A
        RET
; Packed gun and target drawing records consumed by native renderers.
; Original bitmap patterns and sprite shape records, spanning the ROM boundary
; at $0800. Pixel data is not executable 8080 instruction code.
; Original game artwork: indexed graphic resources referenced by the native
; frame selector and object motion records. Pixel data and packed drawing codes
; continue across the $07FF/$0800 ROM-device boundary without interruption.

; Graphic resource $06DC (8 bytes).
GUN_GRAPHICS_AND_SHAPE_DATA:
GRAPHIC_RESOURCE_06DC:
; Eight-pixel-wide source pattern; # = set bit, . = clear bit.
        DB $F0 ; ####....
        DB $E8 ; ###.#...
        DB $E8 ; ###.#...
        DB $E0 ; ###.....
        DB $E0 ; ###.....
        DB $E8 ; ###.#...
        DB $E8 ; ###.#...
        DB $F0 ; ####....

; Graphic resource $06E4 (46 bytes).
GRAPHIC_RESOURCE_06E4:
        DB $02,$16,$01,$04,$08,$1E,$3C,$0F,$F8,$4F,$FC,$07
        DB $FE,$07,$7F,$0F,$FE,$3F,$FC,$7F,$F0,$3F,$F9,$39
        DB $F8,$7F,$D0,$3F,$FC,$0F,$FC,$47,$FE,$07,$FF,$0D
        DB $E4,$1F,$C2,$3F,$C9,$77,$80,$03,$80,$21

; Graphic resource $0712 (17 bytes).
GRAPHIC_RESOURCE_0712:
        DB $01,$0F,$20,$20,$10,$10,$09,$09,$0D,$0F,$0F,$1E
        DB $16,$1C,$08,$08,$08

; Graphic resource $0723 (38 bytes).
GRAPHIC_RESOURCE_0723:
        DB $03,$0C,$00,$1C,$00,$00,$2A,$00,$00,$1C,$00,$E0
        DB $FF,$03,$10,$7F,$04,$08,$7F,$08,$04,$6B,$10,$04
        DB $3E,$10,$04,$1C,$10,$04,$08,$10,$04,$08,$10,$00
        DB $08,$00

; Graphic resource $0749 (38 bytes).
GRAPHIC_RESOURCE_0749:
        DB $03,$0C,$00,$1C,$00,$00,$2A,$00,$7F,$1C,$7F,$C0
        DB $FF,$01,$00,$7F,$00,$00,$7F,$00,$00,$6B,$00,$00
        DB $3E,$00,$00,$1C,$00,$00,$08,$00,$00,$08,$00,$00
        DB $08,$00

; Graphic resource $076F (38 bytes).
GRAPHIC_RESOURCE_076F:
        DB $03,$0C,$3F,$1C,$7E,$60,$2A,$03,$C0,$9C,$01,$80
        DB $FF,$00,$00,$7F,$00,$00,$7F,$00,$00,$6B,$00,$00
        DB $3E,$00,$00,$1C,$00,$00,$08,$00,$00,$08,$00,$00
        DB $08,$00

; Graphic resource $0795 (90 bytes).
GRAPHIC_RESOURCE_0795:
        DB $04,$16,$00,$00,$00,$61,$00,$00,$00,$63,$00,$00
        DB $00,$63,$00,$00,$00,$63,$00,$00,$00,$22,$00,$00
        DB $00,$7F,$00,$00,$80,$FF,$00,$00,$80,$EB,$00,$00
        DB $80,$EB,$00,$00,$00,$7F,$00,$F0,$80,$3E,$00,$F8
        DB $C3,$1D,$01,$FC,$FF,$09,$0E,$FF,$FF,$08,$F8,$F3
        DB $FF,$00,$E0,$70,$FE,$00,$00,$38,$F0,$07,$00,$4C
        DB $60,$04,$00,$44,$30,$04,$00,$C4,$18,$04,$00,$84
        DB $08,$00,$00,$04,$04,$00

; Graphic resource $07EF (17 bytes).
GRAPHIC_RESOURCE_07EF:
        DB $04,$16,$00,$00,$00,$61,$00,$00,$00,$63,$00,$00
        DB $00,$63,$00,$00,$00

        ORG $0800
; ROM device 9316.1g (second 2 KB device); packed artwork continues.

; Graphic resource $0800 (73 bytes).
GRAPHIC_RESOURCE_0800:
        DB $63,$00,$00,$00,$22,$00,$00,$00,$7F,$00,$00,$80
        DB $FF,$00,$00,$80,$FF,$00,$00,$80,$EB,$00,$00,$00
        DB $7F,$00,$F0,$80,$3E,$00,$F8,$C3,$1D,$01,$FC,$FF
        DB $09,$0E,$FF,$FF,$08,$F8,$F3,$FF,$00,$E0,$F0,$FC
        DB $00,$00,$70,$F0,$00,$00,$30,$60,$00,$00,$10,$20
        DB $00,$00,$10,$20,$00,$00,$10,$20,$00,$00,$10,$10
        DB $00

; Graphic resource $0849 (38 bytes).
GRAPHIC_RESOURCE_0849:
        DB $04,$16,$00,$00,$00,$61,$00,$00,$00,$63,$00,$00
        DB $00,$63,$00,$00,$00,$63,$00,$00,$00,$22,$00,$00
        DB $00,$7F,$00,$00,$80,$FF,$00,$00,$80,$EB,$00,$00
        DB $80,$EB

; Graphic resource $086F (52 bytes).
GRAPHIC_RESOURCE_086F:
        DB $00,$00,$00,$7F,$00,$F0,$80,$3E,$00,$F8,$C3,$1D
        DB $01,$FC,$FF,$09,$0E,$FF,$FF,$08,$F8,$F3,$FF,$00
        DB $E0,$70,$FE,$00,$00,$F0,$F0,$00,$00,$E8,$C1,$01
        DB $00,$8C,$23,$03,$00,$04,$12,$04,$00,$04,$0A,$02
        DB $00,$00,$01,$01

; Graphic resource $08A3 (46 bytes).
GRAPHIC_RESOURCE_08A3:
        DB $04,$0B,$00,$00,$F8,$F8,$00,$00,$88,$88,$00,$00
        DB $C8,$9F,$00,$C0,$E1,$3F,$C0,$41,$63,$32,$00,$07
        DB $66,$32,$0C,$06,$CE,$1F,$04,$0E,$BF,$0F,$0C,$CE
        DB $7F,$07,$38,$FF,$3F,$02,$F0,$FF,$1F,$02

; Graphic resource $08D1 (68 bytes).
GRAPHIC_RESOURCE_08D1:
        DB $03,$16,$00,$80,$00,$00,$00,$01,$00,$00,$02,$00
        DB $00,$0C,$00,$00,$F6,$00,$00,$7E,$00,$00,$07,$00
        DB $00,$03,$F0,$8F,$03,$F8,$FF,$01,$FD,$FF,$01,$FE
        DB $FF,$00,$FE,$FF,$00,$FC,$7F,$00,$FC,$70,$00,$38
        DB $20,$00,$30,$30,$00,$60,$10,$00,$40,$10,$00,$40
        DB $08,$00,$40,$08,$00,$40,$04,$00

; Graphic resource $0915 (80 bytes).
GRAPHIC_RESOURCE_0915:
        DB $03,$1A,$00,$20,$00,$00,$40,$00,$00,$80,$00,$00
        DB $00,$03,$00,$80,$3D,$00,$80,$1F,$00,$80,$03,$00
        DB $80,$03,$00,$80,$03,$00,$80,$03,$00,$F8,$01,$80
        DB $FF,$01,$F8,$FF,$01,$F8,$FF,$01,$FC,$FF,$00,$FD
        DB $DF,$00,$F8,$83,$01,$78,$00,$03,$38,$00,$02,$18
        DB $00,$01,$0C,$80,$00,$02,$00,$00,$02,$00,$00,$02
        DB $00,$00,$02,$00,$00,$02,$00,$00

; Graphic resource $0965 (56 bytes).
GRAPHIC_RESOURCE_0965:
        DB $03,$12,$00,$80,$00,$00,$00,$01,$00,$00,$02,$00
        DB $00,$0C,$00,$00,$F6,$00,$00,$7E,$00,$00,$07,$00
        DB $80,$03,$F0,$FF,$03,$FC,$FF,$01,$FF,$FF,$01,$FE
        DB $FF,$00,$FE,$FF,$00,$FE,$FF,$00,$FC,$E3,$00,$38
        DB $80,$01,$30,$00,$03,$3F,$F0,$01

; Graphic resource $099D (65 bytes).
GRAPHIC_RESOURCE_099D:
        DB $03,$15,$00,$80,$00,$00,$00,$01,$00,$00,$02,$00
        DB $00,$0C,$70,$00,$F6,$FD,$01,$7E,$FE,$07,$07,$FC
        DB $FF,$03,$FC,$FF,$01,$F8,$FF,$00,$F8,$7F,$00,$1F
        DB $3F,$00,$00,$1C,$00,$00,$04,$00,$00,$04,$00,$00
        DB $04,$00,$00,$0C,$00,$00,$08,$00,$00,$08,$00,$00
        DB $08,$00,$00,$08,$00

; Graphic resource $09DE (23 bytes).
GRAPHIC_RESOURCE_09DE:
        DB $03,$07,$00,$40,$00,$D0,$80,$00,$E0,$01,$01,$E0
        DB $07,$06,$F0,$0F,$7B,$E0,$FF,$3F,$FF,$F8,$07

; Graphic resource $09F5 (50 bytes).
GRAPHIC_RESOURCE_09F5:
        DB $02,$18,$80,$03,$C0,$07,$E0,$0F,$F0,$1F,$F8,$1F
        DB $F8,$3F,$FC,$3F,$CC,$33,$CC,$33,$CE,$33,$FE,$7F
        DB $CE,$73,$FF,$7F,$F6,$7E,$F7,$DE,$F7,$DF,$F3,$DF
        DB $FB,$CF,$F9,$CF,$F1,$9F,$F1,$8F,$61,$86,$40,$82
        DB $78,$3E

; Graphic resource $0A27 (62 bytes).
GRAPHIC_RESOURCE_0A27:
        DB $02,$1E,$80,$03,$C0,$07,$E0,$0F,$F0,$1F,$F8,$1F
        DB $F8,$3F,$FC,$3F,$CC,$33,$FC,$3F,$CE,$33,$CE,$73
        DB $CE,$73,$FE,$7F,$F6,$7E,$F7,$DE,$F7,$DF,$F3,$DF
        DB $FB,$CF,$F9,$CF,$F1,$9F,$F1,$8F,$61,$86,$40,$82
        DB $40,$02,$40,$02,$40,$02,$40,$02,$40,$02,$40,$02
        DB $78,$3E

; Graphic resource $0A65 (44 bytes).
GRAPHIC_RESOURCE_0A65:
        DB $02,$15,$80,$03,$C0,$07,$E0,$0F,$F0,$1F,$F8,$1F
        DB $F8,$3F,$FC,$3F,$CC,$33,$CC,$33,$CE,$33,$CE,$73
        DB $CE,$73,$FE,$7F,$FE,$7E,$F7,$DE,$F7,$DF,$F3,$BF
        DB $F3,$CF,$61,$86,$41,$82,$79,$DE

; Graphic resource $0A91 (30 bytes).
GRAPHIC_RESOURCE_0A91:
        DB $02,$0E,$E0,$07,$F0,$1F,$F8,$1F,$F8,$3F,$FC,$3F
        DB $CC,$33,$CC,$33,$CE,$33,$CE,$F3,$CE,$F3,$FE,$FF
        DB $6E,$9E,$42,$82,$7A,$BE

; Graphic resource $0AAF (20 bytes).
GRAPHIC_RESOURCE_0AAF:
        DB $02,$09,$E0,$07,$F0,$1F,$F8,$1F,$F8,$3F,$CC,$33
        DB $CE,$F3,$7E,$9E,$42,$82,$7A,$BE

; Graphic resource $0AC3 (56 bytes).
GRAPHIC_RESOURCE_0AC3:
        DB $03,$12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0
        DB $FF,$00,$38,$C6,$01,$BC,$D6,$03,$BE,$D6,$07,$3F
        DB $C6,$0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00
        DB $04,$00,$00,$04,$00,$00,$04,$00,$00,$04,$00,$00
        DB $04,$00,$00,$04,$00,$00,$1C,$00

; Graphic resource $0AFB (56 bytes).
GRAPHIC_RESOURCE_0AFB:
        DB $03,$12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0
        DB $FF,$00,$38,$C6,$01,$3C,$C6,$03,$BE,$D6,$07,$3F
        DB $C6,$0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00
        DB $04,$00,$00,$0C,$00,$00,$1A,$00,$00,$31,$00,$00
        DB $21,$00,$00,$21,$00,$00,$E7,$00

; Graphic resource $0B33 (56 bytes).
GRAPHIC_RESOURCE_0B33:
        DB $03,$12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0
        DB $FF,$00,$38,$C6,$01,$3C,$C6,$03,$3E,$C6,$07,$3F
        DB $C6,$0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00
        DB $04,$00,$00,$0A,$00,$00,$11,$00,$80,$20,$00,$40
        DB $40,$00,$20,$80,$00,$E0,$80,$03

; Graphic resource $0B6B (56 bytes).
GRAPHIC_RESOURCE_0B6B:
        DB $03,$12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0
        DB $FF,$00,$38,$C6,$01,$3C,$C6,$03,$BE,$D6,$07,$3F
        DB $C6,$0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00
        DB $04,$00,$00,$0A,$00,$00,$11,$00,$80,$10,$00,$40
        DB $10,$00,$20,$10,$00,$E0,$70,$00

; Graphic resource $0BA3 (32 bytes).
GRAPHIC_RESOURCE_0BA3:
        DB $02,$0F,$00,$20,$00,$38,$00,$3E,$00,$3F,$80,$3B
        DB $C0,$31,$E0,$20,$F0,$31,$B8,$3B,$1C,$3F,$0C,$3E
        DB $1C,$1F,$BC,$0F,$FE,$07,$FF,$03

; Graphic resource $0BC3 (35 bytes).
GRAPHIC_RESOURCE_0BC3:
        DB $03,$0B,$80,$1F,$00,$F8,$FF,$01,$FE,$FF,$07,$3F
        DB $C6,$0F,$7E,$EF,$07,$BC,$D6,$03,$78,$EF,$01,$F0
        DB $FF,$00,$E0,$7F,$00,$C0,$3F,$00,$00,$0F,$00

; Graphic resource $0BE6 (24 bytes).
GRAPHIC_RESOURCE_0BE6:
        DB $02,$0B,$C0,$01,$00,$01,$00,$01,$00,$01,$04,$01
        DB $04,$01,$04,$01,$87,$07,$FD,$0F,$FF,$1F,$00,$07

; Graphic resource $0BFE (38 bytes).
GRAPHIC_RESOURCE_0BFE:
        DB $02,$12,$00,$0E,$00,$0A,$00,$7E,$00,$06,$01,$06
        DB $0E,$06,$3C,$06,$F8,$07,$F8,$07,$F0,$03,$E0,$01
        DB $80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00
        DB $80,$03

; Graphic resource $0C24 (38 bytes).
GRAPHIC_RESOURCE_0C24:
        DB $02,$12,$00,$0E,$00,$0A,$00,$7E,$00,$06,$01,$06
        DB $0E,$06,$3C,$06,$F8,$07,$F8,$07,$F0,$03,$E0,$01
        DB $80,$00,$40,$01,$20,$02,$10,$02,$08,$02,$04,$02
        DB $1C,$0E

; Graphic resource $0C4A (38 bytes).
GRAPHIC_RESOURCE_0C4A:
        DB $02,$12,$00,$0E,$00,$0A,$00,$7E,$00,$06,$01,$06
        DB $0E,$06,$3C,$06,$F8,$07,$F8,$07,$F0,$03,$E0,$01
        DB $80,$00,$40,$01,$20,$02,$10,$04,$08,$08,$04,$10
        DB $1C,$70

; Graphic resource $0C70 (38 bytes).
GRAPHIC_RESOURCE_0C70:
        DB $02,$12,$00,$0E,$00,$0A,$00,$7E,$00,$06,$01,$06
        DB $0E,$06,$3C,$06,$F8,$07,$F8,$07,$F0,$03,$E0,$01
        DB $80,$00,$80,$01,$40,$03,$20,$06,$20,$04,$20,$04
        DB $E0,$1C

; Graphic resource $0C96 (29 bytes).
GRAPHIC_RESOURCE_0C96:
        DB $01,$1B,$18,$18,$18,$3C,$3C,$7E,$7E,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7E
        DB $3C,$3C,$7E,$7E,$FF

; Graphic resource $0CB3 (34 bytes).
GRAPHIC_RESOURCE_0CB3:
        DB $02,$10,$E0,$07,$C0,$03,$C0,$03,$F8,$1F,$FF,$FF
        DB $FF,$FF,$FF,$FF,$1F,$F0,$8F,$F4,$2F,$F1,$4F,$F4
        DB $0F,$F0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

; Graphic resource $0CD5 (28 bytes).
GRAPHIC_RESOURCE_0CD5:
        DB $01,$1A,$18,$18,$18,$18,$3C,$7E,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF

; Graphic resource $0CF1 (18 bytes).
GRAPHIC_RESOURCE_0CF1:
        DB $01,$10,$3C,$3C,$18,$18,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF

; Graphic resource $0D03 (32 bytes).
GRAPHIC_RESOURCE_0D03:
        DB $80,$00,$02,$00,$48,$00,$28,$00,$18,$00,$9B,$00
        DB $1E,$00,$3C,$00,$79,$00,$DC,$00,$1E,$00,$3F,$00
        DB $4C,$00,$40,$00,$C4,$00,$D2,$00

; Graphic resource $0D23 (6 bytes).
GRAPHIC_RESOURCE_0D23:
        DB $30,$00,$6C,$00,$FA,$00

; Graphic resource $0D29 (41 bytes).
GRAPHIC_RESOURCE_0D29:
        DB $03,$0D,$00,$70,$00,$00,$F8,$01,$00,$FC,$03,$00
        DB $3C,$0F,$00,$1E,$1E,$08,$1E,$BE,$18,$3F,$FF,$3C
        DB $3F,$EF,$BC,$FF,$C3,$FE,$FF,$80,$3F,$63,$00,$1E
        DB $42,$00,$0F,$C6,$00

; Graphic resource $0D52 (58 bytes).
GRAPHIC_RESOURCE_0D52:
        DB $04,$0E,$00,$00,$7C,$00,$00,$80,$FF,$01,$02,$F0
        DB $FF,$03,$04,$FF,$3F,$8F,$E8,$FF,$1F,$FE,$F2,$FF
        DB $9F,$FE,$E8,$FF,$3F,$FF,$04,$FF,$FF,$8F,$02,$FC
        DB $FF,$00,$00,$FC,$FF,$00,$00,$0C,$63,$00,$00,$18
        DB $C1,$00,$00,$10,$81,$00,$00,$30,$83,$01

; Graphic resource $0D8C (58 bytes).
GRAPHIC_RESOURCE_0D8C:
        DB $04,$0E,$00,$00,$7C,$00,$00,$80,$FF,$01,$02,$F0
        DB $FF,$03,$04,$FF,$3F,$0F,$E8,$FF,$1F,$BE,$F2,$FF
        DB $5F,$FE,$E8,$FF,$3F,$FF,$04,$FF,$FF,$CF,$02,$FC
        DB $FF,$83,$00,$FC,$FF,$00,$00,$0C,$63,$00,$00,$84
        DB $21,$00,$00,$84,$20,$00,$00,$8C,$61,$00

; Graphic resource $0DC6 (58 bytes).
GRAPHIC_RESOURCE_0DC6:
        DB $04,$0E,$00,$00,$7C,$00,$00,$80,$FF,$01,$02,$F0
        DB $FF,$03,$04,$FF,$3F,$8F,$E8,$FF,$9F,$FE,$F2,$FF
        DB $1F,$FE,$E8,$FF,$3F,$FF,$04,$FF,$FF,$8F,$02,$FC
        DB $FF,$03,$00,$FC,$FF,$00,$00,$8C,$61,$00,$00,$06
        DB $33,$00,$00,$02,$12,$00,$00,$06,$36,$00

; Graphic resource $0E00 (44 bytes).
GRAPHIC_RESOURCE_0E00:
        DB $03,$0E,$80,$3F,$3F,$80,$F0,$23,$80,$F8,$23,$80
        DB $FE,$23,$00,$DE,$22,$80,$F3,$23,$E0,$C1,$01,$F0
        DB $C3,$00,$F8,$CF,$00,$F8,$0F,$00,$FA,$0F,$00,$FF
        DB $07,$00,$E3,$03,$00,$F2,$7F,$00

; Graphic resource $0E2C (113 bytes).
GRAPHIC_RESOURCE_0E2C:
        DB $03,$25,$00,$18,$00,$00,$38,$00,$00,$38,$38,$00
        DB $38,$38,$00,$70,$08,$00,$70,$0C,$00,$70,$0C,$00
        DB $60,$0C,$00,$60,$06,$00,$E0,$07,$00,$E0,$07,$00
        DB $A0,$05,$00,$E0,$07,$00,$C0,$03,$00,$F0,$03,$00
        DB $B8,$01,$00,$3C,$01,$00,$1E,$00,$00,$3F,$00,$80
        DB $FF,$03,$C0,$07,$03,$C0,$07,$03,$E0,$07,$00,$E0
        DB $03,$00,$E0,$03,$00,$F0,$03,$00,$F0,$01,$00,$F6
        DB $01,$00,$FF,$03,$00,$C6,$07,$00,$80,$07,$00,$00
        DB $07,$00,$00,$03,$00,$80,$01,$00,$C0,$01,$00,$C0
        DB $00,$00,$E0,$0F,$00

; Graphic resource $0E9D (101 bytes).
GRAPHIC_RESOURCE_0E9D:
        DB $03,$21,$00,$18,$00,$00,$38,$00,$00,$38,$78,$00
        DB $38,$78,$00,$70,$48,$00,$70,$0C,$00,$70,$0C,$00
        DB $60,$0C,$00,$60,$06,$00,$E0,$07,$00,$E0,$07,$00
        DB $A0,$05,$00,$E0,$07,$00,$E0,$03,$00,$B0,$03,$00
        DB $B8,$01,$00,$3C,$01,$00,$1E,$00,$00,$3F,$00,$80
        DB $FF,$1F,$C0,$07,$00,$C0,$07,$00,$E0,$07,$00,$E0
        DB $03,$00,$E0,$0F,$00,$F0,$1F,$00,$F0,$1F,$00,$F6
        DB $1F,$00,$1F,$0C,$00,$06,$06,$00,$00,$07,$00,$00
        DB $03,$00,$80,$3F,$00

; Graphic resource $0F02 (95 bytes).
GRAPHIC_RESOURCE_0F02:
        DB $03,$1F,$00,$18,$00,$00,$38,$00,$00,$38,$38,$00
        DB $38,$38,$00,$70,$08,$00,$70,$0C,$00,$70,$0C,$00
        DB $60,$0C,$00,$60,$06,$00,$E0,$07,$00,$E0,$07,$00
        DB $A0,$05,$00,$E0,$07,$00,$E0,$03,$00,$B0,$03,$00
        DB $B8,$01,$00,$3C,$01,$00,$1E,$00,$00,$3F,$00,$80
        DB $FF,$03,$C0,$07,$03,$C0,$07,$03,$E0,$07,$00,$E0
        DB $03,$00,$E0,$07,$00,$F0,$1F,$00,$E0,$1F,$00,$F6
        DB $1F,$00,$FF,$0F,$00,$C6,$07,$00,$E0,$FF,$00
; Indexed-command vector table. Twelve native handlers; $00 enters scheduler directly.
; $00 FRAME_HANDOFF: Zero command branches to frame scheduler $11EA; table entry is bypassed.
WORD_VECTOR_00_FRAME_HANDOFF:
        DW WORD_RETURN_STUB

; $01 DRAW_MODE_A: Draw with $0132 continuation; consumes width/count byte.
WORD_VECTOR_01_DRAW_MODE_A:
        DW WORD_01_DRAW_MODE_A_ENTRY

; $02 SET_RENDER_MODE: Read byte and store in RAM $2031.
WORD_VECTOR_02_SET_RENDER_MODE:
        DW WORD_02_SET_MODE_ENTRY

; $03 SET_MODE_AND_POINTER: Read mode byte $2030 and 16-bit pointer $2019.
WORD_VECTOR_03_SET_MODE_AND_POINTER:
        DW WORD_03_SET_MODE_POINTER_ENTRY

; $04 GOTO_SCRIPT: Read inline 16-bit destination into script PC $2000.
WORD_VECTOR_04_GOTO_SCRIPT:
        DW WORD_04_SCRIPT_GOTO_ENTRY

; $05 STORE_IMMEDIATE: Write inline byte to inline 16-bit address.
WORD_VECTOR_05_STORE_IMMEDIATE:
        DW WORD_05_STORE_BYTE_ENTRY

; $06 CLEAR_DISPLAY: Zero display RAM by stack pushes; resume via saved continuation.
WORD_VECTOR_06_CLEAR_DISPLAY:
        DW WORD_06_CLEAR_VIDEO_ENTRY

; $07 INIT_DESCRIPTOR: Initialize fixed descriptor bytes at $2040–$204A.
WORD_VECTOR_07_INIT_DESCRIPTOR:
        DW WORD_07_INIT_DESCRIPTOR_ENTRY

; $08 INIT_DRAW_BRANCH: Decode descriptor and read two 16-bit inline pointers.
WORD_VECTOR_08_INIT_DRAW_BRANCH:
        DW WORD_08_DRAW_BRANCH_ENTRY

; $09 DRAW_MODE_B: Draw with alternate $0167 continuation.
WORD_VECTOR_09_DRAW_MODE_B:
        DW WORD_09_DRAW_MODE_B_ENTRY

; $0A CLEAR_FLAG_BIT3: Read address16 and clear its bit $08.
WORD_VECTOR_0A_CLEAR_FLAG_BIT3:
        DW WORD_0A_CLEAR_FLAG_ENTRY

; $0B RESET_ROUND: Reset round/game state and select script $1676.
WORD_VECTOR_0B_RESET_ROUND:
        DW WORD_0B_RESET_SCENE_ENTRY

; $0C DRAW_PACKET: Read byte and two address16 values; jump to renderer.
WORD_VECTOR_0C_DRAW_PACKET:
        DW WORD_0C_DRAW_PACKET_ENTRY

; Word $0C: consume byte and two 16-bit pointers; transfer to drawing service.
WORD_0C_DRAW_PACKET_ENTRY:
        EX DE,HL
        LD A,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        PUSH DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD ($2000),HL
        POP HL
        JP DRAW_ENCODED_GRAPHIC

; Word $09: choose drawing continuation $0167.
WORD_09_DRAW_MODE_B_ENTRY:
        LD HL,$0167
        JP WORD_DRAW_COMMON

; Word $01: choose drawing continuation $0132.
WORD_01_DRAW_MODE_A_ENTRY:
        LD HL,$0132

WORD_DRAW_COMMON:
        PUSH HL
        EX DE,HL
        LD C,(HL)
        INC HL
        LD ($2000),HL
        CALL RENDER_WORD_PACKET
        RET

; Word $02: write one byte to RAM $2031.
WORD_02_SET_MODE_ENTRY:
        EX DE,HL
        LD A,(HL)
        LD ($2031),A
        INC HL
        LD ($2000),HL

WORD_RETURN_STUB:
        RET

; Word $03: store mode at $2030 and pointer at $2019.
WORD_03_SET_MODE_POINTER_ENTRY:
        EX DE,HL
        LD A,(HL)
        LD ($2030),A
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD ($2000),HL
        EX DE,HL
        LD ($2019),HL
        RET

; Word $04: load inline script destination into RAM $2000.
WORD_04_SCRIPT_GOTO_ENTRY:
        EX DE,HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        EX DE,HL
        LD ($2000),HL
        RET

; Word $05: write immediate byte into inline 16-bit RAM address.
WORD_05_STORE_BYTE_ENTRY:
        EX DE,HL
        LD A,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD ($2000),HL
        LD (DE),A
        RET

; Word $06: clear video RAM via stack writes; resume at saved native continuation.
WORD_06_CLEAR_VIDEO_ENTRY:
        POP HL
        LD SP,$4030

CLEAR_VIDEO_STACK_LOOP_START:
        DI
        LD BC,$0000
        XOR A

CLEAR_VIDEO_PUSH_LOOP:
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        DEC A
        JP NZ,CLEAR_VIDEO_PUSH_LOOP
        LD SP,$2400
        JP (HL)
; Read width/height bytes from HL and set up source/destination.
COPY_SCREEN_ROW_DESCRIPTOR:
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        EX DE,HL
; Copy C bytes per row, advance destination by $20 per row.
COPY_SCREEN_ROW_LOOP:
        PUSH BC
        PUSH HL

COPY_SCREEN_ROW_BYTE:
        LD A,(DE)
        INC DE
        LD (HL),A
        INC HL
        DEC C

        ORG $1000
; ROM device 9316.1f, SHA1 1cc4e9b0aa7e9546c133bd40d40ede6f2fbe93ba

        JP NZ,COPY_SCREEN_ROW_BYTE
        POP HL
        LD BC,$0020
        ADD HL,BC
        POP BC
        DEC B
        JP NZ,COPY_SCREEN_ROW_LOOP
        RET

; Word $07: initialize descriptor bytes in RAM $2040–$204A.
WORD_07_INIT_DESCRIPTOR_ENTRY:
        LD HL,$204A
        LD BC,$0BFE
        LD (HL),B
        DEC HL
        LD (HL),C
        DEC HL
        LD (HL),$00
        DEC HL
        LD (HL),$30
        DEC HL
        LD (HL),$01
        DEC HL
        LD (HL),$4A
        DEC HL
        LD (HL),$0C
        DEC HL
        LD (HL),$00
        DEC HL
        LD (HL),$02
        DEC HL
        LD (HL),$00
        DEC HL
        LD (HL),$CC
        RET
; Rotate input nibble and update drawing descriptor state.
DECODE_DESCRIPTOR_NIBBLE:
        LD A,(DE)
        RRA
        RRA
        RRA
        RRA
        AND $0F
        ADD A,$30
        LD (BC),A
        INC BC
        LD A,(DE)
        AND $0F
        ADD A,$30
        LD (BC),A
        INC BC
        INC DE
        RET

; Word $08: configure rendering and branch to second inline pointer.
WORD_08_DRAW_BRANCH_ENTRY:
        EX DE,HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD BC,$2083
        PUSH BC
        PUSH HL
        PUSH BC
        CALL DECODE_DESCRIPTOR_NIBBLE
        CALL DECODE_DESCRIPTOR_NIBBLE
        LD A,$30
        LD (BC),A
        POP HL
        CALL NORMALIZE_RENDER_DESCRIPTOR
        POP HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD ($2000),HL
        POP HL
        LD A,$05
        JP DRAW_ENCODED_GRAPHIC

; Word $0A: clear bit $08 in byte at inline address.
WORD_0A_CLEAR_FLAG_ENTRY:
        EX DE,HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD ($2000),HL
        LD A,(DE)
        AND $F7
        LD (DE),A
        RET

; Word $0B: decrement round count and install script root $1676.
WORD_0B_RESET_SCENE_ENTRY:
        LD HL,$2018
        LD A,(HL)
        AND A
        RET Z
        DEC (HL)
        LD HL,$1676
        LD ($2000),HL
        LD HL,($201C)
        LD ($200B),HL
        LD A,$08
        OUT ($07),A
        IN A,($02)
        AND $03
        LD C,A
        LD B,$00
        LD HL,$10AE
        ADD HL,BC
        LD A,(HL)
        LD ($2008),A
        LD A,$08
        OUT ($03),A
        LD ($201F),A
        LD HL,$10B2
        LD ($2012),HL
        RET

; Object sequence data: selection/control header followed by event/count pairs.
; High-bit control markers $84/$85 separate sequence groups; $00 terminates groups.
OBJECT_SEQUENCE_TABLE:
        DB $43,$53,$63,$73,$84 ; sequence-selection header
        DB $01,$08,$01,$0D,$01,$11,$01
        DB $08,$01,$0D,$01,$11,$01,$08,$01,$0D,$02,$11,$02
        DB $00,$01,$12,$01,$11,$01,$00,$01,$11,$01,$0F,$01
        DB $00,$01,$0F,$03,$0D,$00,$85,$01,$00,$01,$0C,$02
        DB $0F,$01,$0C,$01,$0D,$02,$0F,$01,$00,$01,$0C,$02
        DB $0F,$01,$0C,$01,$0D,$03,$0F,$00,$85,$02,$08,$02
        DB $0D,$02,$0F,$02,$12,$08,$11,$02,$08,$02,$0D,$02
        DB $0F,$01,$12,$01,$11,$01,$0F,$07,$11,$00,$85,$02
        DB $0A,$01,$0A,$02,$0A,$01,$0A,$02,$0A,$01,$0A,$02
        DB $11,$01,$0E,$02,$11,$01,$0E,$02,$11,$01,$0E,$03
        DB $0A,$00,$85,$04,$0D,$03,$0C,$01,$0D,$02,$0A,$03
        DB $0D,$01,$00,$02,$0F,$02,$10,$02,$11,$02,$12,$02
        DB $13,$04,$14,$00

RENDER_FRAME_DESCRIPTOR:
        LD DE,$2008
        LD BC,$2083
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        PUSH BC
        CALL DECODE_DESCRIPTOR_NIBBLE
        POP HL
        CALL NORMALIZE_RENDER_DESCRIPTOR
        POP HL
        LD A,$02
        LD DE,$2400
        CALL DRAW_ENCODED_GRAPHIC
        LD C,$03
        CALL RENDER_WORD_PACKET
        CALL DRAW_ENCODED_GRAPHIC
        POP HL
        LD BC,$4006

FILL_RENDER_DESCRIPTOR_BYTES:
        LD (HL),B
        INC HL
        DEC C
        JP NZ,FILL_RENDER_DESCRIPTOR_BYTES
        POP HL
        LD A,($20B9)
        AND A
        JP Z,DRAW_INITIAL_RENDER_SCENE

FILL_RENDER_DESCRIPTOR_5B:
        LD (HL),$5B
        INC HL
        DEC A
        JP NZ,FILL_RENDER_DESCRIPTOR_5B

DRAW_INITIAL_RENDER_SCENE:
        POP HL
        LD A,$06
        LD DE,$240C
        CALL DRAW_ENCODED_GRAPHIC
        LD C,$04
        CALL RENDER_WORD_PACKET
        CALL DRAW_ENCODED_GRAPHIC
        LD DE,$2009
        POP BC
        CALL DECODE_DESCRIPTOR_NIBBLE
        CALL DECODE_DESCRIPTOR_NIBBLE
        LD A,$30
        LD (BC),A
        POP HL
        CALL NORMALIZE_RENDER_DESCRIPTOR
        POP HL
        LD A,$05
        LD DE,$241B
        JP DRAW_ENCODED_GRAPHIC

NORMALIZE_RENDER_DESCRIPTOR:
        LD C,$04

REPLACE_RENDER_CONTROL_CHARACTER:
        LD A,(HL)
        CP $30
        RET NZ
        LD (HL),$40
        INC HL
        DEC C
        JP NZ,REPLACE_RENDER_CONTROL_CHARACTER
        RET
; Normal boot path stages $11C3 as continuation after video clear.
BOOT_MAIN_ENTRY:
        LD HL,$11C3
        LD SP,$4000
        JP CLEAR_VIDEO_STACK_LOOP_START
; Boot continuation from $11BA -> $0FD7 -> JP (HL).
; Set script PC RAM $2000 to ROM $1633, push dispatcher return $11C9, enable IRQ and output port $04.
BOOT_SCRIPT_AFTER_VIDEO_CLEAR:
        LD HL,$1633
        LD ($2000),HL

BOOT_PUSH_INTERPRETER_RETURN:
        LD HL,$11C9
        PUSH HL
        EI
        OUT ($04),A
; Read script opcode via RAM $2000. Zero branches to frame scheduler; nonzero indexes vectors at $0F61.
; Read token through script PC at RAM $2000, then dispatch through $0F61.
BYTECODE_FETCH_DISPATCH:
        LD HL,($2000)
        LD A,(HL)
        AND A
        JP Z,BYTECODE_ZERO_FRAME_HANDOFF
        INC HL
        LD ($2000),HL
        EX DE,HL
        LD HL,$0F61
        RLCA
        LD C,A
        LD B,$00
        ADD HL,BC
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        JP (HL)

WORD_ZERO_FRAME_SCHEDULER:
; Run native frame services; conditional extra services depend on RAM $200D.
; Token $00 yields to the native frame scheduler at $11EA.
BYTECODE_ZERO_FRAME_HANDOFF:
        CALL FRAME_SERVICE_12E5
        CALL FRAME_SERVICE_12B1
        CALL FRAME_SERVICE_129E
        CALL FRAME_SERVICE_1936
        CALL SERVICE_GAME_STATE_201E
        CALL FRAME_REBUILD_OBJECTS
        CALL UPDATE_OBJECT_PAIRS
        LD A,($200D)
        AND A
        RET Z
        CALL FRAME_SERVICE_1318
        CALL RENDER_FRAME_DESCRIPTOR
        CALL CHECK_START_INPUT_EDGE
        RET

SELECT_GAME_RECORD:
        LD HL,$2031
        LD DE,$000F

ADVANCE_GAME_RECORD_OFFSET:
        ADD HL,DE
        DEC A
        JP P,ADVANCE_GAME_RECORD_OFFSET
        RET
; Visit object field at RAM $2085 with game-state parameters.
UPDATE_OBJECT_FIELDS_2085:
        LD HL,$2085
        LD DE,$203B
        LD BC,$0008

SCAN_NONZERO_OBJECT_FIELD:
        INC DE
        ADD HL,BC
        LD A,(HL)
        AND A
        JP NZ,SCAN_NONZERO_OBJECT_FIELD
        RET
; OR register B into RAM $2080.
OR_GAME_FLAGS_2080:
        LD DE,$2080
        LD A,(DE)
        OR B
        LD (DE),A
        RET
; Read game-state entry at RAM $201E and branch on flags.
SERVICE_GAME_STATE_201E:
        PUSH HL
        LD HL,$201E
        LD C,$00
        LD A,(HL)
        AND A
        JP NZ,ENCODE_GAME_STATUS_BITS
        DEC A

ENCODE_GAME_STATUS_BITS:
        LD B,A
        AND $1D
        JP PE,STORE_GAME_STATUS_BITS
        LD C,$80

STORE_GAME_STATUS_BITS:
        LD A,B
        RRCA
        AND $7F
        ADD A,C
        LD (HL),A
        POP HL
        RET
; Process object pairs $2040/$204F and $205E/$206D.
UPDATE_OBJECT_PAIRS:
        LD HL,$2040
        LD DE,$204F
        CALL COMPARE_OBJECT_PAIR_FLAGS
        LD HL,$205E
        LD DE,$206D
; Test two linked object records before update.
COMPARE_OBJECT_PAIR_FLAGS:
        LD A,(HL)
        AND A
        RET P
        LD A,(DE)
        AND A
        RET P
        PUSH DE
        CALL SCAN_OBJECT_FIELD_FLAGS
        POP HL
        INC HL
        INC HL
        LD A,(HL)
        AND A
        RET P
        INC HL
        LD A,(HL)
        SUB $88
        RET NC
        DEC HL
        LD A,(HL)
        CPL
        INC A
        LD (HL),A
        DEC HL
        DEC HL
        LD A,(HL)
        AND $EF
        LD (HL),A
        RET
; Advance through object fields and test record state.
SCAN_OBJECT_FIELD_FLAGS:
        INC HL
        LD C,(HL)
        INC HL
        LD A,(HL)
        AND A
        RET M
        LD B,$00
        INC HL
        EX DE,HL
        LD HL,GRAPHIC_RESOURCE_06DC
        ADD HL,BC
        LD A,(HL)
        SUB $80
        EX DE,HL
        CP (HL)
        RET NC
        DEC HL
        LD A,(HL)
        CPL
        INC A
        LD (HL),A
        DEC HL
        DEC HL
        LD A,(HL)
        OR $10
        LD (HL),A
        RET

FRAME_SERVICE_129E:
        LD HL,$207C
        LD A,(HL)
        AND A
        RET Z
        LD (HL),$00
        RRA
        PUSH AF
        CALL C,RESTORE_SCRIPT_POINTER_FROM_RENDER_STATE
        POP AF
        RRA
        CALL C,INCREMENT_GAME_SEQUENCE_COUNTER
        RET

FRAME_SERVICE_12B1:
        LD HL,$207D
        LD A,(HL)
        AND A
        RET Z
        LD (HL),$00
        RRA
        PUSH AF
        CALL C,UPDATE_SECOND_OBJECT_WHEN_ENABLED
        POP AF
        RRA
        PUSH AF
        CALL C,UPDATE_FIRST_OBJECT_WHEN_ENABLED
        POP AF
        RRA
        PUSH AF
        CALL C,ENABLE_GAME_AND_UPDATE_OBJECT_FLAGS
        POP AF
        RRA
        PUSH AF
        CALL C,WRITE_GAME_STATUS_2035
        POP AF
        RRA
        PUSH AF
        CALL C,WRITE_SOUND_PORT_AND_TEST_GAME_FLAGS
        POP AF
        RRA
        PUSH AF
        CALL C,ADVANCE_GAME_ANIMATION_COUNTER
        POP AF
        RRA
        RRA
        PUSH AF
        CALL C,ADVANCE_INTERPRETED_SCRIPT_POINTER
        POP AF
        RET

FRAME_SERVICE_12E5:
        LD HL,$207E
        LD A,(HL)
        AND A
        RET Z
        LD (HL),$00
        RRA
        PUSH AF
        CALL C,SELECT_OBJECT_TIMER_20A5
        POP AF
        RRA
        PUSH AF
        CALL C,SELECT_OBJECT_TIMER_209D
        POP AF
        RRA
        PUSH AF
        CALL C,SELECT_OBJECT_TIMER_2095
        POP AF
        RRA
        PUSH AF
        CALL C,SELECT_OBJECT_TIMER_208D
        POP AF
        RRA
        PUSH AF
        CALL C,TEST_SCENE_STATE_FOR_RESET
        POP AF
        RRA
        PUSH AF
        CALL C,DECREMENT_GAME_FLAG_TIMER
        POP AF
        RRA
        PUSH AF
        CALL C,READ_SCORE_RENDER_ADDRESS
        POP AF
        RET

FRAME_SERVICE_1318:
        LD HL,$2037
        LD A,(HL)
        AND A
        JP NZ,TEST_OBJECT_FIELD_FOR_UPDATE
        LD A,($2040)
        AND A
        JP M,TEST_OBJECT_FIELD_FOR_UPDATE
        LD A,($204F)
        AND A
        CALL P,WRITE_GAME_STATUS_OBJECT_FIELD

TEST_OBJECT_FIELD_FOR_UPDATE:
        INC HL
        LD A,(HL)
        AND A
        RET NZ
        LD A,($205E)
        AND A
        RET M
        LD A,($206D)
        AND A
        RET M

WRITE_GAME_STATUS_OBJECT_FIELD:
        CALL SERVICE_GAME_STATE_201E
        AND $3F
        OR $20
        LD (HL),A
        RET

WRITE_GAME_STATUS_2035:
        CALL SERVICE_GAME_STATE_201E
        AND $3F
        OR $20
        LD ($2035),A
        LD A,($20BA)
        AND A
        RET NZ
        LD A,$03

SCAN_GAME_RECORD_FLAGS:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND A
        JP P,ADVANCE_GAME_RECORD_SCAN
        AND $02
        JP NZ,ADVANCE_GAME_RECORD_SCAN
        PUSH HL
        CALL CHECK_OBJECT_STATUS_LOW_BITS
        POP HL
        CALL UPDATE_GAME_TIMER_2032

ADVANCE_GAME_RECORD_SCAN:
        POP AF
        DEC A
        JP P,SCAN_GAME_RECORD_FLAGS
        RET
; Check enable RAM $200D and timer RAM $2032.
UPDATE_GAME_TIMER_2032:
        LD A,($200D)
        AND A
        RET Z
        LD A,($2032)
        AND A
        RET NZ
        INC HL
        LD A,(HL)
        DEC HL
        AND $07
        JP Z,TOGGLE_GAME_STATUS_BIT4
        LD A,($2009)
        CP $02
        RET M

TOGGLE_GAME_STATUS_BIT4:
        CALL SERVICE_GAME_STATE_201E
        RLA
        RET C
        LD A,(HL)
        XOR $10
        AND $FB
        LD (HL),A
        INC HL
        LD A,(HL)
        AND A
        CALL Z,CHECK_OBJECT_UPDATE_LOCK
        INC HL
        LD A,(HL)
        CPL
        INC A
        LD (HL),A
        LD A,$0C
        LD ($203B),A
        RET
; Mask object status low three bits and compare with five.
CHECK_OBJECT_STATUS_LOW_BITS:
        INC HL
        LD A,(HL)
        AND $07
        CP $05
        RET P
        LD DE,$0005
        ADD HL,DE
        CALL SERVICE_GAME_STATE_201E
        AND $03
        LD (HL),A
        CALL SERVICE_GAME_STATE_201E
        RRA
        RET C
        LD A,(HL)
        CPL
        INC A
        LD (HL),A
        RET

UPDATE_FIRST_OBJECT_WHEN_ENABLED:
        LD A,($20BA)
        AND A
        RET NZ
        LD HL,$2040
        LD A,(HL)
        AND A
        RET M
        CALL INITIALIZE_OBJECT_TIMER_2032
        ADD A,$0C
        LD DE,$14F3
        CALL SET_OBJECT_FLAG_ACTIVE
        LD (HL),$CC
        CALL SERVICE_GAME_STATE_201E
        RRA
        RET C
        LD HL,$204F
        LD A,(HL)
        AND A
        RET M
        CALL INITIALIZE_OBJECT_TIMER_2032
        ADD A,$0C
        LD DE,$14F3
        CALL SET_OBJECT_FROM_SHAPE_TABLE
        LD (HL),$DC
        RET

UPDATE_SECOND_OBJECT_WHEN_ENABLED:
        LD A,($20BA)
        AND A
        RET NZ
        LD HL,$205E
        LD A,(HL)
        AND A
        RET M
        CALL INITIALIZE_OBJECT_TIMER_2032
        ADD A,$66
        LD DE,$14E3
        CALL SET_OBJECT_FLAG_ACTIVE
        LD (HL),$CC
        CALL SERVICE_GAME_STATE_201E
        RET C
        LD HL,$206D
        LD A,(HL)
        AND A
        RET M
        CALL INITIALIZE_OBJECT_TIMER_2032
        ADD A,$66
        LD DE,$14E3
        CALL SET_OBJECT_FROM_SHAPE_TABLE
        LD (HL),$DC
        RET
; Set timer RAM $2032 to $3C and prepare object state.
INITIALIZE_OBJECT_TIMER_2032:
        LD DE,$000A
        ADD HL,DE
        PUSH HL
        LD A,$3C
        LD ($2032),A
        CALL SERVICE_GAME_STATE_201E
        AND $0F
        LD C,A
        LD B,$00
        LD HL,$14BB
        ADD HL,BC
        LD A,(HL)
        LD C,A
        CP $07
        JP NZ,LOOKUP_OBJECT_TABLE_POINTER
        LD ($2081),A

LOOKUP_OBJECT_TABLE_POINTER:
        LD HL,FRAME_GRAPHIC_RESOURCE_POINTERS
        ADD HL,BC
        ADD HL,BC
        LD E,(HL)
        INC HL
        LD D,(HL)
        POP HL
        LD (HL),D
        DEC HL
        LD (HL),E
        DEC HL
        LD (HL),B
        DEC HL
        CP $05
        RET P
        LD A,($201E)
        AND $3F
        RET
; Write object byte, then lookup associated table values.
STORE_OBJECT_FIELD_AND_LOOKUP:
        LD (HL),A
        DEC HL
        PUSH HL
        LD HL,$14DB
        ADD HL,BC
        LD A,(HL)
        EX (SP),HL
        LD (HL),A
        DEC HL
        EX (SP),HL
        EX DE,HL
        ADD HL,BC
        ADD HL,BC
        LD E,(HL)
        INC HL
        LD D,(HL)
        POP HL
        LD (HL),D
        DEC HL
        LD (HL),E
        DEC HL
        RET
; Index graphics data from ROM $06DC.
FETCH_GUN_SHAPE_TABLE_BYTE:
        EX DE,HL
        LD HL,GRAPHIC_RESOURCE_06DC
        ADD HL,BC
        LD A,(HL)
        DEC A
        EX DE,HL
        LD (HL),A
        DEC HL
; Read and compare RAM $2009 against three.
BOUND_GAME_COUNTER_2009:
        LD A,($2009)
        CP $03
        JP NC,CLAMP_OBJECT_INDEX_TO_SIX
        INC A

CLAMP_OBJECT_INDEX_TO_SIX:
        CP $07
        JP C,ADJUST_OBJECT_INDEX_BY_COUNTER
        LD A,$06

ADJUST_OBJECT_INDEX_BY_COUNTER:
        DEC C
        JP P,COMPLETE_OBJECT_INDEX_ADJUSTMENT
        ADD A,$03

COMPLETE_OBJECT_INDEX_ADJUSTMENT:
        INC C
        RET
; Write flag $01 and update related object-field values.
SET_OBJECT_FLAG_ACTIVE:
        CALL STORE_OBJECT_FIELD_AND_LOOKUP
        LD (HL),$01
        DEC HL
        CALL BOUND_GAME_COUNTER_2009
        JP STORE_OBJECT_LOOKUP_RESULT
; Use object shape lookup to update corresponding field.
SET_OBJECT_FROM_SHAPE_TABLE:
        CALL STORE_OBJECT_FIELD_AND_LOOKUP
        CALL FETCH_GUN_SHAPE_TABLE_BYTE
        CPL
        INC A

STORE_OBJECT_LOOKUP_RESULT:
        LD (HL),A
        DEC HL
        LD (HL),C
        DEC HL
        DEC C
        RET P

CHECK_OBJECT_UPDATE_LOCK:
        LD DE,$20B8
        LD A,(DE)
        AND A
        RET NZ
        LD A,$04
        LD (DE),A
        LD ($203A),A
        RET

; Frame animation data at $14BB: a 16-entry frame-index lookup, followed by
; eight 16-bit graphic-resource addresses at $14CB and parameter groups.
FRAME_PATTERN_TABLE:
        DB $00,$00,$00,$01,$01,$01,$02,$02,$03,$03,$04,$05
        DB $06,$06,$07,$07 ; sixteen frame-state indices

FRAME_GRAPHIC_RESOURCE_POINTERS:
        DW GRAPHIC_RESOURCE_0BFE ; frame graphic 0
        DW GRAPHIC_RESOURCE_0723 ; frame graphic 1
        DW GRAPHIC_RESOURCE_0AC3 ; frame graphic 2
        DW GRAPHIC_RESOURCE_0795 ; frame graphic 3
        DW GRAPHIC_RESOURCE_0D52 ; frame graphic 4
        DW GRAPHIC_RESOURCE_0E2C ; frame graphic 5
        DW GRAPHIC_RESOURCE_08D1 ; frame graphic 6
        DW GRAPHIC_RESOURCE_09F5 ; frame graphic 7

FRAME_CONTROL_PARAMETERS:
        DB $01,$01,$01,$01,$01,$04,$02,$03 ; eight frame-control bytes

FRAME_OBJECT_KEY_PAIRS:
        DB $66,$A4 ; object key 0
        DB $66,$A7 ; object key 1
        DB $66,$96 ; object key 2
        DB $66,$A0 ; object key 3
        DB $66,$A8 ; object key 4
        DB $66,$97 ; object key 5
        DB $66,$A0 ; object key 6
        DB $66,$9E ; object key 7

FRAME_DRAW_OFFSET_PAIRS:
        DB $0C,$4A ; draw offset 0
        DB $0C,$4D ; draw offset 1
        DB $0C,$3C ; draw offset 2
        DB $0C,$46 ; draw offset 3
        DB $0C,$4E ; draw offset 4
        DB $0C,$3D ; draw offset 5
        DB $0C,$46 ; draw offset 6
        DB $0C,$44 ; draw offset 7

FRAME_REBUILD_OBJECTS:
        LD A,$03

SCAN_ACTIVE_GAME_OBJECTS:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND A
        JP P,ADVANCE_OBJECT_SCAN
        PUSH HL
        LD D,A
        INC HL
        LD E,(HL)
        LD BC,$0007
        ADD HL,BC
        LD C,E
        PUSH HL
        LD HL,OBJECT_MOTION_THRESHOLDS_PRIMARY
        AND $02
        JP Z,COMPARE_OBJECT_FIELD_PAIR
        LD HL,OBJECT_MOTION_THRESHOLDS_ALTERNATE

COMPARE_OBJECT_FIELD_PAIR:
        ADD HL,BC
        LD A,(HL)
        POP HL
        CP (HL)
        JP NC,SELECT_OBJECT_MOTION_POINTER_TABLE
        LD (HL),$00
        EX (SP),HL
        LD A,(HL)
        AND $02
        JP Z,RESTORE_OBJECT_POINTER_FROM_STACK
        LD A,(HL)
        AND $F7
        LD (HL),A

RESTORE_OBJECT_POINTER_FROM_STACK:
        EX (SP),HL

SELECT_OBJECT_MOTION_POINTER_TABLE:
        EX DE,HL
        LD A,H
        LD HL,OBJECT_MOTION_SCRIPT_POINTERS
        AND $02
        JP Z,FETCH_OBJECT_MOTION_DATA_POINTER
        LD HL,OBJECT_MOTION_ALT_POINTERS

FETCH_OBJECT_MOTION_DATA_POINTER:
        ADD HL,BC
        ADD HL,BC
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        LD A,(DE)

SCAN_OBJECT_PRIORITY_FIELDS:
        INC HL
        INC HL
        CP (HL)
        INC HL
        JP NC,SCAN_OBJECT_PRIORITY_FIELDS
        LD C,(HL)
        INC HL
        LD B,(HL)
        EX DE,HL
        INC HL
        DI
        LD (HL),C
        INC HL
        LD (HL),B
        EI
        POP HL

ADVANCE_OBJECT_SCAN:
        POP AF
        DEC A
        JP P,SCAN_ACTIVE_GAME_OBJECTS
        RET

; Fourteen object-state selectors address motion records in ROM $1580–$1632.
; Entries are DATA pointers, not native Intel 8080 routine addresses.
; Primary object-state animation pointer table: eight 16-bit entries at $1564.
OBJECT_MOTION_SCRIPT_POINTERS:
        DW MOTION_SEQUENCE_15CE ; state $00
        DW MOTION_SEQUENCE_161F ; state $01
        DW MOTION_SEQUENCE_15B9 ; state $02
        DW MOTION_SEQUENCE_160D ; state $03
        DW MOTION_SEQUENCE_1592 ; state $04
        DW MOTION_SEQUENCE_15A4 ; state $05
        DW MOTION_SEQUENCE_15E0 ; state $06
        DW MOTION_SEQUENCE_15F5 ; state $07

; Alternate object-state table selected by game object flag bit $02 ($1574).
OBJECT_MOTION_ALT_POINTERS:
        DW MOTION_SEQUENCE_15DA ; state $08
        DW MOTION_SEQUENCE_162B ; state $09
        DW MOTION_SEQUENCE_15C5 ; state $0A
        DW MOTION_SEQUENCE_1619 ; state $0B
        DW MOTION_SEQUENCE_159E ; state $0C
        DW MOTION_SEQUENCE_15B3 ; state $0D

; Motion-sequence directory targets are ROM data records, not 8080 handlers.
; Each sequence begins with a 16-bit resource address. Following event records
; contain a byte selector and a little-endian 16-bit graphic pointer.
; $FF ends a sequence; native object code processes the byte stream.
OBJECT_MOTION_DATA:
        DW MOTION_SEQUENCE_15EF,MOTION_SEQUENCE_15FE ; initial animation references

; Eight object motion comparison thresholds (index from BC).
OBJECT_MOTION_THRESHOLDS_PRIMARY:
        DB $04,$08,$08,$0C,$14,$17,$3A,$25

; Six alternate comparison thresholds, selected by object bit $02.
OBJECT_MOTION_THRESHOLDS_ALTERNATE:
        DB $14,$14,$0F,$14,$19,$19

; ROM $1592: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_1592:
        DW $1E14 ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_0D52 ; graphic address
        DB $0A ; selector
        DW GRAPHIC_RESOURCE_0D8C ; graphic address
        DB $0F ; selector
        DW GRAPHIC_RESOURCE_0DC6 ; graphic address
        DB $FF ; sequence terminator

; ROM $159E: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_159E:
        DW GRAPHIC_RESOURCE_0D8C ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $FF ; sequence terminator

; ROM $15A4: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15A4:
        DW GRAPHIC_RESOURCE_0D29 ; initial resource address
        DB $06 ; selector
        DW GRAPHIC_RESOURCE_0E2C ; graphic address
        DB $0A ; selector
        DW GRAPHIC_RESOURCE_0E9D ; graphic address
        DB $0F ; selector
        DW GRAPHIC_RESOURCE_0F02 ; graphic address
        DB $13 ; selector
        DW GRAPHIC_RESOURCE_0E9D ; graphic address
        DB $FF ; sequence terminator

; ROM $15B3: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15B3:
        DW GRAPHIC_RESOURCE_0E2C ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $FF ; sequence terminator

; ROM $15B9: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15B9:
        DW GRAPHIC_RESOURCE_0E00 ; initial resource address
        DB $02 ; selector
        DW GRAPHIC_RESOURCE_0AC3 ; graphic address
        DB $04 ; selector
        DW GRAPHIC_RESOURCE_0AFB ; graphic address
        DB $06 ; selector
        DW GRAPHIC_RESOURCE_0B33 ; graphic address
        DB $FF ; sequence terminator

; ROM $15C5: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15C5:
        DW GRAPHIC_RESOURCE_0B6B ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $0F ; selector
        DW GRAPHIC_RESOURCE_0BA3 ; graphic address
        DB $FF ; sequence terminator

; ROM $15CE: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15CE:
        DW GRAPHIC_RESOURCE_0BC3 ; initial resource address
        DB $01 ; selector
        DW GRAPHIC_RESOURCE_0BFE ; graphic address
        DB $02 ; selector
        DW GRAPHIC_RESOURCE_0C24 ; graphic address
        DB $03 ; selector
        DW GRAPHIC_RESOURCE_0C4A ; graphic address
        DB $FF ; sequence terminator

; ROM $15DA: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15DA:
        DW GRAPHIC_RESOURCE_0C70 ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $FF ; sequence terminator

; ROM $15E0: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15E0:
        DW GRAPHIC_RESOURCE_0BE6 ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_0965 ; graphic address
        DB $19 ; selector
        DW GRAPHIC_RESOURCE_099D ; graphic address
        DB $1E ; selector
        DW GRAPHIC_RESOURCE_08D1 ; graphic address
        DB $37 ; selector
        DW GRAPHIC_RESOURCE_0915 ; graphic address
        DB $FF ; sequence terminator

; ROM $15EF: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15EF:
        DW GRAPHIC_RESOURCE_0965 ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $FF ; sequence terminator

; ROM $15F5: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15F5:
        DW GRAPHIC_RESOURCE_09DE ; initial resource address
        DB $0E ; selector
        DW GRAPHIC_RESOURCE_0A27 ; graphic address
        DB $19 ; selector
        DW GRAPHIC_RESOURCE_09F5 ; graphic address
        DB $FF ; sequence terminator

; ROM $15FE: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_15FE:
        DW GRAPHIC_RESOURCE_0A27 ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $0F ; selector
        DW GRAPHIC_RESOURCE_09F5 ; graphic address
        DB $14 ; selector
        DW GRAPHIC_RESOURCE_0A65 ; graphic address
        DB $19 ; selector
        DW GRAPHIC_RESOURCE_0A91 ; graphic address
        DB $FF ; sequence terminator

; ROM $160D: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_160D:
        DW GRAPHIC_RESOURCE_0AAF ; initial resource address
        DB $03 ; selector
        DW GRAPHIC_RESOURCE_0795 ; graphic address
        DB $06 ; selector
        DW GRAPHIC_RESOURCE_07EF ; graphic address
        DB $09 ; selector
        DW GRAPHIC_RESOURCE_0849 ; graphic address
        DB $FF ; sequence terminator

; ROM $1619: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_1619:
        DW GRAPHIC_RESOURCE_07EF ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $FF ; sequence terminator

; ROM $161F: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_161F:
        DW GRAPHIC_RESOURCE_08A3 ; initial resource address
        DB $02 ; selector
        DW GRAPHIC_RESOURCE_0749 ; graphic address
        DB $04 ; selector
        DW GRAPHIC_RESOURCE_076F ; graphic address
        DB $06 ; selector
        DW GRAPHIC_RESOURCE_0749 ; graphic address
        DB $FF ; sequence terminator

; ROM $162B: resource address + animation event/bitmap pairs.
MOTION_SEQUENCE_162B:
        DW GRAPHIC_RESOURCE_0723 ; initial resource address
        DB $05 ; selector
        DW GRAPHIC_RESOURCE_06E4 ; graphic address
        DB $FF ; sequence terminator
; Additional original graphic reference following the final $FF.
MOTION_TRAILING_GRAPHIC_POINTER:
        DW GRAPHIC_RESOURCE_0712

CMD_1633_CLEAR_DISPLAY:
        DB $06 ; CLEAR_DISPLAY
CMD_1634_INIT_RENDER:
        DB $08 ; INIT_RENDER
        DW $2006 ; inline W
        DW $3EA0 ; inline W
CMD_1639_RENDER_MODE_A:
        DB $01 ; RENDER_MODE_A
        DB $05 ; inline B
CMD_163B_INIT_RENDER:
        DB $08 ; INIT_RENDER
        DW $200B ; inline W
        DW $2400 ; inline W
CMD_1640_RENDER_MODE_A:
        DB $01 ; RENDER_MODE_A
        DB $06 ; inline B
CMD_1642_RENDER_MODE_A:
        DB $01 ; RENDER_MODE_A
        DB $04 ; inline B
CMD_1644_INIT_RENDER:
        DB $08 ; INIT_RENDER
        DW $201C ; inline W
        DW $241B ; inline W
CMD_1649_INIT_DESCRIPTOR:
        DB $07 ; INIT_DESCRIPTOR
CMD_164A_STORE_IMMEDIATE:
        DB $05 ; STORE_IMMEDIATE
        DB $01 ; inline B
        DW $2081 ; inline W
CMD_164E_STORE_IMMEDIATE:
        DB $05 ; STORE_IMMEDIATE
        DB $01 ; inline B
        DW $20B1 ; inline W
CMD_1652_SET_RENDER_POINTER:
        DB $03 ; SET_RENDER_POINTER
        DB $10 ; inline B
        DW $1633 ; inline W
CMD_1656_STORE_IMMEDIATE:
        DB $05 ; STORE_IMMEDIATE
        DB $01 ; inline B
        DW $2035 ; inline W
CMD_165A_STORE_IMMEDIATE:
        DB $05 ; STORE_IMMEDIATE
        DB $01 ; inline B
        DW $2038 ; inline W
CMD_165E_RENDER_PACKET:
        DB $0C ; RENDER_PACKET
        DB $0B ; inline B
        DW $1A5E ; inline W
        DW $2F8A ; inline W
CMD_1664_RESET_ROUND:
        DB $0B ; RESET_ROUND
CMD_1665_RENDER_MODE_A:
        DB $01 ; RENDER_MODE_A
        DB $02 ; inline B
CMD_1667_SET_MODE:
        DB $02 ; SET_MODE
        DB $3C ; inline B
CMD_1669_FRAME_SCHEDULER:
        DB $00 ; FRAME_SCHEDULER
        DB $0C,$0C,$4B,$1A,$B4,$3E,$02,$1E,$00,$04,$64,$16

CMD_1676_SET_MODE:
        DB $02 ; SET_MODE
        DB $1E ; inline B
CMD_1678_FRAME_SCHEDULER:
        DB $00 ; FRAME_SCHEDULER
; Decoded $1679 round-control script. Each command includes its inline operands.
; Word and operand widths are traced from the native interpreter handlers.
CMD_1679_CLEAR_DISPLAY:
        DB $06 ; clear display

CMD_167A_DRAW_MODE_A:
        DB $01 ; draw mode a
        DB $08 ; immediate parameter

CMD_167C_SET_RENDER_MODE:
        DB $02 ; set render mode
        DB $78 ; immediate parameter

CMD_167E_FRAME_HANDOFF:
        DB $00 ; frame handoff

CMD_167F_DRAW_MODE_A:
        DB $01 ; draw mode a
        DB $09 ; immediate parameter

CMD_1681_SET_RENDER_MODE:
        DB $02 ; set render mode
        DB $3C ; immediate parameter

CMD_1683_FRAME_HANDOFF:
        DB $00 ; frame handoff

CMD_1684_DRAW_PACKET:
        DB $0C ; draw packet
        DB $0D ; draw length
        DW $1A4B ; source
        DW $3009 ; video destination

CMD_168A_STORE_IMMEDIATE:
        DB $05 ; store immediate
        DB $06 ; value
        DW $20B9 ; destination

CMD_168E_STORE_IMMEDIATE:
        DB $05 ; store immediate
        DB $01 ; value
        DW $200D ; destination

CMD_1692_STORE_IMMEDIATE:
        DB $05 ; store immediate
        DB $01 ; value
        DW $2081 ; destination

CMD_1696_STORE_IMMEDIATE:
        DB $05 ; store immediate
        DB $01 ; value
        DW $2035 ; destination

CMD_169A_FRAME_HANDOFF:
        DB $00 ; frame handoff

CMD_169B_STORE_IMMEDIATE:
        DB $05 ; store immediate
        DB $00 ; value
        DW $200D ; destination

CMD_169F_STORE_IMMEDIATE:
        DB $05 ; store immediate
        DB $00 ; value
        DW $2037 ; destination

CMD_16A3_STORE_IMMEDIATE:
        DB $05 ; store immediate
        DB $00 ; value
        DW $2038 ; destination

CMD_16A7_DRAW_PACKET:
        DB $0C ; draw packet
        DB $10 ; draw length
        DW $1A4B ; source
        DW $2400 ; video destination

CMD_16AD_DRAW_PACKET:
        DB $0C ; draw packet
        DB $10 ; draw length
        DW $1A4B ; source
        DW $2410 ; video destination

CMD_16B3_DRAW_PACKET:
        DB $0C ; draw packet
        DB $10 ; draw length
        DW $1A4B ; source
        DW $3EA0 ; video destination

CMD_16B9_DRAW_PACKET:
        DB $0C ; draw packet
        DB $10 ; draw length
        DW $1A4B ; source
        DW $3EB0 ; video destination

CMD_16BF_INIT_DRAW_BRANCH:
        DB $08 ; init draw branch
        DW $2006 ; descriptor source
        DW $3EA0 ; render destination

CMD_16C4_DRAW_MODE_A:
        DB $01 ; draw mode a
        DB $05 ; immediate parameter

CMD_16C6_INIT_DRAW_BRANCH:
        DB $08 ; init draw branch
        DW $200B ; descriptor source
        DW $2400 ; render destination

CMD_16CB_DRAW_MODE_A:
        DB $01 ; draw mode a
        DB $06 ; immediate parameter

CMD_16CD_DRAW_MODE_A:
        DB $01 ; draw mode a
        DB $04 ; immediate parameter

CMD_16CF_INIT_DRAW_BRANCH:
        DB $08 ; init draw branch
        DW $201C ; descriptor source
        DW $241B ; render destination

CMD_16D4_SET_RENDER_MODE:
        DB $02 ; set render mode
        DB $1E ; immediate parameter

CMD_16D6_FRAME_HANDOFF:
        DB $00 ; frame handoff

CMD_16D7_CLEAR_FLAG_BIT3:
        DB $0A ; clear flag bit3
        DW $2040 ; RAM flag address

CMD_16DA_CLEAR_FLAG_BIT3:
        DB $0A ; clear flag bit3
        DW $204F ; RAM flag address

CMD_16DD_CLEAR_FLAG_BIT3:
        DB $0A ; clear flag bit3
        DW $205E ; RAM flag address

CMD_16E0_CLEAR_FLAG_BIT3:
        DB $0A ; clear flag bit3
        DW $206D ; RAM flag address

CMD_16E3_SET_RENDER_MODE:
        DB $02 ; set render mode
        DB $0F ; immediate parameter

CMD_16E5_FRAME_HANDOFF:
        DB $00 ; frame handoff

CMD_16E6_DRAW_MODE_B:
        DB $09 ; draw mode b
        DB $00 ; immediate parameter

CMD_16E8_DRAW_MODE_B:
        DB $09 ; draw mode b
        DB $01 ; immediate parameter

CMD_16EA_SET_RENDER_MODE:
        DB $02 ; set render mode
        DB $F0 ; immediate parameter

CMD_16EC_FRAME_HANDOFF:
        DB $00 ; frame handoff

CMD_16ED_GOTO_SCRIPT:
        DB $04 ; goto script
        DW $1633 ; script destination

CHECK_START_INPUT_EDGE:
        LD HL,$20B2
        IN A,($02)
        CPL
        AND $80
        LD B,A
        XOR (HL)
        RET Z
        LD (HL),B
        LD A,B
        AND A
        RET Z
        LD A,($20B5)
        AND A
        RET NZ
        LD HL,$20B9
        LD A,(HL)
        AND A
        JP Z,SET_TIMER_AND_GAME_FLAGS
        DEC (HL)
        JP NZ,SET_GAME_FLAGS_AND_SOUND_PORT
        LD ($20BA),A
        LD A,$04
        LD ($2036),A

SET_GAME_FLAGS_AND_SOUND_PORT:
        LD B,$04
        CALL OR_GAME_FLAGS_2080
        LD A,$18
        OUT ($03),A
        LD A,$02
        LD ($2034),A
        LD HL,$1A4B
        LD DE,$2F86
        LD A,$13
        CALL DRAW_ENCODED_GRAPHIC
        LD A,($2015)
        CP $0F
        JP C,RESET_GAME_STATE_AND_INCREMENT_COUNTER
        CP $59
        JP C,TEST_GAME_PLAYER_COUNT
        CP $69
        JP C,RESET_GAME_STATE_AND_INCREMENT_COUNTER
        CP $D1
        JP NC,RESET_GAME_STATE_AND_INCREMENT_COUNTER

TEST_GAME_PLAYER_COUNT:
        SUB $03
        LD D,A
        LD A,($2014)
        CP $03
        JP C,RESET_GAME_STATE_AND_INCREMENT_COUNTER
        CP $FC
        JP NC,RESET_GAME_STATE_AND_INCREMENT_COUNTER
        SUB $03
        LD E,A
        PUSH DE
        PUSH AF
        CALL SHIFT_VIDEO_ADDRESS_THREE
        EX DE,HL
        LD A,$07
        LD DE,$0000
        LD BC,$001F

ACCUMULATE_OBJECT_FIELD_HIGH_BITS:
        PUSH AF
        LD A,(HL)
        OR D
        LD D,A
        LD A,L
        INC HL
        AND $1F
        LD A,B
        JP Z,ACCUMULATE_OBJECT_FIELD_LOW_BITS
        LD A,(HL)

ACCUMULATE_OBJECT_FIELD_LOW_BITS:
        OR E
        LD E,A
        ADD HL,BC
        POP AF
        DEC A
        JP NZ,ACCUMULATE_OBJECT_FIELD_HIGH_BITS
        PUSH DE
        CALL CLAMP_GAME_STATE_TO_THREE
        POP HL
        POP AF
        AND $07
        INC A

SHIFT_OBJECT_POSITION_TO_SCALE:
        ADD HL,HL
        DEC A
        JP NZ,SHIFT_OBJECT_POSITION_TO_SCALE
        LD A,H
        AND $7F
        POP DE
        LD HL,$20B3
        JP Z,ADVANCE_SCENE_COUNTER_AND_DRAW
        LD (HL),$00
        LD A,D
        CP $59
        JP C,CHECK_FIRST_OBJECT_ACTIVE_FLAGS
        CP $B3
        JP C,CHECK_REMAINING_OBJECT_ACTIVE_FLAGS
        LD BC,$FFFF
        LD A,B

ADVANCE_OBJECT_BOUNDARY_COUNTER:
        ADD A,$40
        CP E
        INC BC
        JP C,ADVANCE_OBJECT_BOUNDARY_COUNTER
        LD HL,$20AD
        ADD HL,BC
        LD A,(HL)
        AND A
        RET NZ
        LD ($20B7),A
        LD A,$10
        LD (HL),A
        CALL INCREMENT_PACKED_BCD_SCORE
        LD A,$04
        LD ($2033),A
        LD HL,$1922
        ADD HL,BC
        ADD HL,BC
        ADD HL,BC
        LD E,(HL)
        INC HL
        LD D,(HL)
        EX DE,HL
        LD DE,GRAPHIC_RESOURCE_0D03
        LD BC,$1002
        JP COPY_SCREEN_ROW_LOOP

RESET_GAME_STATE_AND_INCREMENT_COUNTER:
        CALL CLAMP_GAME_STATE_TO_THREE
        LD HL,$20B3

ADVANCE_SCENE_COUNTER_AND_DRAW:
        LD A,(HL)
        INC (HL)
        LD HL,$1AA0
        LD DE,$2F86
        AND A
        LD A,$07
        JP Z,DRAW_NEXT_GAME_SCENE
        LD A,$0D

DRAW_NEXT_GAME_SCENE:
        CALL DRAW_ENCODED_GRAPHIC
        CALL SERVICE_GAME_STATE_201E
        RRA
        LD HL,$1AAD
        LD A,$05
        JP C,ENTER_GRAPHIC_RENDERER_ACROSS_ROM_BANK
        LD HL,$1AB2
        INC A

ENTER_GRAPHIC_RENDERER_ACROSS_ROM_BANK:
        JP DRAW_ENCODED_GRAPHIC
; JP instruction above spans 9316.1f $17FF and desertgu.e $1800-$1801.

        ORG $1802
; ROM device desertgu.e, SHA1 202433dfb174901bd3b91e843d9d697a8333ef9e
CHECK_FIRST_OBJECT_ACTIVE_FLAGS:
        LD HL,$2040
        CALL TEST_OBJECT_FLAG_BIT1
        JP C,INITIALIZE_SELECTED_OBJECT_STATE
        LD HL,$204F
        CALL TEST_OBJECT_FLAG_BIT1
        JP C,INITIALIZE_SELECTED_OBJECT_STATE
        RET

CHECK_REMAINING_OBJECT_ACTIVE_FLAGS:
        LD HL,$205E
        CALL TEST_OBJECT_FLAG_BIT1
        JP C,INITIALIZE_SELECTED_OBJECT_STATE
        LD HL,$206D
        CALL TEST_OBJECT_FLAG_BIT1
        RET NC

INITIALIZE_SELECTED_OBJECT_STATE:
        PUSH HL
        PUSH DE
        CALL UPDATE_OBJECT_FIELDS_2085
        LD A,$03
        LD (HL),A
        LD (DE),A
        POP DE
        INC HL
        EX (SP),HL
        DEC HL
        DEC HL
        LD C,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD A,(HL)
        SUB E
        LD E,A
        INC HL
        INC HL
        INC HL
        LD D,(HL)
        INC HL
        LD A,(HL)
        SUB D
        SUB $68
        JP NC,CLAMP_OBJECT_DISPLAY_VALUE
        ADD A,$5C

CLAMP_OBJECT_DISPLAY_VALUE:
        CP $20
        LD A,(HL)
        JP C,STORE_OBJECT_DISPLAY_VALUE
        SUB $10
        LD D,A
        JP STORE_VIDEO_ADDRESS_AND_DRAW_FIELDS

STORE_OBJECT_DISPLAY_VALUE:
        LD D,A
        ADD A,$10
        LD (HL),A

STORE_VIDEO_ADDRESS_AND_DRAW_FIELDS:
        EX (SP),HL
        CALL SHIFT_VIDEO_ADDRESS_THREE
        LD (HL),C
        INC HL
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        PUSH HL
        LD HL,$192E
        ADD HL,BC
        EX DE,HL
        LD A,(DE)
        CALL INCREMENT_PACKED_BCD_SCORE
        POP BC
        CALL DECODE_DESCRIPTOR_NIBBLE
        LD A,$30
        LD (BC),A
        INC BC
        LD A,$40
        LD (BC),A
        POP HL
        INC HL
        LD (HL),$00
        DEC HL
        DEC HL
        LD (HL),$01
        DEC HL
        DEC HL
        DEC HL
        DEC HL
        LD (HL),$00
        DEC HL
        DEC HL
        LD A,(HL)
        OR $02
        LD (HL),A
        RET
; Inspect pointed object's sign and bit $02.
TEST_OBJECT_FLAG_BIT1:
        LD A,(HL)
        AND A
        RET P
        AND $02
        RET NZ
        INC HL
        INC HL
        INC HL
        LD A,(HL)
        SUB $08
        CP E
        RET NC
        ADD A,$28
        CP E
        CCF
        RET

SET_TIMER_AND_GAME_FLAGS:
        LD A,$03
        LD ($2034),A
        LD B,$02
        JP OR_GAME_FLAGS_2080
; Increment RAM score at $200A with DAA decimal adjust.
INCREMENT_PACKED_BCD_SCORE:
        LD HL,$200A
        ADD A,(HL)
        DAA
        LD (HL),A
        DEC HL
        LD A,$00
        ADC A,(HL)
        DAA
        LD (HL),A
        RET
; Limit RAM $2014 to a maximum of three before continuing.
CLAMP_GAME_STATE_TO_THREE:
        LD A,($2014)
        CP $03
        JP NC,CLAMP_SCORE_DISPLAY_POSITION
        LD A,$03

CLAMP_SCORE_DISPLAY_POSITION:
        CP $FC
        JP C,CALCULATE_SCORE_DISPLAY_ROW
        LD A,$FC

CALCULATE_SCORE_DISPLAY_ROW:
        SUB $03
        LD L,A
        AND $07
        INC A
        LD C,A
        LD A,($2015)
        SUB $03
        JP NC,STORE_SCORE_DISPLAY_ADDRESS
        LD A,$03

STORE_SCORE_DISPLAY_ADDRESS:
        LD H,A
        LD ($20B4),HL
        EX DE,HL
        CALL SHIFT_VIDEO_ADDRESS_THREE
        LD A,$0A
        LD ($2039),A
        LD B,$80

SELECT_SCORE_DISPLAY_COORDINATES:
        LD HL,$191C
        LD A,$06

PREPARE_SCORE_DISPLAY_BIT_SHIFT:
        PUSH AF
        PUSH HL
        LD L,(HL)
        LD H,$00
        LD A,C

SHIFT_SCORE_DISPLAY_BITS:
        ADD HL,HL
        DEC A
        JP NZ,SHIFT_SCORE_DISPLAY_BITS
        EX DE,HL
        DEC B
        JP M,CLEAR_SCORE_DISPLAY_PIXEL_MASK
        LD A,E
        OR (HL)
        LD (HL),A
        INC HL
        LD A,D
        OR (HL)
        LD (HL),A
        JP ADVANCE_SCORE_DISPLAY_SCANLINE

CLEAR_SCORE_DISPLAY_PIXEL_MASK:
        LD A,E
        CPL
        AND (HL)
        LD (HL),A
        INC HL
        LD A,D
        CPL
        AND (HL)
        LD (HL),A

ADVANCE_SCORE_DISPLAY_SCANLINE:
        LD DE,$001F
        ADD HL,DE
        EX DE,HL
        POP HL
        INC HL
        POP AF
        DEC A
        JP NZ,PREPARE_SCORE_DISPLAY_BIT_SHIFT
        RET

DRAWING_COORDINATE_RECORDS:
        DB $44,$20,$1A,$18,$20,$44,$24,$3B,$1B,$8C,$3C,$10
        DB $54,$3B,$1A,$9C,$3C,$10,$50,$30,$20,$20,$20,$20
        DB $20,$20

FRAME_SERVICE_1936:
        LD A,($2081)
        AND A
        RET Z
        LD DE,$20B1
        LD A,(DE)
        AND A
        RET NZ
        CPL
        LD (DE),A
        LD HL,$1A4B
        LD DE,$3EA7
        LD A,$13
        CALL DRAW_ENCODED_GRAPHIC
        LD HL,$1965

READ_SCENE_POINTER_ENTRY:
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD A,D
        OR E
        RET Z
        PUSH DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        EX (SP),HL
        CALL COPY_SCREEN_ROW_DESCRIPTOR
        POP HL
        JP READ_SCENE_POINTER_ENTRY

SPRITE_COPY_POINTER_PAIRS:
        DW GRAPHIC_RESOURCE_0C96
        DW $3B24
        DW GRAPHIC_RESOURCE_0CB3
        DW $3C8C
        DW GRAPHIC_RESOURCE_0CD5
        DW $3B54
        DW GRAPHIC_RESOURCE_0CF1
        DW $3C9C
        DW $0000

INCREMENT_GAME_SEQUENCE_COUNTER:
        LD HL,$20B6
        LD A,(HL)
        AND A
        JP NZ,COMPARE_PRIMARY_GAME_SCORE_RECORD
        INC (HL)
        IN A,($02)
        RRCA
        RRCA
        RRCA
        RRCA
        AND $03
        LD C,A
        LD B,$00
        LD HL,$19FF
        ADD HL,BC
        LD A,($2009)
        CP (HL)
        JP C,COMPARE_PRIMARY_GAME_SCORE_RECORD
        LD HL,$1A02
        ADD HL,BC
        LD A,(HL)
        LD ($2008),A
        LD ($201F),A
        LD HL,$10D8
        LD ($2012),HL
        LD C,$07
        CALL RENDER_WORD_PACKET
        JP DRAW_ENCODED_GRAPHIC

COMPARE_PRIMARY_GAME_SCORE_RECORD:
        LD BC,$2009
        LD HL,$201C
        LD DE,$10F2
        CALL COMPARE_TWO_BYTE_RECORD
        JP C,COMPARE_SECONDARY_GAME_SCORE_RECORD
        LD HL,$2006
        LD DE,$110C
        CALL COMPARE_TWO_BYTE_RECORD
        JP C,COMPARE_SECONDARY_GAME_SCORE_RECORD
        LD DE,$1128

COMPARE_SECONDARY_GAME_SCORE_RECORD:
        EX DE,HL
        LD ($2012),HL
        LD HL,$2006
        CALL COMPARE_TWO_BYTE_RECORD
        JP C,INITIALIZE_GAME_SCORE_TRACKING
        LD HL,($2009)
        LD ($2006),HL

INITIALIZE_GAME_SCORE_TRACKING:
        LD A,$01
        LD ($2031),A
        LD ($201F),A
        LD HL,($2009)
        LD ($201C),HL
        EX DE,HL
        LD HL,$0000
        LD ($2009),HL
        RET
; Compare two-byte record at BC against HL.
COMPARE_TWO_BYTE_RECORD:
        LD A,(BC)
        CP (HL)
        RET NZ
        INC HL
        INC BC
        LD A,(BC)
        CP (HL)
        DEC BC
        RET

DIFFICULTY_THRESHOLD_BYTES:
        DB $05,$07,$09,$30,$30,$30,$35

RENDER_WORD_PACKET:
        LD HL,$1A37
        LD B,$00
        ADD HL,BC
        ADD HL,BC
        LD E,(HL)
        INC HL
        LD D,(HL)
        IN A,($02)
        RRCA
        RRCA
        AND $03
        PUSH BC
        LD HL,$1A2F
        LD C,A
        ADD HL,BC
        ADD HL,BC
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        POP BC
; Read text stream until high-bit-terminated character; select indexed string.
READ_HIGH_BIT_TERMINATED_TEXT:
        LD A,(HL)
        INC HL
        AND A
        JP P,READ_HIGH_BIT_TERMINATED_TEXT
        DEC C
        JP P,READ_HIGH_BIT_TERMINATED_TEXT
        AND $7F
        RET

SCREEN_MESSAGE_DIRECTORY:
        DW ENGLISH_MESSAGES_ANCHOR
        DW GERMAN_MESSAGES_ANCHOR
        DW FRENCH_MESSAGES_ANCHOR
        DW DANISH_MESSAGES_ANCHOR

MESSAGE_SCREEN_COORDINATE_POINTERS:
        DW $2808
        DW $3408
        DW $3EB4
        DW $2404
        DB $15,$24,$A6,$3E,$06,$24,$A7,$3E,$0B,$30,$0B,$30
        DB $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        DB $40,$40,$40,$40,$40,$40,$40
; The game title starts here; its first two characters precede $1A60.
TEXT_GAME_TITLE_DESERT_GUN:
        DB $44,$45

SCREEN_MESSAGE_TEXT:
; ROM $1A60 text pool: game title, bonus phrases and localized menu text.
; Language directory points at a high-bit delimiter byte preceding each list.
        DB $53,$45,$52,$54,$40,$47,$55,$4E,$00,$40,$40,$40 ; SERT GUN     200 BONUS     100 UGHJBUFJARGJPOWJZOWJBOPJWAMJBAMJMISSED AG
        DB $40,$40,$32,$30,$30,$40,$42,$4F,$4E,$55,$53,$40
        DB $40,$40,$40,$40,$31,$30,$30,$40,$55,$47,$48,$4A
        DB $42,$55,$46,$4A,$41,$52,$47,$4A,$50,$4F,$57,$4A
        DB $5A,$4F,$57,$4A,$42,$4F,$50,$4A,$57,$41,$4D,$4A
        DB $42,$41,$4D,$4A,$4D,$49,$53,$53,$45,$44,$40,$41
        DB $47,$41,$49,$4E,$40,$44,$55,$4D,$4D,$59,$54,$55
        DB $52,$4B,$45,$59,$52,$45,$4C,$4F,$41,$44,$43,$59
        DB $43,$4C,$45

; Language-list delimiter $1AC3
ENGLISH_MESSAGES_ANCHOR:
        DB $84
        DB $47,$41,$4D,$45,$84 ; GAME
        DB $4F,$56,$45,$52,$8B ; OVER
        DB $49,$4E,$53,$45,$52,$54,$40,$43,$4F,$49,$4E,$84 ; INSERT COIN
        DB $54,$49,$4D,$45,$85 ; TIME
        DB $53,$43,$4F,$52,$45,$8A ; SCORE
        DB $48,$49,$47,$48,$40,$53,$43,$4F,$52,$45,$89 ; HIGH SCORE
        DB $4C,$41,$53,$54,$40,$47,$41,$4D,$45,$8D ; LAST GAME
        DB $45,$58,$54,$45,$4E,$44,$45,$44,$40,$54,$49,$4D ; EXTENDED TIME
        DB $45,$89
        DB $47,$45,$54,$40,$52,$45,$41,$44,$59,$89 ; GET READY
        DB $40,$40,$53,$48,$4F,$4F,$54,$40,$40 ; SHOOT

; Language-list delimiter $1B1B
GERMAN_MESSAGES_ANCHOR:
        DB $84
        DB $47,$41,$4D,$45,$84 ; GAME
        DB $4F,$56,$45,$52,$89 ; OVER
        DB $45,$49,$4E,$57,$45,$52,$46,$45,$4E,$84 ; EINWERFEN
        DB $5A,$45,$49,$54,$86 ; ZEIT
        DB $50,$55,$4E,$4B,$54,$45,$86 ; PUNKTE
        DB $52,$45,$4B,$4F,$52,$44,$88 ; REKORD
        DB $45,$4E,$44,$53,$50,$49,$45,$4C,$91 ; ENDSPIEL
        DB $5A,$45,$49,$54,$56,$45,$52,$4C,$41,$45,$4E,$47 ; ZEITVERLAENGERUNG
        DB $45,$52,$55,$4E,$47,$8D
        DB $46,$45,$52,$54,$49,$47,$40,$4D,$41,$43,$48,$45 ; FERTIG MACHEN
        DB $4E,$8D
        DB $40,$40,$53,$43,$48,$49,$45,$53,$53,$45,$4E,$40 ; SCHIESSEN
        DB $40

; Language-list delimiter $1B79
FRENCH_MESSAGES_ANCHOR:
        DB $83
        DB $46,$49,$4E,$81 ; FIN
        DB $40,$8C
        DB $4D,$45,$54,$54,$45,$5A,$40,$50,$49,$45,$43,$45 ; METTEZ PIECE
        DB $85
        DB $54,$45,$4D,$50,$53,$85 ; TEMPS
        DB $53,$43,$4F,$52,$45,$8A ; SCORE
        DB $48,$49,$47,$48,$40,$53,$43,$4F,$52,$45,$8C ; HIGH SCORE
        DB $44,$45,$52,$4E,$49,$45,$52,$40,$43,$4F,$55,$50 ; DERNIER COUP
        DB $8C
        DB $50,$52,$4F,$4C,$4F,$4E,$47,$41,$54,$49,$4F,$4E ; PROLONGATION
        DB $8D
        DB $50,$52,$45,$50,$41,$52,$45,$5A,$40,$56,$4F,$55 ; PREPAREZ VOUS
        DB $53,$8D
        DB $40,$40,$40,$40,$53,$48,$4F,$4F,$54,$40,$40,$40 ; SHOOT
        DB $40

; Language-list delimiter $1BD9
DANISH_MESSAGES_ANCHOR:
        DB $84
        DB $53,$50,$49,$4C,$84 ; SPIL
        DB $53,$4C,$55,$54,$87 ; SLUT
        DB $49,$4E,$44,$4B,$41,$53,$54,$83 ; INDKAST
        DB $54,$49,$44,$85 ; TID
        DB $50,$4F,$49,$4E,$54,$89 ; POINT
        DB $54,$4F,$50,$40,$50,$4F,$49,$4E,$54,$8B ; TOP POINT
        DB $53,$49,$44,$53,$54,$45,$40,$53,$50,$49,$4C,$8A ; SIDSTE SPIL
        DB $45,$4B,$53,$54,$52,$41,$40,$54,$49,$44,$85 ; EKSTRA TID
        DB $50,$41,$52,$41,$54,$85 ; PARAT
        DB $40,$53,$4B,$59,$44 ; SKYD

RESTORE_SCRIPT_POINTER_FROM_RENDER_STATE:
        XOR A
        LD ($2031),A
        LD HL,($2019)
        LD ($2000),HL
        RET

ADVANCE_INTERPRETED_SCRIPT_POINTER:
        LD HL,($2000)
        INC HL
        LD ($2000),HL
        RET

WRITE_SOUND_PORT_AND_TEST_GAME_FLAGS:
        LD A,$08
        OUT ($03),A
        LD DE,$2080
        LD A,(DE)
        AND $09
        LD (DE),A
        OUT ($07),A
        RET

ENABLE_GAME_AND_UPDATE_OBJECT_FLAGS:
        LD A,$01
        LD ($2003),A
        LD HL,$208D
        LD BC,$0008
        LD A,(HL)
        ADD HL,BC
        OR (HL)
        ADD HL,BC
        OR (HL)
        ADD HL,BC
        OR (HL)
        JP Z,ADVANCE_ROUND_STATE_COUNTER
        LD A,$0A
        LD ($2036),A
        RET

ADVANCE_ROUND_STATE_COUNTER:
        LD HL,$20BA
        LD A,(HL)
        INC (HL)
        DEC A
        JP NZ,SET_SCENE_TIMER_AND_DRAW_BACKGROUND
        LD A,$03

CLEAR_GAME_RECORD_CONTROL_BITS:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND $BB
        LD (HL),A
        POP AF
        DEC A
        JP P,CLEAR_GAME_RECORD_CONTROL_BITS
        LD A,$04
        LD ($2036),A
        RET

SET_SCENE_TIMER_AND_DRAW_BACKGROUND:
        DEC A
        JP NZ,CLEAR_SCENE_FIELD_AND_REDRAW
        LD A,$5A
        LD ($2036),A
        LD HL,$1AB8
        LD DE,$2804
        LD A,$06
        CALL DRAW_GRAPHIC_MODE_B
        LD HL,$1ABE
        LD DE,$3406
        LD A,$05
        JP DRAW_GRAPHIC_MODE_B

CLEAR_SCENE_FIELD_AND_REDRAW:
        LD (HL),$00
        LD HL,$1A4B
        LD DE,$2804
        LD A,$06
        CALL DRAW_GRAPHIC_MODE_B
        LD DE,$3406
        LD A,$05
        CALL DRAW_GRAPHIC_MODE_B
        LD A,$03

SET_GAME_RECORD_CONTROL_BITS:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        OR $44
        LD (HL),A
        POP AF
        DEC A
        JP P,SET_GAME_RECORD_CONTROL_BITS
        LD A,$06
        LD ($20B9),A
        XOR A
        LD ($2003),A
        RET

SELECT_OBJECT_TIMER_208D:
        LD HL,$208D
        LD BC,$203C
        JP DECREMENT_SELECTED_OBJECT_TIMER

SELECT_OBJECT_TIMER_2095:
        LD HL,$2095
        LD BC,$203D
        JP DECREMENT_SELECTED_OBJECT_TIMER

SELECT_OBJECT_TIMER_209D:
        LD HL,$209D
        LD BC,$203E
        JP DECREMENT_SELECTED_OBJECT_TIMER

SELECT_OBJECT_TIMER_20A5:
        LD HL,$20A5
        LD BC,$203F

DECREMENT_SELECTED_OBJECT_TIMER:
        LD A,(HL)
        DEC (HL)
        DEC A
        JP NZ,RELOAD_OBJECT_TIMER_ON_ZERO
        INC HL
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD HL,$1A4B
        LD A,$04
        JP DRAW_ENCODED_GRAPHIC

RELOAD_OBJECT_TIMER_ON_ZERO:
        DEC A
        JP NZ,RELOAD_OBJECT_TIMER_DEFAULT
        LD A,$3C
        LD (BC),A
        INC HL
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD A,$04
        JP DRAW_ENCODED_GRAPHIC

RELOAD_OBJECT_TIMER_DEFAULT:
        LD A,$14
        LD (BC),A
        INC HL
        LD A,(HL)
        AND A
        LD A,$88
        JP NZ,WRITE_OUTPUT_PORT_AND_SCENE_STATE
        LD A,$48

WRITE_OUTPUT_PORT_AND_SCENE_STATE:
        OUT ($03),A
        LD A,$0F
        LD ($2034),A
        LD A,(HL)
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD HL,$1A80
        RLCA
        RLCA
        LD C,A
        LD B,$00
        ADD HL,BC
        LD A,$04
        JP DRAW_ENCODED_GRAPHIC

READ_SCORE_RENDER_ADDRESS:
        LD HL,($20B4)
        XOR A
        LD ($20B5),A
        LD A,L
        AND $07
        INC A
        LD C,A
        EX DE,HL
        CALL SHIFT_VIDEO_ADDRESS_THREE
        LD B,$00
        JP SELECT_SCORE_DISPLAY_COORDINATES

DECREMENT_GAME_FLAG_TIMER:
        LD HL,$20B8
        LD DE,$2080
        LD A,(HL)
        DEC (HL)
        DEC A
        JP NZ,TEST_GAME_FLAG_TIMER_RESET
        XOR A

CLEAR_GAME_FLAG_BIT0_AND_RETURN:
        LD ($203A),A
        LD A,(DE)
        AND $FE
        LD (DE),A
        RET

TEST_GAME_FLAG_TIMER_RESET:
        DEC A
        JP NZ,SELECT_GAME_FLAG_TIMER_BRANCH

SET_GAME_FLAG_BIT0_AND_TIMER:
        LD A,$03
        LD ($203A),A
        LD A,(DE)
        OR $01
        LD (DE),A
        RET

SELECT_GAME_FLAG_TIMER_BRANCH:
        DEC A
        JP NZ,SET_GAME_FLAG_BIT0_AND_TIMER
        LD A,$02
        JP CLEAR_GAME_FLAG_BIT0_AND_RETURN

ADVANCE_GAME_ANIMATION_COUNTER:
        LD HL,$20B7
        LD A,(HL)
        INC (HL)
        AND A
        JP NZ,LOAD_GAME_ANIMATION_RECORD
        LD A,$28
        OUT ($03),A
        LD A,$04
        LD ($2034),A
        LD ($2033),A
        RET

LOAD_GAME_ANIMATION_RECORD:
        LD HL,$1922
        LD DE,$20AD
        LD A,$04

PROCESS_GAME_ANIMATION_BYTE:
        PUSH AF
        LD A,(DE)
        INC DE
        PUSH DE
        PUSH AF
        LD E,(HL)
        INC HL
        LD D,(HL)
        INC HL
        LD A,(HL)
        SUB $03
        LD B,A
        INC HL
        LD C,$01
        POP AF
        PUSH HL
        EX DE,HL
        LD DE,$2310
        AND A
        JP Z,ADVANCE_ANIMATION_RECORD
        CALL COPY_SCREEN_ROW_LOOP
        LD DE,GRAPHIC_RESOURCE_0D23
        LD B,$03
        CALL COPY_SCREEN_ROW_LOOP

ADVANCE_ANIMATION_RECORD:
        POP HL
        POP DE
        POP AF
        DEC A
        JP NZ,PROCESS_GAME_ANIMATION_BYTE
        LD HL,$20AD
        LD BC,$0504

READ_ANIMATION_RECORD_VALUE:
        LD A,(HL)
        INC HL
        AND A
        RET Z
        DEC C
        JP NZ,READ_ANIMATION_RECORD_VALUE

FILL_ANIMATION_FIELD_COUNTER:
        LD (HL),C
        DEC HL
        DEC B
        JP NZ,FILL_ANIMATION_FIELD_COUNTER
        XOR A
        LD ($2081),A
        LD HL,$1A69
        LD DE,$3EA7
        LD A,$11
        CALL DRAW_ENCODED_GRAPHIC
        LD A,$20
        JP INCREMENT_PACKED_BCD_SCORE

NATIVE_RETURN_STUB_1DE9:
        RET

TEST_SCENE_STATE_FOR_RESET:
        LD A,($20BA)
        AND A
        JP Z,BEGIN_GAME_RECORD_RESET
        LD A,$0C
        LD ($203B),A
        RET

BEGIN_GAME_RECORD_RESET:
        LD A,$03

SCAN_GAME_RECORD_RESET_FLAGS:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND A
        JP P,ADVANCE_GAME_RECORD_RESET
        AND $04
        JP NZ,ADVANCE_GAME_RECORD_RESET
        LD A,(HL)
        OR $04
        LD (HL),A

ADVANCE_GAME_RECORD_RESET:
        POP AF
        DEC A
        JP P,SCAN_GAME_RECORD_RESET_FLAGS
        RET
; Detect changes in input-port $02 bit $40 and update RAM $2016.
SAMPLE_INPUT_BIT6_EDGE:
        LD HL,$2016
        IN A,($02)
        CPL
        AND $40
        LD B,A
        XOR (HL)
        RET Z
        LD (HL),B
        LD A,B
        AND A
        RET Z
        LD A,$04
        OUT ($03),A
        LD A,$0A
        LD ($2034),A
        XOR A
        OUT ($07),A
        IN A,($02)
        LD C,A
        AND $02
        LD HL,$2017
        JP Z,CLEAR_OBJECT_FIELD_AND_ADVANCE_COUNTER
        INC (HL)
        LD A,(HL)
        CP $02
        RET C
        LD (HL),$00
        INC HL
        LD A,C
        RRA
        INC (HL)
        RET NC
        INC (HL)
        INC (HL)
        RET

CLEAR_OBJECT_FIELD_AND_ADVANCE_COUNTER:
        LD (HL),$00
        INC HL
        INC (HL)
        LD A,C
        RRA
        RET NC
        INC (HL)
        RET

; ROM fill uses $FF up to the final original device check byte.
ROM_FF_PADDING:
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; Last original ROM byte at $1FFF. The preceding fill is $FF; this is
; a distinct terminal device byte, retained exactly for checksum matching.
ROM_DEVICE_FINAL_BYTE:
        DB $4E
