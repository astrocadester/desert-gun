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
        JP FLOW_IO_065A
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
        JP M,FLOW_IO_0566
        CPL

FLOW_IO_0566:
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
        JP NZ,FLOW_IO_05A6

FLOW_IO_0587:
        PUSH DE
        PUSH HL

FLOW_IO_0589:
        LD A,(BC)
        INC BC
        OUT ($02),A
        IN A,($03)
        LD (HL),A
        INC HL
        DEC E
        JP NZ,FLOW_IO_0589
        XOR A
        OUT ($02),A
        IN A,($03)
        LD (HL),A
        POP HL
        LD DE,$0020
        ADD HL,DE
        POP DE
        DEC D
        JP NZ,FLOW_IO_0587
        RET

FLOW_IO_05A6:
        LD A,E
        ADD A,L
        LD L,A

FLOW_IO_05A9:
        PUSH DE
        PUSH HL

FLOW_IO_05AB:
        LD A,(BC)
        INC BC
        OUT ($02),A
        IN A,($00)
        LD (HL),A
        DEC HL
        DEC E
        JP NZ,FLOW_IO_05AB
        XOR A
        OUT ($02),A
        IN A,($00)
        LD (HL),A
        POP HL
        LD DE,$0020
        ADD HL,DE
        POP DE
        DEC D
        JP NZ,FLOW_IO_05A9
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
        JP NZ,FLOW_IO_05D6
        LD (HL),A

FLOW_IO_05D6:
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

FLOW_IO_05E6:
        PUSH BC
        PUSH HL

FLOW_IO_05E8:
        LD (HL),A
        INC HL
        DEC C
        JP NZ,FLOW_IO_05E8
        POP HL
        ADD HL,DE
        POP BC
        DEC B
        JP NZ,FLOW_IO_05E6
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
        JP NZ,FLOW_IO_061B
        LD HL,$2008
        LD A,(HL)
        AND A
        JP Z,FLOW_IO_061B
        ADD A,$99
        DAA
        LD (HL),A
        JP NZ,FLOW_IO_061B
        LD B,$01

FLOW_IO_061B:
        LD C,$01
        LD HL,$2030
        CALL DECREMENT_NONZERO_TIMER_BYTE
        LD ($207C),A
        RET
; Decrement pointed timer if positive and advance game state.
DECREMENT_NONZERO_TIMER_BYTE:
        LD A,(HL)
        AND A
        JP Z,FLOW_IO_0631
        DEC (HL)
        JP NZ,FLOW_IO_0631
        SCF

FLOW_IO_0631:
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

FLOW_IO_065A:
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
        JP P,FLOW_IO_0675
        CP $F0
        JP NC,FLOW_IO_067F
        JP FLOW_IO_0685

FLOW_IO_0675:
        PUSH HL
        LD HL,$06DC
        ADD HL,BC
        CP (HL)
        POP HL
        JP C,FLOW_IO_0685

FLOW_IO_067F:
        EX (SP),HL
        LD A,(HL)
        AND $F7
        LD (HL),A
        EX (SP),HL

FLOW_IO_0685:
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
        JP C,FLOW_IO_0697
        CP E
        JP C,FLOW_IO_06A6

FLOW_IO_0697:
        LD (HL),B
        EX (SP),HL
        LD A,(HL)
        AND $02
        EX (SP),HL
        JP NZ,FLOW_IO_06AA
        DEC HL
        LD A,(HL)
        CPL
        INC A
        LD (HL),A
        INC HL

FLOW_IO_06A6:
        INC HL
        INC (HL)
        POP HL
        RET

FLOW_IO_06AA:
        DEC HL
        LD (HL),$00
        INC HL
        JP FLOW_IO_06A6
; Increment RAM $207F and update related state.
ADVANCE_COUNTER_207F:
        LD HL,$207F
        INC (HL)
        LD A,(HL)
        LD DE,$2014
        LD BC,$007F
        RRA
        JP C,FLOW_IO_06C4
        LD BC,$086F
        INC DE

FLOW_IO_06C4:
        IN A,($01)
        SUB $10
        JP NC,FLOW_IO_06CC
        XOR A

FLOW_IO_06CC:
        CP C
        JP C,FLOW_IO_06D1
        LD A,C

FLOW_IO_06D1:
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
GUN_GRAPHICS_AND_SHAPE_DATA:
        DB $F0,$E8,$E8,$E0,$E0,$E8,$E8,$F0,$02,$16,$01,$04
        DB $08,$1E,$3C,$0F,$F8,$4F,$FC,$07,$FE,$07,$7F,$0F
        DB $FE,$3F,$FC,$7F,$F0,$3F,$F9,$39,$F8,$7F,$D0,$3F
        DB $FC,$0F,$FC,$47,$FE,$07,$FF,$0D,$E4,$1F,$C2,$3F
        DB $C9,$77,$80,$03,$80,$21,$01,$0F,$20,$20,$10,$10
        DB $09,$09,$0D,$0F,$0F,$1E,$16,$1C,$08,$08,$08,$03
        DB $0C,$00,$1C,$00,$00,$2A,$00,$00,$1C,$00,$E0,$FF
        DB $03,$10,$7F,$04,$08,$7F,$08,$04,$6B,$10,$04,$3E
        DB $10,$04,$1C,$10,$04,$08,$10,$04,$08,$10,$00,$08
        DB $00,$03,$0C,$00,$1C,$00,$00,$2A,$00,$7F,$1C,$7F
        DB $C0,$FF,$01,$00,$7F,$00,$00,$7F,$00,$00,$6B,$00
        DB $00,$3E,$00,$00,$1C,$00,$00,$08,$00,$00,$08,$00
        DB $00,$08,$00,$03,$0C,$3F,$1C,$7E,$60,$2A,$03,$C0
        DB $9C,$01,$80,$FF,$00,$00,$7F,$00,$00,$7F,$00,$00
        DB $6B,$00,$00,$3E,$00,$00,$1C,$00,$00,$08,$00,$00
        DB $08,$00,$00,$08,$00,$04,$16,$00,$00,$00,$61,$00
        DB $00,$00,$63,$00,$00,$00,$63,$00,$00,$00,$63,$00
        DB $00,$00,$22,$00,$00,$00,$7F,$00,$00,$80,$FF,$00
        DB $00,$80,$EB,$00,$00,$80,$EB,$00,$00,$00,$7F,$00
        DB $F0,$80,$3E,$00,$F8,$C3,$1D,$01,$FC,$FF,$09,$0E
        DB $FF,$FF,$08,$F8,$F3,$FF,$00,$E0,$70,$FE,$00,$00
        DB $38,$F0,$07,$00,$4C,$60,$04,$00,$44,$30,$04,$00
        DB $C4,$18,$04,$00,$84,$08,$00,$00,$04,$04,$00,$04
        DB $16,$00,$00,$00,$61,$00,$00,$00,$63,$00,$00,$00
        DB $63,$00,$00,$00

        ORG $0800
; ROM device 9316.1g, SHA1 8fb8e85844a8ec6c0722883013ecdd4eeaeb08c1

        DB $63,$00,$00,$00,$22,$00,$00,$00,$7F,$00,$00,$80
        DB $FF,$00,$00,$80,$FF,$00,$00,$80,$EB,$00,$00,$00
        DB $7F,$00,$F0,$80,$3E,$00,$F8,$C3,$1D,$01,$FC,$FF
        DB $09,$0E,$FF,$FF,$08,$F8,$F3,$FF,$00,$E0,$F0,$FC
        DB $00,$00,$70,$F0,$00,$00,$30,$60,$00,$00,$10,$20
        DB $00,$00,$10,$20,$00,$00,$10,$20,$00,$00,$10,$10
        DB $00,$04,$16,$00,$00,$00,$61,$00,$00,$00,$63,$00
        DB $00,$00,$63,$00,$00,$00,$63,$00,$00,$00,$22,$00
        DB $00,$00,$7F,$00,$00,$80,$FF,$00,$00,$80,$EB,$00
        DB $00,$80,$EB,$00,$00,$00,$7F,$00,$F0,$80,$3E,$00
        DB $F8,$C3,$1D,$01,$FC,$FF,$09,$0E,$FF,$FF,$08,$F8
        DB $F3,$FF,$00,$E0,$70,$FE,$00,$00,$F0,$F0,$00,$00
        DB $E8,$C1,$01,$00,$8C,$23,$03,$00,$04,$12,$04,$00
        DB $04,$0A,$02,$00,$00,$01,$01,$04,$0B,$00,$00,$F8
        DB $F8,$00,$00,$88,$88,$00,$00,$C8,$9F,$00,$C0,$E1
        DB $3F,$C0,$41,$63,$32,$00,$07,$66,$32,$0C,$06,$CE
        DB $1F,$04,$0E,$BF,$0F,$0C,$CE,$7F,$07,$38,$FF,$3F
        DB $02,$F0,$FF,$1F,$02,$03,$16,$00,$80,$00,$00,$00
        DB $01,$00,$00,$02,$00,$00,$0C,$00,$00,$F6,$00,$00
        DB $7E,$00,$00,$07,$00,$00,$03,$F0,$8F,$03,$F8,$FF
        DB $01,$FD,$FF,$01,$FE,$FF,$00,$FE,$FF,$00,$FC,$7F
        DB $00,$FC,$70,$00,$38,$20,$00,$30,$30,$00,$60,$10
        DB $00,$40,$10,$00,$40,$08,$00,$40,$08,$00,$40,$04
        DB $00,$03,$1A,$00,$20,$00,$00,$40,$00,$00,$80,$00
        DB $00,$00,$03,$00,$80,$3D,$00,$80,$1F,$00,$80,$03
        DB $00,$80,$03,$00,$80,$03,$00,$80,$03,$00,$F8,$01
        DB $80,$FF,$01,$F8,$FF,$01,$F8,$FF,$01,$FC,$FF,$00
        DB $FD,$DF,$00,$F8,$83,$01,$78,$00,$03,$38,$00,$02
        DB $18,$00,$01,$0C,$80,$00,$02,$00,$00,$02,$00,$00
        DB $02,$00,$00,$02,$00,$00,$02,$00,$00,$03,$12,$00
        DB $80,$00,$00,$00,$01,$00,$00,$02,$00,$00,$0C,$00
        DB $00,$F6,$00,$00,$7E,$00,$00,$07,$00,$80,$03,$F0
        DB $FF,$03,$FC,$FF,$01,$FF,$FF,$01,$FE,$FF,$00,$FE
        DB $FF,$00,$FE,$FF,$00,$FC,$E3,$00,$38,$80,$01,$30
        DB $00,$03,$3F,$F0,$01,$03,$15,$00,$80,$00,$00,$00
        DB $01,$00,$00,$02,$00,$00,$0C,$70,$00,$F6,$FD,$01
        DB $7E,$FE,$07,$07,$FC,$FF,$03,$FC,$FF,$01,$F8,$FF
        DB $00,$F8,$7F,$00,$1F,$3F,$00,$00,$1C,$00,$00,$04
        DB $00,$00,$04,$00,$00,$04,$00,$00,$0C,$00,$00,$08
        DB $00,$00,$08,$00,$00,$08,$00,$00,$08,$00,$03,$07
        DB $00,$40,$00,$D0,$80,$00,$E0,$01,$01,$E0,$07,$06
        DB $F0,$0F,$7B,$E0,$FF,$3F,$FF,$F8,$07,$02,$18,$80
        DB $03,$C0,$07,$E0,$0F,$F0,$1F,$F8,$1F,$F8,$3F,$FC
        DB $3F,$CC,$33,$CC,$33,$CE,$33,$FE,$7F,$CE,$73,$FF
        DB $7F,$F6,$7E,$F7,$DE,$F7,$DF,$F3,$DF,$FB,$CF,$F9
        DB $CF,$F1,$9F,$F1,$8F,$61,$86,$40,$82,$78,$3E,$02
        DB $1E,$80,$03,$C0,$07,$E0,$0F,$F0,$1F,$F8,$1F,$F8
        DB $3F,$FC,$3F,$CC,$33,$FC,$3F,$CE,$33,$CE,$73,$CE
        DB $73,$FE,$7F,$F6,$7E,$F7,$DE,$F7,$DF,$F3,$DF,$FB
        DB $CF,$F9,$CF,$F1,$9F,$F1,$8F,$61,$86,$40,$82,$40
        DB $02,$40,$02,$40,$02,$40,$02,$40,$02,$40,$02,$78
        DB $3E,$02,$15,$80,$03,$C0,$07,$E0,$0F,$F0,$1F,$F8
        DB $1F,$F8,$3F,$FC,$3F,$CC,$33,$CC,$33,$CE,$33,$CE
        DB $73,$CE,$73,$FE,$7F,$FE,$7E,$F7,$DE,$F7,$DF,$F3
        DB $BF,$F3,$CF,$61,$86,$41,$82,$79,$DE,$02,$0E,$E0
        DB $07,$F0,$1F,$F8,$1F,$F8,$3F,$FC,$3F,$CC,$33,$CC
        DB $33,$CE,$33,$CE,$F3,$CE,$F3,$FE,$FF,$6E,$9E,$42
        DB $82,$7A,$BE,$02,$09,$E0,$07,$F0,$1F,$F8,$1F,$F8
        DB $3F,$CC,$33,$CE,$F3,$7E,$9E,$42,$82,$7A,$BE,$03
        DB $12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0,$FF
        DB $00,$38,$C6,$01,$BC,$D6,$03,$BE,$D6,$07,$3F,$C6
        DB $0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00,$04
        DB $00,$00,$04,$00,$00,$04,$00,$00,$04,$00,$00,$04
        DB $00,$00,$04,$00,$00,$1C,$00,$03,$12,$00,$0F,$00
        DB $C0,$3F,$00,$E0,$7F,$00,$F0,$FF,$00,$38,$C6,$01
        DB $3C,$C6,$03,$BE,$D6,$07,$3F,$C6,$0F,$FE,$FF,$07
        DB $F8,$FF,$01,$80,$1F,$00,$00,$04,$00,$00,$0C,$00
        DB $00,$1A,$00,$00,$31,$00,$00,$21,$00,$00,$21,$00
        DB $00,$E7,$00,$03,$12,$00,$0F,$00,$C0,$3F,$00,$E0
        DB $7F,$00,$F0,$FF,$00,$38,$C6,$01,$3C,$C6,$03,$3E
        DB $C6,$07,$3F,$C6,$0F,$FE,$FF,$07,$F8,$FF,$01,$80
        DB $1F,$00,$00,$04,$00,$00,$0A,$00,$00,$11,$00,$80
        DB $20,$00,$40,$40,$00,$20,$80,$00,$E0,$80,$03,$03
        DB $12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0,$FF
        DB $00,$38,$C6,$01,$3C,$C6,$03,$BE,$D6,$07,$3F,$C6
        DB $0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00,$04
        DB $00,$00,$0A,$00,$00,$11,$00,$80,$10,$00,$40,$10
        DB $00,$20,$10,$00,$E0,$70,$00,$02,$0F,$00,$20,$00
        DB $38,$00,$3E,$00,$3F,$80,$3B,$C0,$31,$E0,$20,$F0
        DB $31,$B8,$3B,$1C,$3F,$0C,$3E,$1C,$1F,$BC,$0F,$FE
        DB $07,$FF,$03,$03,$0B,$80,$1F,$00,$F8,$FF,$01,$FE
        DB $FF,$07,$3F,$C6,$0F,$7E,$EF,$07,$BC,$D6,$03,$78
        DB $EF,$01,$F0,$FF,$00,$E0,$7F,$00,$C0,$3F,$00,$00
        DB $0F,$00,$02,$0B,$C0,$01,$00,$01,$00,$01,$00,$01
        DB $04,$01,$04,$01,$04,$01,$87,$07,$FD,$0F,$FF,$1F
        DB $00,$07,$02,$12,$00,$0E,$00,$0A,$00,$7E,$00,$06
        DB $01,$06,$0E,$06,$3C,$06,$F8,$07,$F8,$07,$F0,$03
        DB $E0,$01,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00
        DB $80,$00,$80,$03,$02,$12,$00,$0E,$00,$0A,$00,$7E
        DB $00,$06,$01,$06,$0E,$06,$3C,$06,$F8,$07,$F8,$07
        DB $F0,$03,$E0,$01,$80,$00,$40,$01,$20,$02,$10,$02
        DB $08,$02,$04,$02,$1C,$0E,$02,$12,$00,$0E,$00,$0A
        DB $00,$7E,$00,$06,$01,$06,$0E,$06,$3C,$06,$F8,$07
        DB $F8,$07,$F0,$03,$E0,$01,$80,$00,$40,$01,$20,$02
        DB $10,$04,$08,$08,$04,$10,$1C,$70,$02,$12,$00,$0E
        DB $00,$0A,$00,$7E,$00,$06,$01,$06,$0E,$06,$3C,$06
        DB $F8,$07,$F8,$07,$F0,$03,$E0,$01,$80,$00,$80,$01
        DB $40,$03,$20,$06,$20,$04,$20,$04,$E0,$1C,$01,$1B
        DB $18,$18,$18,$3C,$3C,$7E,$7E,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7E,$3C,$3C
        DB $7E,$7E,$FF,$02,$10,$E0,$07,$C0,$03,$C0,$03,$F8
        DB $1F,$FF,$FF,$FF,$FF,$FF,$FF,$1F,$F0,$8F,$F4,$2F
        DB $F1,$4F,$F4,$0F,$F0,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$01,$1A,$18,$18,$18,$18,$3C,$7E,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        DB $FF,$FF,$FF,$FF,$FF,$01,$10,$3C,$3C,$18,$18,$FF
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80
        DB $00,$02,$00,$48,$00,$28,$00,$18,$00,$9B,$00,$1E
        DB $00,$3C,$00,$79,$00,$DC,$00,$1E,$00,$3F,$00,$4C
        DB $00,$40,$00,$C4,$00,$D2,$00,$30,$00,$6C,$00,$FA
        DB $00,$03,$0D,$00,$70,$00,$00,$F8,$01,$00,$FC,$03
        DB $00,$3C,$0F,$00,$1E,$1E,$08,$1E,$BE,$18,$3F,$FF
        DB $3C,$3F,$EF,$BC,$FF,$C3,$FE,$FF,$80,$3F,$63,$00
        DB $1E,$42,$00,$0F,$C6,$00,$04,$0E,$00,$00,$7C,$00
        DB $00,$80,$FF,$01,$02,$F0,$FF,$03,$04,$FF,$3F,$8F
        DB $E8,$FF,$1F,$FE,$F2,$FF,$9F,$FE,$E8,$FF,$3F,$FF
        DB $04,$FF,$FF,$8F,$02,$FC,$FF,$00,$00,$FC,$FF,$00
        DB $00,$0C,$63,$00,$00,$18,$C1,$00,$00,$10,$81,$00
        DB $00,$30,$83,$01,$04,$0E,$00,$00,$7C,$00,$00,$80
        DB $FF,$01,$02,$F0,$FF,$03,$04,$FF,$3F,$0F,$E8,$FF
        DB $1F,$BE,$F2,$FF,$5F,$FE,$E8,$FF,$3F,$FF,$04,$FF
        DB $FF,$CF,$02,$FC,$FF,$83,$00,$FC,$FF,$00,$00,$0C
        DB $63,$00,$00,$84,$21,$00,$00,$84,$20,$00,$00,$8C
        DB $61,$00,$04,$0E,$00,$00,$7C,$00,$00,$80,$FF,$01
        DB $02,$F0,$FF,$03,$04,$FF,$3F,$8F,$E8,$FF,$9F,$FE
        DB $F2,$FF,$1F,$FE,$E8,$FF,$3F,$FF,$04,$FF,$FF,$8F
        DB $02,$FC,$FF,$03,$00,$FC,$FF,$00,$00,$8C,$61,$00
        DB $00,$06,$33,$00,$00,$02,$12,$00,$00,$06,$36,$00
        DB $03,$0E,$80,$3F,$3F,$80,$F0,$23,$80,$F8,$23,$80
        DB $FE,$23,$00,$DE,$22,$80,$F3,$23,$E0,$C1,$01,$F0
        DB $C3,$00,$F8,$CF,$00,$F8,$0F,$00,$FA,$0F,$00,$FF
        DB $07,$00,$E3,$03,$00,$F2,$7F,$00,$03,$25,$00,$18
        DB $00,$00,$38,$00,$00,$38,$38,$00,$38,$38,$00,$70
        DB $08,$00,$70,$0C,$00,$70,$0C,$00,$60,$0C,$00,$60
        DB $06,$00,$E0,$07,$00,$E0,$07,$00,$A0,$05,$00,$E0
        DB $07,$00,$C0,$03,$00,$F0,$03,$00,$B8,$01,$00,$3C
        DB $01,$00,$1E,$00,$00,$3F,$00,$80,$FF,$03,$C0,$07
        DB $03,$C0,$07,$03,$E0,$07,$00,$E0,$03,$00,$E0,$03
        DB $00,$F0,$03,$00,$F0,$01,$00,$F6,$01,$00,$FF,$03
        DB $00,$C6,$07,$00,$80,$07,$00,$00,$07,$00,$00,$03
        DB $00,$80,$01,$00,$C0,$01,$00,$C0,$00,$00,$E0,$0F
        DB $00,$03,$21,$00,$18,$00,$00,$38,$00,$00,$38,$78
        DB $00,$38,$78,$00,$70,$48,$00,$70,$0C,$00,$70,$0C
        DB $00,$60,$0C,$00,$60,$06,$00,$E0,$07,$00,$E0,$07
        DB $00,$A0,$05,$00,$E0,$07,$00,$E0,$03,$00,$B0,$03
        DB $00,$B8,$01,$00,$3C,$01,$00,$1E,$00,$00,$3F,$00
        DB $80,$FF,$1F,$C0,$07,$00,$C0,$07,$00,$E0,$07,$00
        DB $E0,$03,$00,$E0,$0F,$00,$F0,$1F,$00,$F0,$1F,$00
        DB $F6,$1F,$00,$1F,$0C,$00,$06,$06,$00,$00,$07,$00
        DB $00,$03,$00,$80,$3F,$00,$03,$1F,$00,$18,$00,$00
        DB $38,$00,$00,$38,$38,$00,$38,$38,$00,$70,$08,$00
        DB $70,$0C,$00,$70,$0C,$00,$60,$0C,$00,$60,$06,$00
        DB $E0,$07,$00,$E0,$07,$00,$A0,$05,$00,$E0,$07,$00
        DB $E0,$03,$00,$B0,$03,$00,$B8,$01,$00,$3C,$01,$00
        DB $1E,$00,$00,$3F,$00,$80,$FF,$03,$C0,$07,$03,$C0
        DB $07,$03,$E0,$07,$00,$E0,$03,$00,$E0,$07,$00,$F0
        DB $1F,$00,$E0,$1F,$00,$F6,$1F,$00,$FF,$0F,$00,$C6
        DB $07,$00,$E0,$FF,$00
; Indexed-command vector table. Twelve native handlers; $00 enters scheduler directly.
ROM_GAME_WORD_00:
        DW $0FAB

ROM_GAME_WORD_01:
        DW $0F94

ROM_GAME_WORD_02:
        DW $0FA2

ROM_GAME_WORD_03:
        DW $0FAC

ROM_GAME_WORD_04:
        DW $0FBE

ROM_GAME_WORD_05:
        DW $0FC7

ROM_GAME_WORD_06:
        DW $0FD3

ROM_GAME_WORD_07:
        DW $100E

ROM_GAME_WORD_08:
        DW $1047

ROM_GAME_WORD_09:
        DW $0F8E

ROM_GAME_WORD_0A:
        DW $106D

ROM_GAME_WORD_0B:
        DW $107A

ROM_GAME_WORD_0C:
        DW $0F7B

NATIVE_WORD_0C_DRAW_PACKET:
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

NATIVE_WORD_09_DRAW_MODE_B:
; Word $09: choose drawing continuation $0167.
WORD_09_DRAW_MODE_B_ENTRY:
        LD HL,$0167
        JP WORD_DRAW_COMMON

NATIVE_WORD_01_DRAW_MODE_A:
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

NATIVE_WORD_02_SET_RAM_2031:
; Word $02: write one byte to RAM $2031.
WORD_02_SET_MODE_ENTRY:
        EX DE,HL
        LD A,(HL)
        LD ($2031),A
        INC HL
        LD ($2000),HL

WORD_RETURN_STUB:
        RET

NATIVE_WORD_03_SET_MODE_AND_PTR:
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

NATIVE_WORD_04_BRANCH_SCRIPT:
; Word $04: load inline script destination into RAM $2000.
WORD_04_SCRIPT_GOTO_ENTRY:
        EX DE,HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        EX DE,HL
        LD ($2000),HL
        RET

NATIVE_WORD_05_STORE_BYTE:
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

NATIVE_WORD_06_CLEAR_DISPLAY:
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

FLOW_TABLE_0FFB:
        LD A,(DE)
        INC DE
        LD (HL),A
        INC HL
        DEC C

        ORG $1000
; ROM device 9316.1f, SHA1 1cc4e9b0aa7e9546c133bd40d40ede6f2fbe93ba

        JP NZ,FLOW_TABLE_0FFB
        POP HL
        LD BC,$0020
        ADD HL,BC
        POP BC
        DEC B
        JP NZ,COPY_SCREEN_ROW_LOOP
        RET

NATIVE_WORD_07_INIT_DESCRIPTOR:
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

NATIVE_WORD_08_DRAW_AND_BRANCH:
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

NATIVE_WORD_0A_CLEAR_FLAG_BIT3:
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

NATIVE_WORD_0B_RESET_ROUND:
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

OBJECT_SEQUENCE_TABLE:
        DB $43,$53,$63,$73,$84,$01,$08,$01,$0D,$01,$11,$01
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

FLOW_WORD_116C:
        LD (HL),B
        INC HL
        DEC C
        JP NZ,FLOW_WORD_116C
        POP HL
        LD A,($20B9)
        AND A
        JP Z,FLOW_WORD_1181

FLOW_WORD_117A:
        LD (HL),$5B
        INC HL
        DEC A
        JP NZ,FLOW_WORD_117A

FLOW_WORD_1181:
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

FLOW_WORD_11AE:
        LD A,(HL)
        CP $30
        RET NZ
        LD (HL),$40
        INC HL
        DEC C
        JP NZ,FLOW_WORD_11AE
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

FLOW_FRAME_1214:
        ADD HL,DE
        DEC A
        JP P,FLOW_FRAME_1214
        RET
; Visit object field at RAM $2085 with game-state parameters.
UPDATE_OBJECT_FIELDS_2085:
        LD HL,$2085
        LD DE,$203B
        LD BC,$0008

FLOW_FRAME_1223:
        INC DE
        ADD HL,BC
        LD A,(HL)
        AND A
        JP NZ,FLOW_FRAME_1223
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
        JP NZ,FLOW_FRAME_123E
        DEC A

FLOW_FRAME_123E:
        LD B,A
        AND $1D
        JP PE,FLOW_FRAME_1246
        LD C,$80

FLOW_FRAME_1246:
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
        LD HL,$06DC
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
        CALL C,FLOW_GAME_1C22
        POP AF
        RRA
        CALL C,FLOW_GAME_1977
        RET

FRAME_SERVICE_12B1:
        LD HL,$207D
        LD A,(HL)
        AND A
        RET Z
        LD (HL),$00
        RRA
        PUSH AF
        CALL C,FLOW_FRAME_13F2
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_FRAME_13C1
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1C43
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_FRAME_1345
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1C35
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1D77
        POP AF
        RRA
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1C2D
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
        CALL C,FLOW_GAME_1CE4
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1CDB
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1CD2
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1CC9
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1DEA
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1D4B
        POP AF
        RRA
        PUSH AF
        CALL C,FLOW_GAME_1D36
        POP AF
        RET

FRAME_SERVICE_1318:
        LD HL,$2037
        LD A,(HL)
        AND A
        JP NZ,FLOW_FRAME_132E
        LD A,($2040)
        AND A
        JP M,FLOW_FRAME_132E
        LD A,($204F)
        AND A
        CALL P,FLOW_FRAME_133C

FLOW_FRAME_132E:
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

FLOW_FRAME_133C:
        CALL SERVICE_GAME_STATE_201E
        AND $3F
        OR $20
        LD (HL),A
        RET

FLOW_FRAME_1345:
        CALL SERVICE_GAME_STATE_201E
        AND $3F
        OR $20
        LD ($2035),A
        LD A,($20BA)
        AND A
        RET NZ
        LD A,$03

FLOW_FRAME_1356:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND A
        JP P,FLOW_FRAME_136C
        AND $02
        JP NZ,FLOW_FRAME_136C
        PUSH HL
        CALL CHECK_OBJECT_STATUS_LOW_BITS
        POP HL
        CALL UPDATE_GAME_TIMER_2032

FLOW_FRAME_136C:
        POP AF
        DEC A
        JP P,FLOW_FRAME_1356
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
        JP Z,FLOW_FRAME_138A
        LD A,($2009)
        CP $02
        RET M

FLOW_FRAME_138A:
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
        CALL Z,FLOW_FRAME_14AE
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

FLOW_FRAME_13C1:
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

FLOW_FRAME_13F2:
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
        JP NZ,FLOW_FRAME_1442
        LD ($2081),A

FLOW_FRAME_1442:
        LD HL,$14CB
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
        LD HL,$06DC
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
        JP NC,FLOW_FRAME_1485
        INC A

FLOW_FRAME_1485:
        CP $07
        JP C,FLOW_FRAME_148C
        LD A,$06

FLOW_FRAME_148C:
        DEC C
        JP P,FLOW_FRAME_1492
        ADD A,$03

FLOW_FRAME_1492:
        INC C
        RET
; Write flag $01 and update related object-field values.
SET_OBJECT_FLAG_ACTIVE:
        CALL STORE_OBJECT_FIELD_AND_LOOKUP
        LD (HL),$01
        DEC HL
        CALL BOUND_GAME_COUNTER_2009
        JP FLOW_FRAME_14A8
; Use object shape lookup to update corresponding field.
SET_OBJECT_FROM_SHAPE_TABLE:
        CALL STORE_OBJECT_FIELD_AND_LOOKUP
        CALL FETCH_GUN_SHAPE_TABLE_BYTE
        CPL
        INC A

FLOW_FRAME_14A8:
        LD (HL),A
        DEC HL
        LD (HL),C
        DEC HL
        DEC C
        RET P

FLOW_FRAME_14AE:
        LD DE,$20B8
        LD A,(DE)
        AND A
        RET NZ
        LD A,$04
        LD (DE),A
        LD ($203A),A
        RET

FRAME_PATTERN_TABLE:
        DB $00,$00,$00,$01,$01,$01,$02,$02,$03,$03,$04,$05
        DB $06,$06,$07,$07,$FE,$0B,$23,$07,$C3,$0A,$95,$07
        DB $52,$0D,$2C,$0E,$D1,$08,$F5,$09,$01,$01,$01,$01
        DB $01,$04,$02,$03,$66,$A4,$66,$A7,$66,$96,$66,$A0
        DB $66,$A8,$66,$97,$66,$A0,$66,$9E,$0C,$4A,$0C,$4D
        DB $0C,$3C,$0C,$46,$0C,$4E,$0C,$3D,$0C,$46,$0C,$44

FRAME_REBUILD_OBJECTS:
        LD A,$03

FLOW_OBJECT_1505:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND A
        JP P,FLOW_OBJECT_155E
        PUSH HL
        LD D,A
        INC HL
        LD E,(HL)
        LD BC,$0007
        ADD HL,BC
        LD C,E
        PUSH HL
        LD HL,$1584
        AND $02
        JP Z,FLOW_OBJECT_1523
        LD HL,$158C

FLOW_OBJECT_1523:
        ADD HL,BC
        LD A,(HL)
        POP HL
        CP (HL)
        JP NC,FLOW_OBJECT_1538
        LD (HL),$00
        EX (SP),HL
        LD A,(HL)
        AND $02
        JP Z,FLOW_OBJECT_1537
        LD A,(HL)
        AND $F7
        LD (HL),A

FLOW_OBJECT_1537:
        EX (SP),HL

FLOW_OBJECT_1538:
        EX DE,HL
        LD A,H
        LD HL,$1564
        AND $02
        JP Z,FLOW_OBJECT_1545
        LD HL,$1574

FLOW_OBJECT_1545:
        ADD HL,BC
        ADD HL,BC
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        LD A,(DE)

FLOW_OBJECT_154C:
        INC HL
        INC HL
        CP (HL)
        INC HL
        JP NC,FLOW_OBJECT_154C
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

FLOW_OBJECT_155E:
        POP AF
        DEC A
        JP P,FLOW_OBJECT_1505
        RET

OBJECT_NATIVE_POINTERS:
        DW $15CE
        DW $161F
        DW $15B9
        DW $160D
        DW $1592
        DW $15A4
        DW $15E0
        DW $15F5
        DW $15DA
        DW $162B
        DW $15C5
        DW $1619
        DW $159E
        DW $15B3

OBJECT_MOTION_DATA:
        DB $EF,$15,$FE,$15,$04,$08,$08,$0C
        DB $14,$17,$3A,$25,$14,$14,$0F,$14,$19,$19,$14,$1E
        DB $05,$52,$0D,$0A,$8C,$0D,$0F,$C6,$0D,$FF,$8C,$0D
        DB $05,$E4,$06,$FF,$29,$0D,$06,$2C,$0E,$0A,$9D,$0E
        DB $0F,$02,$0F,$13,$9D,$0E,$FF,$2C,$0E,$05,$E4,$06
        DB $FF,$00,$0E,$02,$C3,$0A,$04,$FB,$0A,$06,$33,$0B
        DB $FF,$6B,$0B,$05,$E4,$06,$0F,$A3,$0B,$FF,$C3,$0B
        DB $01,$FE,$0B,$02,$24,$0C,$03,$4A,$0C,$FF,$70,$0C
        DB $05,$E4,$06,$FF,$E6,$0B,$05,$65,$09,$19,$9D,$09
        DB $1E,$D1,$08,$37,$15,$09,$FF,$65,$09,$05,$E4,$06
        DB $FF,$DE,$09,$0E,$27,$0A,$19,$F5,$09,$FF,$27,$0A
        DB $05,$E4,$06,$0F,$F5,$09,$14,$65,$0A,$19,$91,$0A
        DB $FF,$AF,$0A,$03,$95,$07,$06,$EF,$07,$09,$49,$08
        DB $FF,$EF,$07,$05,$E4,$06,$FF,$A3,$08,$02,$49,$07
        DB $04,$6F,$07,$06,$49,$07,$FF,$23,$07,$05,$E4,$06
        DB $FF,$12,$07

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
        DB $06,$01,$08,$02,$78,$00,$01,$09,$02,$3C,$00,$0C
        DB $0D,$4B,$1A,$09,$30,$05,$06,$B9,$20,$05,$01,$0D
        DB $20,$05,$01,$81,$20,$05,$01,$35,$20,$00,$05,$00
        DB $0D,$20,$05,$00,$37,$20,$05,$00,$38,$20,$0C,$10
        DB $4B,$1A,$00,$24,$0C,$10,$4B,$1A,$10,$24,$0C,$10
        DB $4B,$1A,$A0,$3E,$0C,$10,$4B,$1A,$B0,$3E,$08,$06
        DB $20,$A0,$3E,$01,$05,$08,$0B,$20,$00,$24,$01,$06
        DB $01,$04,$08,$1C,$20,$1B,$24,$02,$1E,$00,$0A,$40
        DB $20,$0A,$4F,$20,$0A,$5E,$20,$0A,$6D,$20,$02,$0F
        DB $00,$09,$00,$09,$01,$02,$F0,$00,$04,$33,$16

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
        JP Z,FLOW_GAME_189F
        DEC (HL)
        JP NZ,FLOW_GAME_1718
        LD ($20BA),A
        LD A,$04
        LD ($2036),A

FLOW_GAME_1718:
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
        JP C,FLOW_GAME_17D6
        CP $59
        JP C,FLOW_GAME_1748
        CP $69
        JP C,FLOW_GAME_17D6
        CP $D1
        JP NC,FLOW_GAME_17D6

FLOW_GAME_1748:
        SUB $03
        LD D,A
        LD A,($2014)
        CP $03
        JP C,FLOW_GAME_17D6
        CP $FC
        JP NC,FLOW_GAME_17D6
        SUB $03
        LD E,A
        PUSH DE
        PUSH AF
        CALL SHIFT_VIDEO_ADDRESS_THREE
        EX DE,HL
        LD A,$07
        LD DE,$0000
        LD BC,$001F

FLOW_GAME_1769:
        PUSH AF
        LD A,(HL)
        OR D
        LD D,A
        LD A,L
        INC HL
        AND $1F
        LD A,B
        JP Z,FLOW_GAME_1776
        LD A,(HL)

FLOW_GAME_1776:
        OR E
        LD E,A
        ADD HL,BC
        POP AF
        DEC A
        JP NZ,FLOW_GAME_1769
        PUSH DE
        CALL CLAMP_GAME_STATE_TO_THREE
        POP HL
        POP AF
        AND $07
        INC A

FLOW_GAME_1787:
        ADD HL,HL
        DEC A
        JP NZ,FLOW_GAME_1787
        LD A,H
        AND $7F
        POP DE
        LD HL,$20B3
        JP Z,FLOW_GAME_17DC
        LD (HL),$00
        LD A,D
        CP $59
        JP C,FLOW_GAME_1802
        CP $B3
        JP C,FLOW_GAME_1815
        LD BC,$FFFF
        LD A,B

FLOW_GAME_17A7:
        ADD A,$40
        CP E
        INC BC
        JP C,FLOW_GAME_17A7
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
        LD DE,$0D03
        LD BC,$1002
        JP COPY_SCREEN_ROW_LOOP

FLOW_GAME_17D6:
        CALL CLAMP_GAME_STATE_TO_THREE
        LD HL,$20B3

FLOW_GAME_17DC:
        LD A,(HL)
        INC (HL)
        LD HL,$1AA0
        LD DE,$2F86
        AND A
        LD A,$07
        JP Z,FLOW_GAME_17EC
        LD A,$0D

FLOW_GAME_17EC:
        CALL DRAW_ENCODED_GRAPHIC
        CALL SERVICE_GAME_STATE_201E
        RRA
        LD HL,$1AAD
        LD A,$05
        JP C,FLOW_GAME_17FF
        LD HL,$1AB2
        INC A

FLOW_GAME_17FF:
        JP DRAW_ENCODED_GRAPHIC
; JP instruction above spans 9316.1f $17FF and desertgu.e $1800-$1801.

        ORG $1802
; ROM device desertgu.e, SHA1 202433dfb174901bd3b91e843d9d697a8333ef9e
FLOW_GAME_1802:
        LD HL,$2040
        CALL TEST_OBJECT_FLAG_BIT1
        JP C,FLOW_GAME_1825
        LD HL,$204F
        CALL TEST_OBJECT_FLAG_BIT1
        JP C,FLOW_GAME_1825
        RET

FLOW_GAME_1815:
        LD HL,$205E
        CALL TEST_OBJECT_FLAG_BIT1
        JP C,FLOW_GAME_1825
        LD HL,$206D
        CALL TEST_OBJECT_FLAG_BIT1
        RET NC

FLOW_GAME_1825:
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
        JP NC,FLOW_GAME_1848
        ADD A,$5C

FLOW_GAME_1848:
        CP $20
        LD A,(HL)
        JP C,FLOW_GAME_1854
        SUB $10
        LD D,A
        JP FLOW_GAME_1858

FLOW_GAME_1854:
        LD D,A
        ADD A,$10
        LD (HL),A

FLOW_GAME_1858:
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

FLOW_GAME_189F:
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
        JP NC,FLOW_GAME_18C0
        LD A,$03

FLOW_GAME_18C0:
        CP $FC
        JP C,FLOW_GAME_18C7
        LD A,$FC

FLOW_GAME_18C7:
        SUB $03
        LD L,A
        AND $07
        INC A
        LD C,A
        LD A,($2015)
        SUB $03
        JP NC,FLOW_GAME_18D8
        LD A,$03

FLOW_GAME_18D8:
        LD H,A
        LD ($20B4),HL
        EX DE,HL
        CALL SHIFT_VIDEO_ADDRESS_THREE
        LD A,$0A
        LD ($2039),A
        LD B,$80

FLOW_GAME_18E7:
        LD HL,$191C
        LD A,$06

FLOW_GAME_18EC:
        PUSH AF
        PUSH HL
        LD L,(HL)
        LD H,$00
        LD A,C

FLOW_GAME_18F2:
        ADD HL,HL
        DEC A
        JP NZ,FLOW_GAME_18F2
        EX DE,HL
        DEC B
        JP M,FLOW_GAME_1906
        LD A,E
        OR (HL)
        LD (HL),A
        INC HL
        LD A,D
        OR (HL)
        LD (HL),A
        JP FLOW_GAME_190F

FLOW_GAME_1906:
        LD A,E
        CPL
        AND (HL)
        LD (HL),A
        INC HL
        LD A,D
        CPL
        AND (HL)
        LD (HL),A

FLOW_GAME_190F:
        LD DE,$001F
        ADD HL,DE
        EX DE,HL
        POP HL
        INC HL
        POP AF
        DEC A
        JP NZ,FLOW_GAME_18EC
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

FLOW_GAME_1951:
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
        JP FLOW_GAME_1951

SPRITE_COPY_POINTER_PAIRS:
        DW $0C96
        DW $3B24
        DW $0CB3
        DW $3C8C
        DW $0CD5
        DW $3B54
        DW $0CF1
        DW $3C9C
        DW $0000

FLOW_GAME_1977:
        LD HL,$20B6
        LD A,(HL)
        AND A
        JP NZ,FLOW_GAME_19AF
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
        JP C,FLOW_GAME_19AF
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

FLOW_GAME_19AF:
        LD BC,$2009
        LD HL,$201C
        LD DE,$10F2
        CALL COMPARE_TWO_BYTE_RECORD
        JP C,FLOW_GAME_19CD
        LD HL,$2006
        LD DE,$110C
        CALL COMPARE_TWO_BYTE_RECORD
        JP C,FLOW_GAME_19CD
        LD DE,$1128

FLOW_GAME_19CD:
        EX DE,HL
        LD ($2012),HL
        LD HL,$2006
        CALL COMPARE_TWO_BYTE_RECORD
        JP C,FLOW_GAME_19E0
        LD HL,($2009)
        LD ($2006),HL

FLOW_GAME_19E0:
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
        DW $1AC3
        DW $1B1B
        DW $1B79
        DW $1BD9

MESSAGE_SCREEN_COORDINATE_POINTERS:
        DW $2808
        DW $3408
        DW $3EB4
        DW $2404
        DB $15,$24,$A6,$3E,$06,$24,$A7,$3E,$0B,$30,$0B,$30
        DB $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        DB $40,$40,$40,$40,$40,$40,$40,$44,$45

SCREEN_MESSAGE_TEXT:
        DB $53,$45,$52,$54,$40,$47,$55,$4E,$00,$40,$40
        DB $40,$40,$40,$32,$30,$30,$40,$42,$4F,$4E,$55,$53
        DB $40,$40,$40,$40,$40,$31,$30,$30,$40,$55,$47,$48
        DB $4A,$42,$55,$46,$4A,$41,$52,$47,$4A,$50,$4F,$57
        DB $4A,$5A,$4F,$57,$4A,$42,$4F,$50,$4A,$57,$41,$4D
        DB $4A,$42,$41,$4D,$4A,$4D,$49,$53,$53,$45,$44,$40
        DB $41,$47,$41,$49,$4E,$40,$44,$55,$4D,$4D,$59,$54
        DB $55,$52,$4B,$45,$59,$52,$45,$4C,$4F,$41,$44,$43
        DB $59,$43,$4C,$45,$84,$47,$41,$4D,$45,$84,$4F,$56
        DB $45,$52,$8B,$49,$4E,$53,$45,$52,$54,$40,$43,$4F
        DB $49,$4E,$84,$54,$49,$4D,$45,$85,$53,$43,$4F,$52
        DB $45,$8A,$48,$49,$47,$48,$40,$53,$43,$4F,$52,$45
        DB $89,$4C,$41,$53,$54,$40,$47,$41,$4D,$45,$8D,$45
        DB $58,$54,$45,$4E,$44,$45,$44,$40,$54,$49,$4D,$45
        DB $89,$47,$45,$54,$40,$52,$45,$41,$44,$59,$89,$40
        DB $40,$53,$48,$4F,$4F,$54,$40,$40,$84,$47,$41,$4D
        DB $45,$84,$4F,$56,$45,$52,$89,$45,$49,$4E,$57,$45
        DB $52,$46,$45,$4E,$84,$5A,$45,$49,$54,$86,$50,$55
        DB $4E,$4B,$54,$45,$86,$52,$45,$4B,$4F,$52,$44,$88
        DB $45,$4E,$44,$53,$50,$49,$45,$4C,$91,$5A,$45,$49
        DB $54,$56,$45,$52,$4C,$41,$45,$4E,$47,$45,$52,$55
        DB $4E,$47,$8D,$46,$45,$52,$54,$49,$47,$40,$4D,$41
        DB $43,$48,$45,$4E,$8D,$40,$40,$53,$43,$48,$49,$45
        DB $53,$53,$45,$4E,$40,$40,$83,$46,$49,$4E,$81,$40
        DB $8C,$4D,$45,$54,$54,$45,$5A,$40,$50,$49,$45,$43
        DB $45,$85,$54,$45,$4D,$50,$53,$85,$53,$43,$4F,$52
        DB $45,$8A,$48,$49,$47,$48,$40,$53,$43,$4F,$52,$45
        DB $8C,$44,$45,$52,$4E,$49,$45,$52,$40,$43,$4F,$55
        DB $50,$8C,$50,$52,$4F,$4C,$4F,$4E,$47,$41,$54,$49
        DB $4F,$4E,$8D,$50,$52,$45,$50,$41,$52,$45,$5A,$40
        DB $56,$4F,$55,$53,$8D,$40,$40,$40,$40,$53,$48,$4F
        DB $4F,$54,$40,$40,$40,$40,$84,$53,$50,$49,$4C,$84
        DB $53,$4C,$55,$54,$87,$49,$4E,$44,$4B,$41,$53,$54
        DB $83,$54,$49,$44,$85,$50,$4F,$49,$4E,$54,$89,$54
        DB $4F,$50,$40,$50,$4F,$49,$4E,$54,$8B,$53,$49,$44
        DB $53,$54,$45,$40,$53,$50,$49,$4C,$8A,$45,$4B,$53
        DB $54,$52,$41,$40,$54,$49,$44,$85,$50,$41,$52,$41
        DB $54,$85,$40,$53,$4B,$59,$44

FLOW_GAME_1C22:
        XOR A
        LD ($2031),A
        LD HL,($2019)
        LD ($2000),HL
        RET

FLOW_GAME_1C2D:
        LD HL,($2000)
        INC HL
        LD ($2000),HL
        RET

FLOW_GAME_1C35:
        LD A,$08
        OUT ($03),A
        LD DE,$2080
        LD A,(DE)
        AND $09
        LD (DE),A
        OUT ($07),A
        RET

FLOW_GAME_1C43:
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
        JP Z,FLOW_GAME_1C5E
        LD A,$0A
        LD ($2036),A
        RET

FLOW_GAME_1C5E:
        LD HL,$20BA
        LD A,(HL)
        INC (HL)
        DEC A
        JP NZ,FLOW_GAME_1C7C
        LD A,$03

FLOW_GAME_1C69:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND $BB
        LD (HL),A
        POP AF
        DEC A
        JP P,FLOW_GAME_1C69
        LD A,$04
        LD ($2036),A
        RET

FLOW_GAME_1C7C:
        DEC A
        JP NZ,FLOW_GAME_1C9B
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

FLOW_GAME_1C9B:
        LD (HL),$00
        LD HL,$1A4B
        LD DE,$2804
        LD A,$06
        CALL DRAW_GRAPHIC_MODE_B
        LD DE,$3406
        LD A,$05
        CALL DRAW_GRAPHIC_MODE_B
        LD A,$03

FLOW_GAME_1CB2:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        OR $44
        LD (HL),A
        POP AF
        DEC A
        JP P,FLOW_GAME_1CB2
        LD A,$06
        LD ($20B9),A
        XOR A
        LD ($2003),A
        RET

FLOW_GAME_1CC9:
        LD HL,$208D
        LD BC,$203C
        JP FLOW_GAME_1CEA

FLOW_GAME_1CD2:
        LD HL,$2095
        LD BC,$203D
        JP FLOW_GAME_1CEA

FLOW_GAME_1CDB:
        LD HL,$209D
        LD BC,$203E
        JP FLOW_GAME_1CEA

FLOW_GAME_1CE4:
        LD HL,$20A5
        LD BC,$203F

FLOW_GAME_1CEA:
        LD A,(HL)
        DEC (HL)
        DEC A
        JP NZ,FLOW_GAME_1CFD
        INC HL
        INC HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD HL,$1A4B
        LD A,$04
        JP DRAW_ENCODED_GRAPHIC

FLOW_GAME_1CFD:
        DEC A
        JP NZ,FLOW_GAME_1D0F
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

FLOW_GAME_1D0F:
        LD A,$14
        LD (BC),A
        INC HL
        LD A,(HL)
        AND A
        LD A,$88
        JP NZ,FLOW_GAME_1D1C
        LD A,$48

FLOW_GAME_1D1C:
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

FLOW_GAME_1D36:
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
        JP FLOW_GAME_18E7

FLOW_GAME_1D4B:
        LD HL,$20B8
        LD DE,$2080
        LD A,(HL)
        DEC (HL)
        DEC A
        JP NZ,FLOW_GAME_1D60
        XOR A

FLOW_GAME_1D58:
        LD ($203A),A
        LD A,(DE)
        AND $FE
        LD (DE),A
        RET

FLOW_GAME_1D60:
        DEC A
        JP NZ,FLOW_GAME_1D6E

FLOW_GAME_1D64:
        LD A,$03
        LD ($203A),A
        LD A,(DE)
        OR $01
        LD (DE),A
        RET

FLOW_GAME_1D6E:
        DEC A
        JP NZ,FLOW_GAME_1D64
        LD A,$02
        JP FLOW_GAME_1D58

FLOW_GAME_1D77:
        LD HL,$20B7
        LD A,(HL)
        INC (HL)
        AND A
        JP NZ,FLOW_GAME_1D8D
        LD A,$28
        OUT ($03),A
        LD A,$04
        LD ($2034),A
        LD ($2033),A
        RET

FLOW_GAME_1D8D:
        LD HL,$1922
        LD DE,$20AD
        LD A,$04

FLOW_GAME_1D95:
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
        JP Z,FLOW_GAME_1DBA
        CALL COPY_SCREEN_ROW_LOOP
        LD DE,$0D23
        LD B,$03
        CALL COPY_SCREEN_ROW_LOOP

FLOW_GAME_1DBA:
        POP HL
        POP DE
        POP AF
        DEC A
        JP NZ,FLOW_GAME_1D95
        LD HL,$20AD
        LD BC,$0504

FLOW_GAME_1DC7:
        LD A,(HL)
        INC HL
        AND A
        RET Z
        DEC C
        JP NZ,FLOW_GAME_1DC7

FLOW_GAME_1DCF:
        LD (HL),C
        DEC HL
        DEC B
        JP NZ,FLOW_GAME_1DCF
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

FLOW_GAME_1DEA:
        LD A,($20BA)
        AND A
        JP Z,FLOW_GAME_1DF7
        LD A,$0C
        LD ($203B),A
        RET

FLOW_GAME_1DF7:
        LD A,$03

FLOW_GAME_1DF9:
        PUSH AF
        CALL SELECT_GAME_RECORD
        LD A,(HL)
        AND A
        JP P,FLOW_GAME_1E0B
        AND $04
        JP NZ,FLOW_GAME_1E0B
        LD A,(HL)
        OR $04
        LD (HL),A

FLOW_GAME_1E0B:
        POP AF
        DEC A
        JP P,FLOW_GAME_1DF9
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
        JP Z,FLOW_GAME_1E46
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

FLOW_GAME_1E46:
        LD (HL),$00
        INC HL
        INC (HL)
        LD A,C
        RRA
        RET NC
        INC (HL)
        RET

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
        DB $4E
