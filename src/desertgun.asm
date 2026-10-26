; Original desertgun Intel 8080 ROM, source reconstructed from original bytes.
; Native instruction mnemonics are executable; uncertain regions retain DB.
; Original byte offsets are preserved; zmac v1.3 must rebuild exactly.

        ORG $0000
; Device 9316.1h, SHA1 4d0a3a59d4f8181c6e30966a6b1d19ba5b29c398
NATIVE_0000:
        NOP  ; ROM $0000: 00
        NOP  ; ROM $0001: 00
        LD SP,$2400  ; ROM $0002: 31 00 24
        JP $0018  ; ROM $0005: C3 18 00
NATIVE_0008:
        PUSH AF  ; ROM $0008: F5
        PUSH BC  ; ROM $0009: C5
        PUSH DE  ; ROM $000A: D5
        PUSH HL  ; ROM $000B: E5
        JP $0404  ; ROM $000C: C3 04 04
        DB $00 ; ROM $000F unclassified
NATIVE_0010:
        PUSH AF  ; ROM $0010: F5
        PUSH BC  ; ROM $0011: C5
        PUSH DE  ; ROM $0012: D5
        PUSH HL  ; ROM $0013: E5
        JP $0456  ; ROM $0014: C3 56 04
        DB $00 ; ROM $0017 unclassified
NATIVE_0018:
        IN A,($02)  ; ROM $0018: DB 02
        AND $30  ; ROM $001A: E6 30
        CP $30  ; ROM $001C: FE 30
        JP NZ,$11BA  ; ROM $001E: C2 BA 11
        DI  ; ROM $0021: F3
        LD B,$01  ; ROM $0022: 06 01
        LD DE,$0000  ; ROM $0024: 11 00 00
NATIVE_0027:
        LD HL,$2000  ; ROM $0027: 21 00 20
NATIVE_002A:
        OUT ($04),A  ; ROM $002A: D3 04
        LD (HL),B  ; ROM $002C: 70
        LD A,(HL)  ; ROM $002D: 7E
        XOR B  ; ROM $002E: A8
        JP Z,$0041  ; ROM $002F: CA 41 00
        LD C,A  ; ROM $0032: 4F
        LD A,L  ; ROM $0033: 7D
        AND $01  ; ROM $0034: E6 01
        LD A,C  ; ROM $0036: 79
        JP NZ,$003F  ; ROM $0037: C2 3F 00
        OR D  ; ROM $003A: B2
        LD D,A  ; ROM $003B: 57
        JP $0041  ; ROM $003C: C3 41 00
NATIVE_003F:
        OR E  ; ROM $003F: B3
        LD E,A  ; ROM $0040: 5F
NATIVE_0041:
        INC HL  ; ROM $0041: 23
        LD A,H  ; ROM $0042: 7C
        CP $40  ; ROM $0043: FE 40
        JP NZ,$002A  ; ROM $0045: C2 2A 00
NATIVE_0048:
        OUT ($04),A  ; ROM $0048: D3 04
        DEC HL  ; ROM $004A: 2B
        LD A,H  ; ROM $004B: 7C
        CP $1F  ; ROM $004C: FE 1F
        JP Z,$007E  ; ROM $004E: CA 7E 00
        LD A,(HL)  ; ROM $0051: 7E
        XOR B  ; ROM $0052: A8
        JP Z,$0065  ; ROM $0053: CA 65 00
        LD C,A  ; ROM $0056: 4F
        LD A,L  ; ROM $0057: 7D
        AND $01  ; ROM $0058: E6 01
        LD A,C  ; ROM $005A: 79
        JP NZ,$0063  ; ROM $005B: C2 63 00
        OR D  ; ROM $005E: B2
        LD D,A  ; ROM $005F: 57
        JP $0065  ; ROM $0060: C3 65 00
NATIVE_0063:
        OR E  ; ROM $0063: B3
        LD E,A  ; ROM $0064: 5F
NATIVE_0065:
        LD A,B  ; ROM $0065: 78
        CPL  ; ROM $0066: 2F
        LD (HL),A  ; ROM $0067: 77
        XOR (HL)  ; ROM $0068: AE
        JP Z,$0048  ; ROM $0069: CA 48 00
        LD C,A  ; ROM $006C: 4F
        LD A,L  ; ROM $006D: 7D
        AND $01  ; ROM $006E: E6 01
        LD A,C  ; ROM $0070: 79
        JP NZ,$0079  ; ROM $0071: C2 79 00
        OR D  ; ROM $0074: B2
        LD D,A  ; ROM $0075: 57
        JP $007B  ; ROM $0076: C3 7B 00
NATIVE_0079:
        OR E  ; ROM $0079: B3
        LD E,A  ; ROM $007A: 5F
NATIVE_007B:
        JP $0048  ; ROM $007B: C3 48 00
NATIVE_007E:
        OUT ($04),A  ; ROM $007E: D3 04
        INC HL  ; ROM $0080: 23
        LD A,H  ; ROM $0081: 7C
        CP $40  ; ROM $0082: FE 40
        JP Z,$00A1  ; ROM $0084: CA A1 00
        LD A,B  ; ROM $0087: 78
        CPL  ; ROM $0088: 2F
        XOR (HL)  ; ROM $0089: AE
        JP Z,$009C  ; ROM $008A: CA 9C 00
        LD C,A  ; ROM $008D: 4F
        LD A,L  ; ROM $008E: 7D
        AND $01  ; ROM $008F: E6 01
        LD A,C  ; ROM $0091: 79
        JP NZ,$009A  ; ROM $0092: C2 9A 00
        OR D  ; ROM $0095: B2
        LD D,A  ; ROM $0096: 57
        JP $009C  ; ROM $0097: C3 9C 00
NATIVE_009A:
        OR E  ; ROM $009A: B3
        LD E,A  ; ROM $009B: 5F
NATIVE_009C:
        XOR A  ; ROM $009C: AF
        LD (HL),A  ; ROM $009D: 77
        JP $007E  ; ROM $009E: C3 7E 00
NATIVE_00A1:
        IN A,($02)  ; ROM $00A1: DB 02
        AND $30  ; ROM $00A3: E6 30
        CP $30  ; ROM $00A5: FE 30
        JP NZ,$0000  ; ROM $00A7: C2 00 00
        LD A,B  ; ROM $00AA: 78
        RLCA  ; ROM $00AB: 07
        LD B,A  ; ROM $00AC: 47
        JP NC,$0027  ; ROM $00AD: D2 27 00
        LD A,D  ; ROM $00B0: 7A
        OR E  ; ROM $00B1: B3
        JP Z,$00D9  ; ROM $00B2: CA D9 00
        EX DE,HL  ; ROM $00B5: EB
        LD SP,HL  ; ROM $00B6: F9
        LD DE,$2000  ; ROM $00B7: 11 00 20
        LD B,$00  ; ROM $00BA: 06 00
NATIVE_00BC:
        LD HL,$0000  ; ROM $00BC: 21 00 00
        ADD HL,SP  ; ROM $00BF: 39
        LD C,$10  ; ROM $00C0: 0E 10
NATIVE_00C2:
        XOR A  ; ROM $00C2: AF
        ADD HL,HL  ; ROM $00C3: 29
        JP C,$00C8  ; ROM $00C4: DA C8 00
        CPL  ; ROM $00C7: 2F
NATIVE_00C8:
        LD (DE),A  ; ROM $00C8: 12
        INC DE  ; ROM $00C9: 13
        LD A,$18  ; ROM $00CA: 3E 18
        LD (DE),A  ; ROM $00CC: 12
        INC DE  ; ROM $00CD: 13
        DEC C  ; ROM $00CE: 0D
        JP NZ,$00C2  ; ROM $00CF: C2 C2 00
        DEC B  ; ROM $00D2: 05
        JP NZ,$00BC  ; ROM $00D3: C2 BC 00
        JP $011C  ; ROM $00D6: C3 1C 01
NATIVE_00D9:
        LD SP,$2400  ; ROM $00D9: 31 00 24
        LD HL,$280C  ; ROM $00DC: 21 0C 28
        PUSH HL  ; ROM $00DF: E5
        LD HL,$0000  ; ROM $00E0: 21 00 00
        LD DE,$0121  ; ROM $00E3: 11 21 01
NATIVE_00E6:
        LD BC,$0800  ; ROM $00E6: 01 00 08
        LD A,(DE)  ; ROM $00E9: 1A
        INC DE  ; ROM $00EA: 13
NATIVE_00EB:
        ADD A,(HL)  ; ROM $00EB: 86
        OUT ($04),A  ; ROM $00EC: D3 04
        INC HL  ; ROM $00EE: 23
        DEC C  ; ROM $00EF: 0D
        JP NZ,$00EB  ; ROM $00F0: C2 EB 00
        DEC B  ; ROM $00F3: 05
        JP NZ,$00EB  ; ROM $00F4: C2 EB 00
        INC A  ; ROM $00F7: 3C
        JP Z,$0105  ; ROM $00F8: CA 05 01
        EX (SP),HL  ; ROM $00FB: E3
        EX DE,HL  ; ROM $00FC: EB
        LD A,$01  ; ROM $00FD: 3E 01
        CALL $0132  ; ROM $00FF: CD 32 01
        EX DE,HL  ; ROM $0102: EB
        EX (SP),HL  ; ROM $0103: E3
        DEC DE  ; ROM $0104: 1B
NATIVE_0105:
        INC DE  ; ROM $0105: 13
        LD A,H  ; ROM $0106: 7C
        CP $20  ; ROM $0107: FE 20
        JP NZ,$00E6  ; ROM $0109: C2 E6 00
        POP HL  ; ROM $010C: E1
        LD A,L  ; ROM $010D: 7D
        CP $0C  ; ROM $010E: FE 0C
        JP NZ,$011C  ; ROM $0110: C2 1C 01
        IN A,($02)  ; ROM $0113: DB 02
        RLA  ; ROM $0115: 17
        JP C,$0000  ; ROM $0116: DA 00 00
        JP $01C7  ; ROM $0119: C3 C7 01
NATIVE_011C:
        OUT ($04),A  ; ROM $011C: D3 04
        JP $011C  ; ROM $011E: C3 1C 01
        DB $00,$48,$D0,$47,$35,$46,$97,$45,$72,$44,$C2,$43 ; ROM $0121 unclassified
        DB $3E,$42,$58,$41,$88 ; ROM $012D unclassified
NATIVE_0132:
        PUSH AF  ; ROM $0132: F5
NATIVE_0133:
        LD A,(HL)  ; ROM $0133: 7E
        INC HL  ; ROM $0134: 23
        SUB $30  ; ROM $0135: D6 30
        JP P,$014B  ; ROM $0137: F2 4B 01
        LD B,A  ; ROM $013A: 47
NATIVE_013B:
        INC DE  ; ROM $013B: 13
        LD A,E  ; ROM $013C: 7B
        AND $1F  ; ROM $013D: E6 1F
        JP NZ,$0144  ; ROM $013F: C2 44 01
        INC D  ; ROM $0142: 14
        INC D  ; ROM $0143: 14
NATIVE_0144:
        INC B  ; ROM $0144: 04
        JP NZ,$013B  ; ROM $0145: C2 3B 01
        JP $0133  ; ROM $0148: C3 33 01
NATIVE_014B:
        PUSH HL  ; ROM $014B: E5
        PUSH DE  ; ROM $014C: D5
        CALL $0273  ; ROM $014D: CD 73 02
        LD C,$20  ; ROM $0150: 0E 20
        LD A,$0A  ; ROM $0152: 3E 0A
NATIVE_0154:
        PUSH AF  ; ROM $0154: F5
        LD A,(DE)  ; ROM $0155: 1A
        INC DE  ; ROM $0156: 13
        LD (HL),A  ; ROM $0157: 77
        ADD HL,BC  ; ROM $0158: 09
        POP AF  ; ROM $0159: F1
        DEC A  ; ROM $015A: 3D
        JP NZ,$0154  ; ROM $015B: C2 54 01
        POP DE  ; ROM $015E: D1
        POP HL  ; ROM $015F: E1
        INC DE  ; ROM $0160: 13
        POP AF  ; ROM $0161: F1
        DEC A  ; ROM $0162: 3D
        JP NZ,$0132  ; ROM $0163: C2 32 01
        RET  ; ROM $0166: C9
NATIVE_0167:
        PUSH AF  ; ROM $0167: F5
        LD A,(HL)  ; ROM $0168: 7E
        SUB $30  ; ROM $0169: D6 30
        INC HL  ; ROM $016B: 23
        PUSH HL  ; ROM $016C: E5
        CALL $0273  ; ROM $016D: CD 73 02
        LD A,$0A  ; ROM $0170: 3E 0A
NATIVE_0172:
        PUSH AF  ; ROM $0172: F5
        LD BC,$0020  ; ROM $0173: 01 20 00
        LD A,(DE)  ; ROM $0176: 1A
        INC DE  ; ROM $0177: 13
        PUSH DE  ; ROM $0178: D5
        LD D,A  ; ROM $0179: 57
        LD E,$04  ; ROM $017A: 1E 04
NATIVE_017C:
        PUSH DE  ; ROM $017C: D5
        LD A,D  ; ROM $017D: 7A
        AND $03  ; ROM $017E: E6 03
        LD DE,$01C2  ; ROM $0180: 11 C2 01
NATIVE_0183:
        INC DE  ; ROM $0183: 13
        DEC A  ; ROM $0184: 3D
        JP P,$0183  ; ROM $0185: F2 83 01
        LD A,(DE)  ; ROM $0188: 1A
        PUSH HL  ; ROM $0189: E5
        LD (HL),A  ; ROM $018A: 77
        ADD HL,BC  ; ROM $018B: 09
        LD (HL),A  ; ROM $018C: 77
        ADD HL,BC  ; ROM $018D: 09
        LD (HL),A  ; ROM $018E: 77
        ADD HL,BC  ; ROM $018F: 09
        LD (HL),A  ; ROM $0190: 77
        POP HL  ; ROM $0191: E1
        INC HL  ; ROM $0192: 23
        POP DE  ; ROM $0193: D1
        LD A,D  ; ROM $0194: 7A
        RRCA  ; ROM $0195: 0F
        RRCA  ; ROM $0196: 0F
        LD D,A  ; ROM $0197: 57
        DEC E  ; ROM $0198: 1D
        JP NZ,$017C  ; ROM $0199: C2 7C 01
        LD C,$7C  ; ROM $019C: 0E 7C
        ADD HL,BC  ; ROM $019E: 09
        POP DE  ; ROM $019F: D1
        POP AF  ; ROM $01A0: F1
        DEC A  ; ROM $01A1: 3D
        JP NZ,$0172  ; ROM $01A2: C2 72 01
        LD BC,$FB04  ; ROM $01A5: 01 04 FB
        ADD HL,BC  ; ROM $01A8: 09
        EX DE,HL  ; ROM $01A9: EB
        POP HL  ; ROM $01AA: E1
        POP AF  ; ROM $01AB: F1
        DEC A  ; ROM $01AC: 3D
        JP NZ,$0167  ; ROM $01AD: C2 67 01
        RET  ; ROM $01B0: C9
NATIVE_01B1:
        LD B,$03  ; ROM $01B1: 06 03
NATIVE_01B3:
        XOR A  ; ROM $01B3: AF
        LD A,D  ; ROM $01B4: 7A
        RRA  ; ROM $01B5: 1F
        LD D,A  ; ROM $01B6: 57
        LD A,E  ; ROM $01B7: 7B
        RRA  ; ROM $01B8: 1F
        LD E,A  ; ROM $01B9: 5F
        DEC B  ; ROM $01BA: 05
        JP NZ,$01B3  ; ROM $01BB: C2 B3 01
        LD A,D  ; ROM $01BE: 7A
        ADD A,$24  ; ROM $01BF: C6 24
        LD D,A  ; ROM $01C1: 57
        RET  ; ROM $01C2: C9
        DB $00,$0F,$F0,$FF ; ROM $01C3 unclassified
NATIVE_01C7:
        LD HL,$01D0  ; ROM $01C7: 21 D0 01
        LD SP,$4000  ; ROM $01CA: 31 00 40
        JP $0FD7  ; ROM $01CD: C3 D7 0F
        DB $FB,$21,$00,$24,$CD,$5D,$02,$23,$7C,$FE,$3F,$C2 ; ROM $01D0 unclassified
        DB $E4,$01,$7D,$FE,$C0,$CA,$FA,$01,$D3,$04,$7D,$E6 ; ROM $01DC unclassified
        DB $1F,$36,$01,$CA,$D7,$01,$36,$80,$FE,$1F,$CA,$D7 ; ROM $01E8 unclassified
        DB $01,$36,$00,$C3,$D7,$01,$CD,$5D,$02,$21,$6F,$02 ; ROM $01F4 unclassified
        DB $11,$0F,$24,$3E,$01,$CD,$32,$01,$3C,$11,$00,$32 ; ROM $0200 unclassified
        DB $CD,$32,$01,$3C,$11,$1F,$32,$CD,$32,$01,$3C,$11 ; ROM $020C unclassified
        DB $AF,$3E,$CD,$32,$01,$21,$80,$01,$22,$EF,$31,$22 ; ROM $0218 unclassified
        DB $0F,$32,$CD,$34,$02,$DB,$02,$17,$D2,$C7,$01,$D3 ; ROM $0224 unclassified
        DB $04,$C3,$26,$02,$3A,$14,$20,$5F,$E6,$07,$C2,$3E ; ROM $0230 unclassified
        DB $02,$3C,$4F,$3A,$15,$20,$57,$CD,$B1,$01,$21,$67 ; ROM $023C unclassified
        DB $02,$09,$7E,$EB,$77,$0E,$20,$09,$77,$AF,$3D,$C2 ; ROM $0248 unclassified
        DB $52,$02,$11,$E0,$FF,$77,$19,$77,$C9,$11,$FF,$20 ; ROM $0254 unclassified
        DB $73,$23,$15,$C2,$60,$02,$2B,$C9,$03,$06,$0C,$18 ; ROM $0260 unclassified
        DB $30,$60,$C0,$50,$52,$53,$51 ; ROM $026C unclassified
NATIVE_0273:
        INC A  ; ROM $0273: 3C
        CP $0B  ; ROM $0274: FE 0B
        JP M,$027B  ; ROM $0276: FA 7B 02
        SUB $06  ; ROM $0279: D6 06
NATIVE_027B:
        LD HL,$027E  ; ROM $027B: 21 7E 02
        LD BC,$000A  ; ROM $027E: 01 0A 00
NATIVE_0281:
        ADD HL,BC  ; ROM $0281: 09
        DEC A  ; ROM $0282: 3D
        JP NZ,$0281  ; ROM $0283: C2 81 02
        EX DE,HL  ; ROM $0286: EB
        RET  ; ROM $0287: C9
        DB $3C,$7E,$66,$66,$66,$66,$66,$66,$7E,$3C,$18,$1C ; ROM $0288 unclassified
        DB $18,$18,$18,$18,$18,$18,$3C,$3C,$3C,$7E,$66,$60 ; ROM $0294 unclassified
        DB $7C,$3E,$06,$06,$7E,$7E,$3C,$7E,$66,$60,$38,$78 ; ROM $02A0 unclassified
        DB $60,$66,$7E,$3C,$66,$66,$66,$66,$7E,$7E,$60,$60 ; ROM $02AC unclassified
        DB $60,$60,$3E,$3E,$06,$06,$3E,$7E,$60,$66,$7E,$3C ; ROM $02B8 unclassified
        DB $3C,$3E,$06,$06,$3E,$7E,$66,$66,$7E,$3C,$7E,$7E ; ROM $02C4 unclassified
        DB $60,$70,$30,$38,$18,$1C,$0C,$0C,$3C,$7E,$66,$66 ; ROM $02D0 unclassified
        DB $3C,$7E,$66,$66,$7E,$3C,$3C,$7E,$66,$66,$7E,$7C ; ROM $02DC unclassified
        DB $60,$60,$7C,$3C,$00,$00,$00,$00,$00,$00,$00,$00 ; ROM $02E8 unclassified
        DB $00,$00,$18,$3C,$7E,$66,$66,$66,$7E,$7E,$66,$66 ; ROM $02F4 unclassified
        DB $3E,$7E,$66,$66,$3E,$7E,$66,$66,$7E,$3E,$3C,$7E ; ROM $0300 unclassified
        DB $66,$06,$06,$06,$06,$66,$7E,$3C,$3E,$7E,$66,$66 ; ROM $030C unclassified
        DB $66,$66,$66,$66,$7E,$3E,$7E,$7E,$06,$06,$3E,$3E ; ROM $0318 unclassified
        DB $06,$06,$7E,$7E,$7E,$7E,$06,$06,$3E,$3E,$06,$06 ; ROM $0324 unclassified
        DB $06,$06,$3C,$7E,$66,$06,$06,$76,$76,$66,$7E,$3C ; ROM $0330 unclassified
        DB $66,$66,$66,$66,$7E,$7E,$66,$66,$66,$66,$3C,$3C ; ROM $033C unclassified
        DB $18,$18,$18,$18,$18,$18,$3C,$3C,$18,$18,$18,$18 ; ROM $0348 unclassified
        DB $18,$18,$00,$00,$18,$18,$66,$66,$76,$3E,$1E,$1E ; ROM $0354 unclassified
        DB $3E,$76,$66,$66,$06,$06,$06,$06,$06,$06,$06,$06 ; ROM $0360 unclassified
        DB $7E,$7E,$C3,$C3,$E7,$E7,$FF,$FF,$DB,$C3,$C3,$C3 ; ROM $036C unclassified
        DB $66,$66,$6E,$6E,$7E,$7E,$76,$76,$66,$66,$3C,$7E ; ROM $0378 unclassified
        DB $66,$66,$66,$66,$66,$66,$7E,$3C,$3E,$7E,$66,$66 ; ROM $0384 unclassified
        DB $7E,$3E,$06,$06,$06,$06,$3C,$7E,$66,$66,$66,$66 ; ROM $0390 unclassified
        DB $66,$36,$76,$6C,$3E,$7E,$66,$66,$7E,$3E,$76,$66 ; ROM $039C unclassified
        DB $66,$66,$3C,$7E,$66,$06,$3E,$7C,$60,$66,$7E,$3C ; ROM $03A8 unclassified
        DB $7E,$7E,$18,$18,$18,$18,$18,$18,$18,$18,$66,$66 ; ROM $03B4 unclassified
        DB $66,$66,$66,$66,$66,$66,$7E,$3C,$66,$66,$66,$66 ; ROM $03C0 unclassified
        DB $66,$7E,$3C,$3C,$18,$18,$C3,$C3,$C3,$DB,$FF,$FF ; ROM $03CC unclassified
        DB $E7,$E7,$C3,$C3,$66,$66,$7E,$3C,$18,$18,$3C,$7E ; ROM $03D8 unclassified
        DB $66,$66,$66,$66,$7E,$3C,$18,$18,$18,$18,$18,$18 ; ROM $03E4 unclassified
        DB $7E,$7E,$60,$70,$38,$1C,$0E,$06,$7E,$7E,$08,$3E ; ROM $03F0 unclassified
        DB $3E,$3E,$3E,$3E,$3E,$3E,$7F,$7F ; ROM $03FC unclassified
NATIVE_0404:
        CALL $05F6  ; ROM $0404: CD F6 05
        CALL $063A  ; ROM $0407: CD 3A 06
        CALL $1E11  ; ROM $040A: CD 11 1E
        CALL $0486  ; ROM $040D: CD 86 04
        EI  ; ROM $0410: FB
        LD HL,$2004  ; ROM $0411: 21 04 20
        INC (HL)  ; ROM $0414: 34
        LD A,(HL)  ; ROM $0415: 7E
        RRA  ; ROM $0416: 1F
        JP NC,$0481  ; ROM $0417: D2 81 04
        RRA  ; ROM $041A: 1F
        LD HL,$2040  ; ROM $041B: 21 40 20
        JP C,$0424  ; ROM $041E: DA 24 04
        LD HL,$204F  ; ROM $0421: 21 4F 20
NATIVE_0424:
        LD A,(HL)  ; ROM $0424: 7E
        AND A  ; ROM $0425: A7
        JP P,$0481  ; ROM $0426: F2 81 04
        PUSH HL  ; ROM $0429: E5
        CALL $0449  ; ROM $042A: CD 49 04
        POP HL  ; ROM $042D: E1
        LD A,(HL)  ; ROM $042E: 7E
        AND A  ; ROM $042F: A7
        JP P,$0481  ; ROM $0430: F2 81 04
        LD A,($2004)  ; ROM $0433: 3A 04 20
        AND $02  ; ROM $0436: E6 02
        LD HL,$205E  ; ROM $0438: 21 5E 20
        JP NZ,$0441  ; ROM $043B: C2 41 04
        LD HL,$206D  ; ROM $043E: 21 6D 20
NATIVE_0441:
        LD A,(HL)  ; ROM $0441: 7E
        AND A  ; ROM $0442: A7
        CALL M,$0449  ; ROM $0443: FC 49 04
        JP $0481  ; ROM $0446: C3 81 04
NATIVE_0449:
        PUSH HL  ; ROM $0449: E5
        PUSH HL  ; ROM $044A: E5
        CALL $05C8  ; ROM $044B: CD C8 05
        POP HL  ; ROM $044E: E1
        CALL $0547  ; ROM $044F: CD 47 05
        POP HL  ; ROM $0452: E1
        JP $065A  ; ROM $0453: C3 5A 06
NATIVE_0456:
        CALL $06B1  ; ROM $0456: CD B1 06
        EI  ; ROM $0459: FB
        LD A,($2004)  ; ROM $045A: 3A 04 20
        RRA  ; ROM $045D: 1F
        JP NC,$0481  ; ROM $045E: D2 81 04
        LD B,A  ; ROM $0461: 47
        RRA  ; ROM $0462: 1F
        LD HL,$2040  ; ROM $0463: 21 40 20
        JP C,$046C  ; ROM $0466: DA 6C 04
        LD HL,$204F  ; ROM $0469: 21 4F 20
NATIVE_046C:
        LD A,(HL)  ; ROM $046C: 7E
        AND A  ; ROM $046D: A7
        JP M,$0481  ; ROM $046E: FA 81 04
        LD A,B  ; ROM $0471: 78
        RRA  ; ROM $0472: 1F
        LD HL,$205E  ; ROM $0473: 21 5E 20
        JP C,$047C  ; ROM $0476: DA 7C 04
        LD HL,$206D  ; ROM $0479: 21 6D 20
NATIVE_047C:
        LD A,(HL)  ; ROM $047C: 7E
        AND A  ; ROM $047D: A7
        CALL M,$0449  ; ROM $047E: FC 49 04
NATIVE_0481:
        POP HL  ; ROM $0481: E1
        POP DE  ; ROM $0482: D1
        POP BC  ; ROM $0483: C1
        POP AF  ; ROM $0484: F1
        RET  ; ROM $0485: C9
NATIVE_0486:
        LD A,($201F)  ; ROM $0486: 3A 1F 20
        AND A  ; ROM $0489: A7
        RET Z  ; ROM $048A: C8
        LD HL,$200F  ; ROM $048B: 21 0F 20
        LD A,(HL)  ; ROM $048E: 7E
        AND A  ; ROM $048F: A7
        JP Z,$0495  ; ROM $0490: CA 95 04
        DEC (HL)  ; ROM $0493: 35
        RET  ; ROM $0494: C9
NATIVE_0495:
        INC HL  ; ROM $0495: 23
        LD A,(HL)  ; ROM $0496: 7E
        AND A  ; ROM $0497: A7
        JP Z,$04A2  ; ROM $0498: CA A2 04
        DEC (HL)  ; ROM $049B: 35
        DEC HL  ; ROM $049C: 2B
        LD A,($200E)  ; ROM $049D: 3A 0E 20
        LD (HL),A  ; ROM $04A0: 77
        RET  ; ROM $04A1: C9
NATIVE_04A2:
        INC HL  ; ROM $04A2: 23
        LD A,(HL)  ; ROM $04A3: 7E
        AND A  ; ROM $04A4: A7
        JP Z,$04AD  ; ROM $04A5: CA AD 04
        DEC (HL)  ; ROM $04A8: 35
        XOR A  ; ROM $04A9: AF
        OUT ($05),A  ; ROM $04AA: D3 05
        RET  ; ROM $04AC: C9
NATIVE_04AD:
        LD HL,($2012)  ; ROM $04AD: 2A 12 20
        LD A,(HL)  ; ROM $04B0: 7E
        AND A  ; ROM $04B1: A7
        JP NZ,$04C3  ; ROM $04B2: C2 C3 04
        XOR A  ; ROM $04B5: AF
        OUT ($05),A  ; ROM $04B6: D3 05
        LD ($201F),A  ; ROM $04B8: 32 1F 20
        LD A,($200D)  ; ROM $04BB: 3A 0D 20
        AND A  ; ROM $04BE: A7
        RET NZ  ; ROM $04BF: C0
        OUT ($03),A  ; ROM $04C0: D3 03
        RET  ; ROM $04C2: C9
NATIVE_04C3:
        JP P,$04CD  ; ROM $04C3: F2 CD 04
        AND $7F  ; ROM $04C6: E6 7F
        LD ($200E),A  ; ROM $04C8: 32 0E 20
        INC HL  ; ROM $04CB: 23
        LD A,(HL)  ; ROM $04CC: 7E
NATIVE_04CD:
        LD ($2010),A  ; ROM $04CD: 32 10 20
        INC HL  ; ROM $04D0: 23
        LD A,($200E)  ; ROM $04D1: 3A 0E 20
        LD B,A  ; ROM $04D4: 47
        LD A,(HL)  ; ROM $04D5: 7E
        AND A  ; ROM $04D6: A7
        JP M,$04E0  ; ROM $04D7: FA E0 04
        LD A,$01  ; ROM $04DA: 3E 01
        LD ($2011),A  ; ROM $04DC: 32 11 20
        DEC B  ; ROM $04DF: 05
NATIVE_04E0:
        LD A,B  ; ROM $04E0: 78
        LD ($200F),A  ; ROM $04E1: 32 0F 20
        LD A,(HL)  ; ROM $04E4: 7E
        INC HL  ; ROM $04E5: 23
        LD ($2012),HL  ; ROM $04E6: 22 12 20
        AND $7F  ; ROM $04E9: E6 7F
        LD C,A  ; ROM $04EB: 4F
        LD B,$00  ; ROM $04EC: 06 00
        LD HL,$04FB  ; ROM $04EE: 21 FB 04
        ADD HL,BC  ; ROM $04F1: 09
        ADD HL,BC  ; ROM $04F2: 09
        LD A,(HL)  ; ROM $04F3: 7E
        OUT ($05),A  ; ROM $04F4: D3 05
        INC HL  ; ROM $04F6: 23
        LD A,(HL)  ; ROM $04F7: 7E
        OUT ($06),A  ; ROM $04F8: D3 06
        RET  ; ROM $04FA: C9
        DB $00,$00,$3F,$13,$1D,$16,$33,$18,$3F,$1A,$05,$1D ; ROM $04FB unclassified
        DB $01,$1F,$39,$20,$27,$22,$11,$24,$35,$25,$13,$27 ; ROM $0507 unclassified
        DB $2B,$28,$3F,$29,$0F,$2B,$19,$2C,$1F,$2D,$21,$2E ; ROM $0513 unclassified
        DB $21,$2F,$1D,$30,$15,$31,$09,$32,$3B,$32,$29,$33 ; ROM $051F unclassified
        DB $17,$34,$3F,$34,$27,$35,$0D,$36,$31,$36,$11,$37 ; ROM $052B unclassified
        DB $31,$37,$0F,$38,$2B,$38,$05,$39,$1D,$39,$35,$39 ; ROM $0537 unclassified
        DB $0B,$3A,$21,$3A ; ROM $0543 unclassified
NATIVE_0547:
        LD A,(HL)  ; ROM $0547: 7E
        AND $40  ; ROM $0548: E6 40
        RET Z  ; ROM $054A: C8
        PUSH HL  ; ROM $054B: E5
        LD A,(HL)  ; ROM $054C: 7E
        OR $20  ; ROM $054D: F6 20
        LD (HL),A  ; ROM $054F: 77
        AND $10  ; ROM $0550: E6 10
        LD C,A  ; ROM $0552: 4F
        INC HL  ; ROM $0553: 23
        INC HL  ; ROM $0554: 23
        INC HL  ; ROM $0555: 23
        LD E,(HL)  ; ROM $0556: 5E
        INC HL  ; ROM $0557: 23
        INC HL  ; ROM $0558: 23
        INC HL  ; ROM $0559: 23
        INC HL  ; ROM $055A: 23
        LD D,(HL)  ; ROM $055B: 56
        INC HL  ; ROM $055C: 23
        INC HL  ; ROM $055D: 23
        LD A,E  ; ROM $055E: 7B
        AND $07  ; ROM $055F: E6 07
        DEC C  ; ROM $0561: 0D
        JP M,$0566  ; ROM $0562: FA 66 05
        CPL  ; ROM $0565: 2F
NATIVE_0566:
        OUT ($01),A  ; ROM $0566: D3 01
        CALL $01B1  ; ROM $0568: CD B1 01
        LD C,(HL)  ; ROM $056B: 4E
        INC HL  ; ROM $056C: 23
        LD B,(HL)  ; ROM $056D: 46
        INC HL  ; ROM $056E: 23
        PUSH DE  ; ROM $056F: D5
        LD (HL),E  ; ROM $0570: 73
        INC HL  ; ROM $0571: 23
        LD (HL),D  ; ROM $0572: 72
        INC HL  ; ROM $0573: 23
        LD A,(BC)  ; ROM $0574: 0A
        INC BC  ; ROM $0575: 03
        LD E,A  ; ROM $0576: 5F
        INC A  ; ROM $0577: 3C
        LD (HL),A  ; ROM $0578: 77
        INC HL  ; ROM $0579: 23
        LD A,(BC)  ; ROM $057A: 0A
        INC BC  ; ROM $057B: 03
        LD D,A  ; ROM $057C: 57
        LD (HL),A  ; ROM $057D: 77
        POP HL  ; ROM $057E: E1
        EX (SP),HL  ; ROM $057F: E3
        LD A,(HL)  ; ROM $0580: 7E
        POP HL  ; ROM $0581: E1
        AND $10  ; ROM $0582: E6 10
        JP NZ,$05A6  ; ROM $0584: C2 A6 05
NATIVE_0587:
        PUSH DE  ; ROM $0587: D5
        PUSH HL  ; ROM $0588: E5
NATIVE_0589:
        LD A,(BC)  ; ROM $0589: 0A
        INC BC  ; ROM $058A: 03
        OUT ($02),A  ; ROM $058B: D3 02
        IN A,($03)  ; ROM $058D: DB 03
        LD (HL),A  ; ROM $058F: 77
        INC HL  ; ROM $0590: 23
        DEC E  ; ROM $0591: 1D
        JP NZ,$0589  ; ROM $0592: C2 89 05
        XOR A  ; ROM $0595: AF
        OUT ($02),A  ; ROM $0596: D3 02
        IN A,($03)  ; ROM $0598: DB 03
        LD (HL),A  ; ROM $059A: 77
        POP HL  ; ROM $059B: E1
        LD DE,$0020  ; ROM $059C: 11 20 00
        ADD HL,DE  ; ROM $059F: 19
        POP DE  ; ROM $05A0: D1
        DEC D  ; ROM $05A1: 15
        JP NZ,$0587  ; ROM $05A2: C2 87 05
        RET  ; ROM $05A5: C9
NATIVE_05A6:
        LD A,E  ; ROM $05A6: 7B
        ADD A,L  ; ROM $05A7: 85
        LD L,A  ; ROM $05A8: 6F
NATIVE_05A9:
        PUSH DE  ; ROM $05A9: D5
        PUSH HL  ; ROM $05AA: E5
NATIVE_05AB:
        LD A,(BC)  ; ROM $05AB: 0A
        INC BC  ; ROM $05AC: 03
        OUT ($02),A  ; ROM $05AD: D3 02
        IN A,($00)  ; ROM $05AF: DB 00
        LD (HL),A  ; ROM $05B1: 77
        DEC HL  ; ROM $05B2: 2B
        DEC E  ; ROM $05B3: 1D
        JP NZ,$05AB  ; ROM $05B4: C2 AB 05
        XOR A  ; ROM $05B7: AF
        OUT ($02),A  ; ROM $05B8: D3 02
        IN A,($00)  ; ROM $05BA: DB 00
        LD (HL),A  ; ROM $05BC: 77
        POP HL  ; ROM $05BD: E1
        LD DE,$0020  ; ROM $05BE: 11 20 00
        ADD HL,DE  ; ROM $05C1: 19
        POP DE  ; ROM $05C2: D1
        DEC D  ; ROM $05C3: 15
        JP NZ,$05A9  ; ROM $05C4: C2 A9 05
        RET  ; ROM $05C7: C9
NATIVE_05C8:
        LD A,(HL)  ; ROM $05C8: 7E
        AND $20  ; ROM $05C9: E6 20
        RET Z  ; ROM $05CB: C8
        LD A,(HL)  ; ROM $05CC: 7E
        AND $DF  ; ROM $05CD: E6 DF
        LD (HL),A  ; ROM $05CF: 77
        AND $08  ; ROM $05D0: E6 08
        JP NZ,$05D6  ; ROM $05D2: C2 D6 05
        LD (HL),A  ; ROM $05D5: 77
NATIVE_05D6:
        LD DE,$000B  ; ROM $05D6: 11 0B 00
        ADD HL,DE  ; ROM $05D9: 19
        LD E,(HL)  ; ROM $05DA: 5E
        INC HL  ; ROM $05DB: 23
        LD D,(HL)  ; ROM $05DC: 56
        INC HL  ; ROM $05DD: 23
        LD C,(HL)  ; ROM $05DE: 4E
        INC HL  ; ROM $05DF: 23
        LD B,(HL)  ; ROM $05E0: 46
        EX DE,HL  ; ROM $05E1: EB
        LD DE,$0020  ; ROM $05E2: 11 20 00
        XOR A  ; ROM $05E5: AF
NATIVE_05E6:
        PUSH BC  ; ROM $05E6: C5
        PUSH HL  ; ROM $05E7: E5
NATIVE_05E8:
        LD (HL),A  ; ROM $05E8: 77
        INC HL  ; ROM $05E9: 23
        DEC C  ; ROM $05EA: 0D
        JP NZ,$05E8  ; ROM $05EB: C2 E8 05
        POP HL  ; ROM $05EE: E1
        ADD HL,DE  ; ROM $05EF: 19
        POP BC  ; ROM $05F0: C1
        DEC B  ; ROM $05F1: 05
        JP NZ,$05E6  ; ROM $05F2: C2 E6 05
        RET  ; ROM $05F5: C9
NATIVE_05F6:
        LD A,($207C)  ; ROM $05F6: 3A 7C 20
        AND A  ; ROM $05F9: A7
        RET NZ  ; ROM $05FA: C0
        LD B,A  ; ROM $05FB: 47
        LD HL,$2002  ; ROM $05FC: 21 02 20
        DEC (HL)  ; ROM $05FF: 35
        RET NZ  ; ROM $0600: C0
        LD (HL),$3C  ; ROM $0601: 36 3C
        LD A,($2003)  ; ROM $0603: 3A 03 20
        AND A  ; ROM $0606: A7
        JP NZ,$061B  ; ROM $0607: C2 1B 06
        LD HL,$2008  ; ROM $060A: 21 08 20
        LD A,(HL)  ; ROM $060D: 7E
        AND A  ; ROM $060E: A7
        JP Z,$061B  ; ROM $060F: CA 1B 06
        ADD A,$99  ; ROM $0612: C6 99
        DAA  ; ROM $0614: 27
        LD (HL),A  ; ROM $0615: 77
        JP NZ,$061B  ; ROM $0616: C2 1B 06
        LD B,$01  ; ROM $0619: 06 01
NATIVE_061B:
        LD C,$01  ; ROM $061B: 0E 01
        LD HL,$2030  ; ROM $061D: 21 30 20
        CALL $0627  ; ROM $0620: CD 27 06
        LD ($207C),A  ; ROM $0623: 32 7C 20
        RET  ; ROM $0626: C9
NATIVE_0627:
        LD A,(HL)  ; ROM $0627: 7E
        AND A  ; ROM $0628: A7
        JP Z,$0631  ; ROM $0629: CA 31 06
        DEC (HL)  ; ROM $062C: 35
        JP NZ,$0631  ; ROM $062D: C2 31 06
        SCF  ; ROM $0630: 37
NATIVE_0631:
        LD A,B  ; ROM $0631: 78
        RLA  ; ROM $0632: 17
        LD B,A  ; ROM $0633: 47
        INC HL  ; ROM $0634: 23
        DEC C  ; ROM $0635: 0D
        JP NZ,$0627  ; ROM $0636: C2 27 06
        RET  ; ROM $0639: C9
NATIVE_063A:
        LD HL,$2031  ; ROM $063A: 21 31 20
        LD A,($207D)  ; ROM $063D: 3A 7D 20
        AND A  ; ROM $0640: A7
        RET NZ  ; ROM $0641: C0
        LD B,A  ; ROM $0642: 47
        LD C,$08  ; ROM $0643: 0E 08
        CALL $0627  ; ROM $0645: CD 27 06
        LD ($207D),A  ; ROM $0648: 32 7D 20
        LD A,($207E)  ; ROM $064B: 3A 7E 20
        AND A  ; ROM $064E: A7
        RET NZ  ; ROM $064F: C0
        LD B,A  ; ROM $0650: 47
        LD C,$07  ; ROM $0651: 0E 07
        CALL $0627  ; ROM $0653: CD 27 06
        LD ($207E),A  ; ROM $0656: 32 7E 20
        RET  ; ROM $0659: C9
NATIVE_065A:
        LD A,(HL)  ; ROM $065A: 7E
        AND $04  ; ROM $065B: E6 04
        RET Z  ; ROM $065D: C8
        PUSH HL  ; ROM $065E: E5
        INC HL  ; ROM $065F: 23
        LD C,(HL)  ; ROM $0660: 4E
        LD B,$00  ; ROM $0661: 06 00
        INC HL  ; ROM $0663: 23
        LD A,(HL)  ; ROM $0664: 7E
        LD D,A  ; ROM $0665: 57
        INC HL  ; ROM $0666: 23
        ADD A,(HL)  ; ROM $0667: 86
        LD (HL),A  ; ROM $0668: 77
        DEC D  ; ROM $0669: 15
        JP P,$0675  ; ROM $066A: F2 75 06
        CP $F0  ; ROM $066D: FE F0
        JP NC,$067F  ; ROM $066F: D2 7F 06
        JP $0685  ; ROM $0672: C3 85 06
NATIVE_0675:
        PUSH HL  ; ROM $0675: E5
        LD HL,$06DC  ; ROM $0676: 21 DC 06
        ADD HL,BC  ; ROM $0679: 09
        CP (HL)  ; ROM $067A: BE
        POP HL  ; ROM $067B: E1
        JP C,$0685  ; ROM $067C: DA 85 06
NATIVE_067F:
        EX (SP),HL  ; ROM $067F: E3
        LD A,(HL)  ; ROM $0680: 7E
        AND $F7  ; ROM $0681: E6 F7
        LD (HL),A  ; ROM $0683: 77
        EX (SP),HL  ; ROM $0684: E3
NATIVE_0685:
        INC HL  ; ROM $0685: 23
        LD D,(HL)  ; ROM $0686: 56
        INC HL  ; ROM $0687: 23
        LD E,(HL)  ; ROM $0688: 5E
        INC HL  ; ROM $0689: 23
        LD A,(HL)  ; ROM $068A: 7E
        INC HL  ; ROM $068B: 23
        LD B,(HL)  ; ROM $068C: 46
        ADD A,(HL)  ; ROM $068D: 86
        LD (HL),A  ; ROM $068E: 77
        CP D  ; ROM $068F: BA
        JP C,$0697  ; ROM $0690: DA 97 06
        CP E  ; ROM $0693: BB
        JP C,$06A6  ; ROM $0694: DA A6 06
NATIVE_0697:
        LD (HL),B  ; ROM $0697: 70
        EX (SP),HL  ; ROM $0698: E3
        LD A,(HL)  ; ROM $0699: 7E
        AND $02  ; ROM $069A: E6 02
        EX (SP),HL  ; ROM $069C: E3
        JP NZ,$06AA  ; ROM $069D: C2 AA 06
        DEC HL  ; ROM $06A0: 2B
        LD A,(HL)  ; ROM $06A1: 7E
        CPL  ; ROM $06A2: 2F
        INC A  ; ROM $06A3: 3C
        LD (HL),A  ; ROM $06A4: 77
        INC HL  ; ROM $06A5: 23
NATIVE_06A6:
        INC HL  ; ROM $06A6: 23
        INC (HL)  ; ROM $06A7: 34
        POP HL  ; ROM $06A8: E1
        RET  ; ROM $06A9: C9
NATIVE_06AA:
        DEC HL  ; ROM $06AA: 2B
        LD (HL),$00  ; ROM $06AB: 36 00
        INC HL  ; ROM $06AD: 23
        JP $06A6  ; ROM $06AE: C3 A6 06
NATIVE_06B1:
        LD HL,$207F  ; ROM $06B1: 21 7F 20
        INC (HL)  ; ROM $06B4: 34
        LD A,(HL)  ; ROM $06B5: 7E
        LD DE,$2014  ; ROM $06B6: 11 14 20
        LD BC,$007F  ; ROM $06B9: 01 7F 00
        RRA  ; ROM $06BC: 1F
        JP C,$06C4  ; ROM $06BD: DA C4 06
        LD BC,$086F  ; ROM $06C0: 01 6F 08
        INC DE  ; ROM $06C3: 13
NATIVE_06C4:
        IN A,($01)  ; ROM $06C4: DB 01
        SUB $10  ; ROM $06C6: D6 10
        JP NC,$06CC  ; ROM $06C8: D2 CC 06
        XOR A  ; ROM $06CB: AF
NATIVE_06CC:
        CP C  ; ROM $06CC: B9
        JP C,$06D1  ; ROM $06CD: DA D1 06
        LD A,C  ; ROM $06D0: 79
NATIVE_06D1:
        RLA  ; ROM $06D1: 17
        LD (DE),A  ; ROM $06D2: 12
        INC HL  ; ROM $06D3: 23
        LD A,(HL)  ; ROM $06D4: 7E
        AND $F7  ; ROM $06D5: E6 F7
        OR B  ; ROM $06D7: B0
        LD (HL),A  ; ROM $06D8: 77
        OUT ($07),A  ; ROM $06D9: D3 07
        RET  ; ROM $06DB: C9
        DB $F0,$E8,$E8,$E0,$E0,$E8,$E8,$F0,$02,$16,$01,$04 ; ROM $06DC unclassified
        DB $08,$1E,$3C,$0F,$F8,$4F,$FC,$07,$FE,$07,$7F,$0F ; ROM $06E8 unclassified
        DB $FE,$3F,$FC,$7F,$F0,$3F,$F9,$39,$F8,$7F,$D0,$3F ; ROM $06F4 unclassified
        DB $FC,$0F,$FC,$47,$FE,$07,$FF,$0D,$E4,$1F,$C2,$3F ; ROM $0700 unclassified
        DB $C9,$77,$80,$03,$80,$21,$01,$0F,$20,$20,$10,$10 ; ROM $070C unclassified
        DB $09,$09,$0D,$0F,$0F,$1E,$16,$1C,$08,$08,$08,$03 ; ROM $0718 unclassified
        DB $0C,$00,$1C,$00,$00,$2A,$00,$00,$1C,$00,$E0,$FF ; ROM $0724 unclassified
        DB $03,$10,$7F,$04,$08,$7F,$08,$04,$6B,$10,$04,$3E ; ROM $0730 unclassified
        DB $10,$04,$1C,$10,$04,$08,$10,$04,$08,$10,$00,$08 ; ROM $073C unclassified
        DB $00,$03,$0C,$00,$1C,$00,$00,$2A,$00,$7F,$1C,$7F ; ROM $0748 unclassified
        DB $C0,$FF,$01,$00,$7F,$00,$00,$7F,$00,$00,$6B,$00 ; ROM $0754 unclassified
        DB $00,$3E,$00,$00,$1C,$00,$00,$08,$00,$00,$08,$00 ; ROM $0760 unclassified
        DB $00,$08,$00,$03,$0C,$3F,$1C,$7E,$60,$2A,$03,$C0 ; ROM $076C unclassified
        DB $9C,$01,$80,$FF,$00,$00,$7F,$00,$00,$7F,$00,$00 ; ROM $0778 unclassified
        DB $6B,$00,$00,$3E,$00,$00,$1C,$00,$00,$08,$00,$00 ; ROM $0784 unclassified
        DB $08,$00,$00,$08,$00,$04,$16,$00,$00,$00,$61,$00 ; ROM $0790 unclassified
        DB $00,$00,$63,$00,$00,$00,$63,$00,$00,$00,$63,$00 ; ROM $079C unclassified
        DB $00,$00,$22,$00,$00,$00,$7F,$00,$00,$80,$FF,$00 ; ROM $07A8 unclassified
        DB $00,$80,$EB,$00,$00,$80,$EB,$00,$00,$00,$7F,$00 ; ROM $07B4 unclassified
        DB $F0,$80,$3E,$00,$F8,$C3,$1D,$01,$FC,$FF,$09,$0E ; ROM $07C0 unclassified
        DB $FF,$FF,$08,$F8,$F3,$FF,$00,$E0,$70,$FE,$00,$00 ; ROM $07CC unclassified
        DB $38,$F0,$07,$00,$4C,$60,$04,$00,$44,$30,$04,$00 ; ROM $07D8 unclassified
        DB $C4,$18,$04,$00,$84,$08,$00,$00,$04,$04,$00,$04 ; ROM $07E4 unclassified
        DB $16,$00,$00,$00,$61,$00,$00,$00,$63,$00,$00,$00 ; ROM $07F0 unclassified
        DB $63,$00,$00,$00 ; ROM $07FC unclassified

        ORG $0800
; Device 9316.1g, SHA1 8fb8e85844a8ec6c0722883013ecdd4eeaeb08c1
        DB $63,$00,$00,$00,$22,$00,$00,$00,$7F,$00,$00,$80 ; ROM $0800 unclassified
        DB $FF,$00,$00,$80,$FF,$00,$00,$80,$EB,$00,$00,$00 ; ROM $080C unclassified
        DB $7F,$00,$F0,$80,$3E,$00,$F8,$C3,$1D,$01,$FC,$FF ; ROM $0818 unclassified
        DB $09,$0E,$FF,$FF,$08,$F8,$F3,$FF,$00,$E0,$F0,$FC ; ROM $0824 unclassified
        DB $00,$00,$70,$F0,$00,$00,$30,$60,$00,$00,$10,$20 ; ROM $0830 unclassified
        DB $00,$00,$10,$20,$00,$00,$10,$20,$00,$00,$10,$10 ; ROM $083C unclassified
        DB $00,$04,$16,$00,$00,$00,$61,$00,$00,$00,$63,$00 ; ROM $0848 unclassified
        DB $00,$00,$63,$00,$00,$00,$63,$00,$00,$00,$22,$00 ; ROM $0854 unclassified
        DB $00,$00,$7F,$00,$00,$80,$FF,$00,$00,$80,$EB,$00 ; ROM $0860 unclassified
        DB $00,$80,$EB,$00,$00,$00,$7F,$00,$F0,$80,$3E,$00 ; ROM $086C unclassified
        DB $F8,$C3,$1D,$01,$FC,$FF,$09,$0E,$FF,$FF,$08,$F8 ; ROM $0878 unclassified
        DB $F3,$FF,$00,$E0,$70,$FE,$00,$00,$F0,$F0,$00,$00 ; ROM $0884 unclassified
        DB $E8,$C1,$01,$00,$8C,$23,$03,$00,$04,$12,$04,$00 ; ROM $0890 unclassified
        DB $04,$0A,$02,$00,$00,$01,$01,$04,$0B,$00,$00,$F8 ; ROM $089C unclassified
        DB $F8,$00,$00,$88,$88,$00,$00,$C8,$9F,$00,$C0,$E1 ; ROM $08A8 unclassified
        DB $3F,$C0,$41,$63,$32,$00,$07,$66,$32,$0C,$06,$CE ; ROM $08B4 unclassified
        DB $1F,$04,$0E,$BF,$0F,$0C,$CE,$7F,$07,$38,$FF,$3F ; ROM $08C0 unclassified
        DB $02,$F0,$FF,$1F,$02,$03,$16,$00,$80,$00,$00,$00 ; ROM $08CC unclassified
        DB $01,$00,$00,$02,$00,$00,$0C,$00,$00,$F6,$00,$00 ; ROM $08D8 unclassified
        DB $7E,$00,$00,$07,$00,$00,$03,$F0,$8F,$03,$F8,$FF ; ROM $08E4 unclassified
        DB $01,$FD,$FF,$01,$FE,$FF,$00,$FE,$FF,$00,$FC,$7F ; ROM $08F0 unclassified
        DB $00,$FC,$70,$00,$38,$20,$00,$30,$30,$00,$60,$10 ; ROM $08FC unclassified
        DB $00,$40,$10,$00,$40,$08,$00,$40,$08,$00,$40,$04 ; ROM $0908 unclassified
        DB $00,$03,$1A,$00,$20,$00,$00,$40,$00,$00,$80,$00 ; ROM $0914 unclassified
        DB $00,$00,$03,$00,$80,$3D,$00,$80,$1F,$00,$80,$03 ; ROM $0920 unclassified
        DB $00,$80,$03,$00,$80,$03,$00,$80,$03,$00,$F8,$01 ; ROM $092C unclassified
        DB $80,$FF,$01,$F8,$FF,$01,$F8,$FF,$01,$FC,$FF,$00 ; ROM $0938 unclassified
        DB $FD,$DF,$00,$F8,$83,$01,$78,$00,$03,$38,$00,$02 ; ROM $0944 unclassified
        DB $18,$00,$01,$0C,$80,$00,$02,$00,$00,$02,$00,$00 ; ROM $0950 unclassified
        DB $02,$00,$00,$02,$00,$00,$02,$00,$00,$03,$12,$00 ; ROM $095C unclassified
        DB $80,$00,$00,$00,$01,$00,$00,$02,$00,$00,$0C,$00 ; ROM $0968 unclassified
        DB $00,$F6,$00,$00,$7E,$00,$00,$07,$00,$80,$03,$F0 ; ROM $0974 unclassified
        DB $FF,$03,$FC,$FF,$01,$FF,$FF,$01,$FE,$FF,$00,$FE ; ROM $0980 unclassified
        DB $FF,$00,$FE,$FF,$00,$FC,$E3,$00,$38,$80,$01,$30 ; ROM $098C unclassified
        DB $00,$03,$3F,$F0,$01,$03,$15,$00,$80,$00,$00,$00 ; ROM $0998 unclassified
        DB $01,$00,$00,$02,$00,$00,$0C,$70,$00,$F6,$FD,$01 ; ROM $09A4 unclassified
        DB $7E,$FE,$07,$07,$FC,$FF,$03,$FC,$FF,$01,$F8,$FF ; ROM $09B0 unclassified
        DB $00,$F8,$7F,$00,$1F,$3F,$00,$00,$1C,$00,$00,$04 ; ROM $09BC unclassified
        DB $00,$00,$04,$00,$00,$04,$00,$00,$0C,$00,$00,$08 ; ROM $09C8 unclassified
        DB $00,$00,$08,$00,$00,$08,$00,$00,$08,$00,$03,$07 ; ROM $09D4 unclassified
        DB $00,$40,$00,$D0,$80,$00,$E0,$01,$01,$E0,$07,$06 ; ROM $09E0 unclassified
        DB $F0,$0F,$7B,$E0,$FF,$3F,$FF,$F8,$07,$02,$18,$80 ; ROM $09EC unclassified
        DB $03,$C0,$07,$E0,$0F,$F0,$1F,$F8,$1F,$F8,$3F,$FC ; ROM $09F8 unclassified
        DB $3F,$CC,$33,$CC,$33,$CE,$33,$FE,$7F,$CE,$73,$FF ; ROM $0A04 unclassified
        DB $7F,$F6,$7E,$F7,$DE,$F7,$DF,$F3,$DF,$FB,$CF,$F9 ; ROM $0A10 unclassified
        DB $CF,$F1,$9F,$F1,$8F,$61,$86,$40,$82,$78,$3E,$02 ; ROM $0A1C unclassified
        DB $1E,$80,$03,$C0,$07,$E0,$0F,$F0,$1F,$F8,$1F,$F8 ; ROM $0A28 unclassified
        DB $3F,$FC,$3F,$CC,$33,$FC,$3F,$CE,$33,$CE,$73,$CE ; ROM $0A34 unclassified
        DB $73,$FE,$7F,$F6,$7E,$F7,$DE,$F7,$DF,$F3,$DF,$FB ; ROM $0A40 unclassified
        DB $CF,$F9,$CF,$F1,$9F,$F1,$8F,$61,$86,$40,$82,$40 ; ROM $0A4C unclassified
        DB $02,$40,$02,$40,$02,$40,$02,$40,$02,$40,$02,$78 ; ROM $0A58 unclassified
        DB $3E,$02,$15,$80,$03,$C0,$07,$E0,$0F,$F0,$1F,$F8 ; ROM $0A64 unclassified
        DB $1F,$F8,$3F,$FC,$3F,$CC,$33,$CC,$33,$CE,$33,$CE ; ROM $0A70 unclassified
        DB $73,$CE,$73,$FE,$7F,$FE,$7E,$F7,$DE,$F7,$DF,$F3 ; ROM $0A7C unclassified
        DB $BF,$F3,$CF,$61,$86,$41,$82,$79,$DE,$02,$0E,$E0 ; ROM $0A88 unclassified
        DB $07,$F0,$1F,$F8,$1F,$F8,$3F,$FC,$3F,$CC,$33,$CC ; ROM $0A94 unclassified
        DB $33,$CE,$33,$CE,$F3,$CE,$F3,$FE,$FF,$6E,$9E,$42 ; ROM $0AA0 unclassified
        DB $82,$7A,$BE,$02,$09,$E0,$07,$F0,$1F,$F8,$1F,$F8 ; ROM $0AAC unclassified
        DB $3F,$CC,$33,$CE,$F3,$7E,$9E,$42,$82,$7A,$BE,$03 ; ROM $0AB8 unclassified
        DB $12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0,$FF ; ROM $0AC4 unclassified
        DB $00,$38,$C6,$01,$BC,$D6,$03,$BE,$D6,$07,$3F,$C6 ; ROM $0AD0 unclassified
        DB $0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00,$04 ; ROM $0ADC unclassified
        DB $00,$00,$04,$00,$00,$04,$00,$00,$04,$00,$00,$04 ; ROM $0AE8 unclassified
        DB $00,$00,$04,$00,$00,$1C,$00,$03,$12,$00,$0F,$00 ; ROM $0AF4 unclassified
        DB $C0,$3F,$00,$E0,$7F,$00,$F0,$FF,$00,$38,$C6,$01 ; ROM $0B00 unclassified
        DB $3C,$C6,$03,$BE,$D6,$07,$3F,$C6,$0F,$FE,$FF,$07 ; ROM $0B0C unclassified
        DB $F8,$FF,$01,$80,$1F,$00,$00,$04,$00,$00,$0C,$00 ; ROM $0B18 unclassified
        DB $00,$1A,$00,$00,$31,$00,$00,$21,$00,$00,$21,$00 ; ROM $0B24 unclassified
        DB $00,$E7,$00,$03,$12,$00,$0F,$00,$C0,$3F,$00,$E0 ; ROM $0B30 unclassified
        DB $7F,$00,$F0,$FF,$00,$38,$C6,$01,$3C,$C6,$03,$3E ; ROM $0B3C unclassified
        DB $C6,$07,$3F,$C6,$0F,$FE,$FF,$07,$F8,$FF,$01,$80 ; ROM $0B48 unclassified
        DB $1F,$00,$00,$04,$00,$00,$0A,$00,$00,$11,$00,$80 ; ROM $0B54 unclassified
        DB $20,$00,$40,$40,$00,$20,$80,$00,$E0,$80,$03,$03 ; ROM $0B60 unclassified
        DB $12,$00,$0F,$00,$C0,$3F,$00,$E0,$7F,$00,$F0,$FF ; ROM $0B6C unclassified
        DB $00,$38,$C6,$01,$3C,$C6,$03,$BE,$D6,$07,$3F,$C6 ; ROM $0B78 unclassified
        DB $0F,$FE,$FF,$07,$F8,$FF,$01,$80,$1F,$00,$00,$04 ; ROM $0B84 unclassified
        DB $00,$00,$0A,$00,$00,$11,$00,$80,$10,$00,$40,$10 ; ROM $0B90 unclassified
        DB $00,$20,$10,$00,$E0,$70,$00,$02,$0F,$00,$20,$00 ; ROM $0B9C unclassified
        DB $38,$00,$3E,$00,$3F,$80,$3B,$C0,$31,$E0,$20,$F0 ; ROM $0BA8 unclassified
        DB $31,$B8,$3B,$1C,$3F,$0C,$3E,$1C,$1F,$BC,$0F,$FE ; ROM $0BB4 unclassified
        DB $07,$FF,$03,$03,$0B,$80,$1F,$00,$F8,$FF,$01,$FE ; ROM $0BC0 unclassified
        DB $FF,$07,$3F,$C6,$0F,$7E,$EF,$07,$BC,$D6,$03,$78 ; ROM $0BCC unclassified
        DB $EF,$01,$F0,$FF,$00,$E0,$7F,$00,$C0,$3F,$00,$00 ; ROM $0BD8 unclassified
        DB $0F,$00,$02,$0B,$C0,$01,$00,$01,$00,$01,$00,$01 ; ROM $0BE4 unclassified
        DB $04,$01,$04,$01,$04,$01,$87,$07,$FD,$0F,$FF,$1F ; ROM $0BF0 unclassified
        DB $00,$07,$02,$12,$00,$0E,$00,$0A,$00,$7E,$00,$06 ; ROM $0BFC unclassified
        DB $01,$06,$0E,$06,$3C,$06,$F8,$07,$F8,$07,$F0,$03 ; ROM $0C08 unclassified
        DB $E0,$01,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00 ; ROM $0C14 unclassified
        DB $80,$00,$80,$03,$02,$12,$00,$0E,$00,$0A,$00,$7E ; ROM $0C20 unclassified
        DB $00,$06,$01,$06,$0E,$06,$3C,$06,$F8,$07,$F8,$07 ; ROM $0C2C unclassified
        DB $F0,$03,$E0,$01,$80,$00,$40,$01,$20,$02,$10,$02 ; ROM $0C38 unclassified
        DB $08,$02,$04,$02,$1C,$0E,$02,$12,$00,$0E,$00,$0A ; ROM $0C44 unclassified
        DB $00,$7E,$00,$06,$01,$06,$0E,$06,$3C,$06,$F8,$07 ; ROM $0C50 unclassified
        DB $F8,$07,$F0,$03,$E0,$01,$80,$00,$40,$01,$20,$02 ; ROM $0C5C unclassified
        DB $10,$04,$08,$08,$04,$10,$1C,$70,$02,$12,$00,$0E ; ROM $0C68 unclassified
        DB $00,$0A,$00,$7E,$00,$06,$01,$06,$0E,$06,$3C,$06 ; ROM $0C74 unclassified
        DB $F8,$07,$F8,$07,$F0,$03,$E0,$01,$80,$00,$80,$01 ; ROM $0C80 unclassified
        DB $40,$03,$20,$06,$20,$04,$20,$04,$E0,$1C,$01,$1B ; ROM $0C8C unclassified
        DB $18,$18,$18,$3C,$3C,$7E,$7E,$FF,$FF,$FF,$FF,$FF ; ROM $0C98 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7E,$3C,$3C ; ROM $0CA4 unclassified
        DB $7E,$7E,$FF,$02,$10,$E0,$07,$C0,$03,$C0,$03,$F8 ; ROM $0CB0 unclassified
        DB $1F,$FF,$FF,$FF,$FF,$FF,$FF,$1F,$F0,$8F,$F4,$2F ; ROM $0CBC unclassified
        DB $F1,$4F,$F4,$0F,$F0,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $0CC8 unclassified
        DB $FF,$01,$1A,$18,$18,$18,$18,$3C,$7E,$FF,$FF,$FF ; ROM $0CD4 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $0CE0 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$01,$10,$3C,$3C,$18,$18,$FF ; ROM $0CEC unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80 ; ROM $0CF8 unclassified
        DB $00,$02,$00,$48,$00,$28,$00,$18,$00,$9B,$00,$1E ; ROM $0D04 unclassified
        DB $00,$3C,$00,$79,$00,$DC,$00,$1E,$00,$3F,$00,$4C ; ROM $0D10 unclassified
        DB $00,$40,$00,$C4,$00,$D2,$00,$30,$00,$6C,$00,$FA ; ROM $0D1C unclassified
        DB $00,$03,$0D,$00,$70,$00,$00,$F8,$01,$00,$FC,$03 ; ROM $0D28 unclassified
        DB $00,$3C,$0F,$00,$1E,$1E,$08,$1E,$BE,$18,$3F,$FF ; ROM $0D34 unclassified
        DB $3C,$3F,$EF,$BC,$FF,$C3,$FE,$FF,$80,$3F,$63,$00 ; ROM $0D40 unclassified
        DB $1E,$42,$00,$0F,$C6,$00,$04,$0E,$00,$00,$7C,$00 ; ROM $0D4C unclassified
        DB $00,$80,$FF,$01,$02,$F0,$FF,$03,$04,$FF,$3F,$8F ; ROM $0D58 unclassified
        DB $E8,$FF,$1F,$FE,$F2,$FF,$9F,$FE,$E8,$FF,$3F,$FF ; ROM $0D64 unclassified
        DB $04,$FF,$FF,$8F,$02,$FC,$FF,$00,$00,$FC,$FF,$00 ; ROM $0D70 unclassified
        DB $00,$0C,$63,$00,$00,$18,$C1,$00,$00,$10,$81,$00 ; ROM $0D7C unclassified
        DB $00,$30,$83,$01,$04,$0E,$00,$00,$7C,$00,$00,$80 ; ROM $0D88 unclassified
        DB $FF,$01,$02,$F0,$FF,$03,$04,$FF,$3F,$0F,$E8,$FF ; ROM $0D94 unclassified
        DB $1F,$BE,$F2,$FF,$5F,$FE,$E8,$FF,$3F,$FF,$04,$FF ; ROM $0DA0 unclassified
        DB $FF,$CF,$02,$FC,$FF,$83,$00,$FC,$FF,$00,$00,$0C ; ROM $0DAC unclassified
        DB $63,$00,$00,$84,$21,$00,$00,$84,$20,$00,$00,$8C ; ROM $0DB8 unclassified
        DB $61,$00,$04,$0E,$00,$00,$7C,$00,$00,$80,$FF,$01 ; ROM $0DC4 unclassified
        DB $02,$F0,$FF,$03,$04,$FF,$3F,$8F,$E8,$FF,$9F,$FE ; ROM $0DD0 unclassified
        DB $F2,$FF,$1F,$FE,$E8,$FF,$3F,$FF,$04,$FF,$FF,$8F ; ROM $0DDC unclassified
        DB $02,$FC,$FF,$03,$00,$FC,$FF,$00,$00,$8C,$61,$00 ; ROM $0DE8 unclassified
        DB $00,$06,$33,$00,$00,$02,$12,$00,$00,$06,$36,$00 ; ROM $0DF4 unclassified
        DB $03,$0E,$80,$3F,$3F,$80,$F0,$23,$80,$F8,$23,$80 ; ROM $0E00 unclassified
        DB $FE,$23,$00,$DE,$22,$80,$F3,$23,$E0,$C1,$01,$F0 ; ROM $0E0C unclassified
        DB $C3,$00,$F8,$CF,$00,$F8,$0F,$00,$FA,$0F,$00,$FF ; ROM $0E18 unclassified
        DB $07,$00,$E3,$03,$00,$F2,$7F,$00,$03,$25,$00,$18 ; ROM $0E24 unclassified
        DB $00,$00,$38,$00,$00,$38,$38,$00,$38,$38,$00,$70 ; ROM $0E30 unclassified
        DB $08,$00,$70,$0C,$00,$70,$0C,$00,$60,$0C,$00,$60 ; ROM $0E3C unclassified
        DB $06,$00,$E0,$07,$00,$E0,$07,$00,$A0,$05,$00,$E0 ; ROM $0E48 unclassified
        DB $07,$00,$C0,$03,$00,$F0,$03,$00,$B8,$01,$00,$3C ; ROM $0E54 unclassified
        DB $01,$00,$1E,$00,$00,$3F,$00,$80,$FF,$03,$C0,$07 ; ROM $0E60 unclassified
        DB $03,$C0,$07,$03,$E0,$07,$00,$E0,$03,$00,$E0,$03 ; ROM $0E6C unclassified
        DB $00,$F0,$03,$00,$F0,$01,$00,$F6,$01,$00,$FF,$03 ; ROM $0E78 unclassified
        DB $00,$C6,$07,$00,$80,$07,$00,$00,$07,$00,$00,$03 ; ROM $0E84 unclassified
        DB $00,$80,$01,$00,$C0,$01,$00,$C0,$00,$00,$E0,$0F ; ROM $0E90 unclassified
        DB $00,$03,$21,$00,$18,$00,$00,$38,$00,$00,$38,$78 ; ROM $0E9C unclassified
        DB $00,$38,$78,$00,$70,$48,$00,$70,$0C,$00,$70,$0C ; ROM $0EA8 unclassified
        DB $00,$60,$0C,$00,$60,$06,$00,$E0,$07,$00,$E0,$07 ; ROM $0EB4 unclassified
        DB $00,$A0,$05,$00,$E0,$07,$00,$E0,$03,$00,$B0,$03 ; ROM $0EC0 unclassified
        DB $00,$B8,$01,$00,$3C,$01,$00,$1E,$00,$00,$3F,$00 ; ROM $0ECC unclassified
        DB $80,$FF,$1F,$C0,$07,$00,$C0,$07,$00,$E0,$07,$00 ; ROM $0ED8 unclassified
        DB $E0,$03,$00,$E0,$0F,$00,$F0,$1F,$00,$F0,$1F,$00 ; ROM $0EE4 unclassified
        DB $F6,$1F,$00,$1F,$0C,$00,$06,$06,$00,$00,$07,$00 ; ROM $0EF0 unclassified
        DB $00,$03,$00,$80,$3F,$00,$03,$1F,$00,$18,$00,$00 ; ROM $0EFC unclassified
        DB $38,$00,$00,$38,$38,$00,$38,$38,$00,$70,$08,$00 ; ROM $0F08 unclassified
        DB $70,$0C,$00,$70,$0C,$00,$60,$0C,$00,$60,$06,$00 ; ROM $0F14 unclassified
        DB $E0,$07,$00,$E0,$07,$00,$A0,$05,$00,$E0,$07,$00 ; ROM $0F20 unclassified
        DB $E0,$03,$00,$B0,$03,$00,$B8,$01,$00,$3C,$01,$00 ; ROM $0F2C unclassified
        DB $1E,$00,$00,$3F,$00,$80,$FF,$03,$C0,$07,$03,$C0 ; ROM $0F38 unclassified
        DB $07,$03,$E0,$07,$00,$E0,$03,$00,$E0,$07,$00,$F0 ; ROM $0F44 unclassified
        DB $1F,$00,$E0,$1F,$00,$F6,$1F,$00,$FF,$0F,$00,$C6 ; ROM $0F50 unclassified
        DB $07,$00,$E0,$FF,$00,$AB,$0F,$94,$0F,$A2,$0F,$AC ; ROM $0F5C unclassified
        DB $0F,$BE,$0F,$C7,$0F,$D3,$0F,$0E,$10,$47,$10,$8E ; ROM $0F68 native command vectors
        DB $0F,$6D,$10,$7A,$10,$7B,$0F ; ROM $0F74 native command vectors
NATIVE_0F7B:
        EX DE,HL  ; ROM $0F7B: EB
        LD A,(HL)  ; ROM $0F7C: 7E
        INC HL  ; ROM $0F7D: 23
        LD E,(HL)  ; ROM $0F7E: 5E
        INC HL  ; ROM $0F7F: 23
        LD D,(HL)  ; ROM $0F80: 56
        INC HL  ; ROM $0F81: 23
        PUSH DE  ; ROM $0F82: D5
        LD E,(HL)  ; ROM $0F83: 5E
        INC HL  ; ROM $0F84: 23
        LD D,(HL)  ; ROM $0F85: 56
        INC HL  ; ROM $0F86: 23
        LD ($2000),HL  ; ROM $0F87: 22 00 20
        POP HL  ; ROM $0F8A: E1
        JP $0132  ; ROM $0F8B: C3 32 01
NATIVE_0F8E:
        LD HL,$0167  ; ROM $0F8E: 21 67 01
        JP $0F97  ; ROM $0F91: C3 97 0F
NATIVE_0F94:
        LD HL,$0132  ; ROM $0F94: 21 32 01
NATIVE_0F97:
        PUSH HL  ; ROM $0F97: E5
        EX DE,HL  ; ROM $0F98: EB
        LD C,(HL)  ; ROM $0F99: 4E
        INC HL  ; ROM $0F9A: 23
        LD ($2000),HL  ; ROM $0F9B: 22 00 20
        CALL $1A06  ; ROM $0F9E: CD 06 1A
        RET  ; ROM $0FA1: C9
NATIVE_0FA2:
        EX DE,HL  ; ROM $0FA2: EB
        LD A,(HL)  ; ROM $0FA3: 7E
        LD ($2031),A  ; ROM $0FA4: 32 31 20
        INC HL  ; ROM $0FA7: 23
        LD ($2000),HL  ; ROM $0FA8: 22 00 20
NATIVE_0FAB:
        RET  ; ROM $0FAB: C9
NATIVE_0FAC:
        EX DE,HL  ; ROM $0FAC: EB
        LD A,(HL)  ; ROM $0FAD: 7E
        LD ($2030),A  ; ROM $0FAE: 32 30 20
        INC HL  ; ROM $0FB1: 23
        LD E,(HL)  ; ROM $0FB2: 5E
        INC HL  ; ROM $0FB3: 23
        LD D,(HL)  ; ROM $0FB4: 56
        INC HL  ; ROM $0FB5: 23
        LD ($2000),HL  ; ROM $0FB6: 22 00 20
        EX DE,HL  ; ROM $0FB9: EB
        LD ($2019),HL  ; ROM $0FBA: 22 19 20
        RET  ; ROM $0FBD: C9
NATIVE_0FBE:
        EX DE,HL  ; ROM $0FBE: EB
        LD E,(HL)  ; ROM $0FBF: 5E
        INC HL  ; ROM $0FC0: 23
        LD D,(HL)  ; ROM $0FC1: 56
        EX DE,HL  ; ROM $0FC2: EB
        LD ($2000),HL  ; ROM $0FC3: 22 00 20
        RET  ; ROM $0FC6: C9
NATIVE_0FC7:
        EX DE,HL  ; ROM $0FC7: EB
        LD A,(HL)  ; ROM $0FC8: 7E
        INC HL  ; ROM $0FC9: 23
        LD E,(HL)  ; ROM $0FCA: 5E
        INC HL  ; ROM $0FCB: 23
        LD D,(HL)  ; ROM $0FCC: 56
        INC HL  ; ROM $0FCD: 23
        LD ($2000),HL  ; ROM $0FCE: 22 00 20
        LD (DE),A  ; ROM $0FD1: 12
        RET  ; ROM $0FD2: C9
NATIVE_0FD3:
        POP HL  ; ROM $0FD3: E1
        LD SP,$4030  ; ROM $0FD4: 31 30 40
NATIVE_0FD7:
        DI  ; ROM $0FD7: F3
        LD BC,$0000  ; ROM $0FD8: 01 00 00
        XOR A  ; ROM $0FDB: AF
NATIVE_0FDC:
        PUSH BC  ; ROM $0FDC: C5
        PUSH BC  ; ROM $0FDD: C5
        PUSH BC  ; ROM $0FDE: C5
        PUSH BC  ; ROM $0FDF: C5
        PUSH BC  ; ROM $0FE0: C5
        PUSH BC  ; ROM $0FE1: C5
        PUSH BC  ; ROM $0FE2: C5
        PUSH BC  ; ROM $0FE3: C5
        PUSH BC  ; ROM $0FE4: C5
        PUSH BC  ; ROM $0FE5: C5
        PUSH BC  ; ROM $0FE6: C5
        PUSH BC  ; ROM $0FE7: C5
        PUSH BC  ; ROM $0FE8: C5
        PUSH BC  ; ROM $0FE9: C5
        PUSH BC  ; ROM $0FEA: C5
        PUSH BC  ; ROM $0FEB: C5
        DEC A  ; ROM $0FEC: 3D
        JP NZ,$0FDC  ; ROM $0FED: C2 DC 0F
        LD SP,$2400  ; ROM $0FF0: 31 00 24
        JP (HL)  ; ROM $0FF3: E9
NATIVE_0FF4:
        LD C,(HL)  ; ROM $0FF4: 4E
        INC HL  ; ROM $0FF5: 23
        LD B,(HL)  ; ROM $0FF6: 46
        INC HL  ; ROM $0FF7: 23
        EX DE,HL  ; ROM $0FF8: EB
NATIVE_0FF9:
        PUSH BC  ; ROM $0FF9: C5
        PUSH HL  ; ROM $0FFA: E5
NATIVE_0FFB:
        LD A,(DE)  ; ROM $0FFB: 1A
        INC DE  ; ROM $0FFC: 13
        LD (HL),A  ; ROM $0FFD: 77
        INC HL  ; ROM $0FFE: 23
        DEC C  ; ROM $0FFF: 0D

        ORG $1000
; Device 9316.1f, SHA1 1cc4e9b0aa7e9546c133bd40d40ede6f2fbe93ba
        JP NZ,$0FFB  ; ROM $1000: C2 FB 0F
        POP HL  ; ROM $1003: E1
        LD BC,$0020  ; ROM $1004: 01 20 00
        ADD HL,BC  ; ROM $1007: 09
        POP BC  ; ROM $1008: C1
        DEC B  ; ROM $1009: 05
        JP NZ,$0FF9  ; ROM $100A: C2 F9 0F
        RET  ; ROM $100D: C9
NATIVE_100E:
        LD HL,$204A  ; ROM $100E: 21 4A 20
        LD BC,$0BFE  ; ROM $1011: 01 FE 0B
        LD (HL),B  ; ROM $1014: 70
        DEC HL  ; ROM $1015: 2B
        LD (HL),C  ; ROM $1016: 71
        DEC HL  ; ROM $1017: 2B
        LD (HL),$00  ; ROM $1018: 36 00
        DEC HL  ; ROM $101A: 2B
        LD (HL),$30  ; ROM $101B: 36 30
        DEC HL  ; ROM $101D: 2B
        LD (HL),$01  ; ROM $101E: 36 01
        DEC HL  ; ROM $1020: 2B
        LD (HL),$4A  ; ROM $1021: 36 4A
        DEC HL  ; ROM $1023: 2B
        LD (HL),$0C  ; ROM $1024: 36 0C
        DEC HL  ; ROM $1026: 2B
        LD (HL),$00  ; ROM $1027: 36 00
        DEC HL  ; ROM $1029: 2B
        LD (HL),$02  ; ROM $102A: 36 02
        DEC HL  ; ROM $102C: 2B
        LD (HL),$00  ; ROM $102D: 36 00
        DEC HL  ; ROM $102F: 2B
        LD (HL),$CC  ; ROM $1030: 36 CC
        RET  ; ROM $1032: C9
NATIVE_1033:
        LD A,(DE)  ; ROM $1033: 1A
        RRA  ; ROM $1034: 1F
        RRA  ; ROM $1035: 1F
        RRA  ; ROM $1036: 1F
        RRA  ; ROM $1037: 1F
        AND $0F  ; ROM $1038: E6 0F
        ADD A,$30  ; ROM $103A: C6 30
        LD (BC),A  ; ROM $103C: 02
        INC BC  ; ROM $103D: 03
        LD A,(DE)  ; ROM $103E: 1A
        AND $0F  ; ROM $103F: E6 0F
        ADD A,$30  ; ROM $1041: C6 30
        LD (BC),A  ; ROM $1043: 02
        INC BC  ; ROM $1044: 03
        INC DE  ; ROM $1045: 13
        RET  ; ROM $1046: C9
NATIVE_1047:
        EX DE,HL  ; ROM $1047: EB
        LD E,(HL)  ; ROM $1048: 5E
        INC HL  ; ROM $1049: 23
        LD D,(HL)  ; ROM $104A: 56
        INC HL  ; ROM $104B: 23
        LD BC,$2083  ; ROM $104C: 01 83 20
        PUSH BC  ; ROM $104F: C5
        PUSH HL  ; ROM $1050: E5
        PUSH BC  ; ROM $1051: C5
        CALL $1033  ; ROM $1052: CD 33 10
        CALL $1033  ; ROM $1055: CD 33 10
        LD A,$30  ; ROM $1058: 3E 30
        LD (BC),A  ; ROM $105A: 02
        POP HL  ; ROM $105B: E1
        CALL $11AC  ; ROM $105C: CD AC 11
        POP HL  ; ROM $105F: E1
        LD E,(HL)  ; ROM $1060: 5E
        INC HL  ; ROM $1061: 23
        LD D,(HL)  ; ROM $1062: 56
        INC HL  ; ROM $1063: 23
        LD ($2000),HL  ; ROM $1064: 22 00 20
        POP HL  ; ROM $1067: E1
        LD A,$05  ; ROM $1068: 3E 05
        JP $0132  ; ROM $106A: C3 32 01
NATIVE_106D:
        EX DE,HL  ; ROM $106D: EB
        LD E,(HL)  ; ROM $106E: 5E
        INC HL  ; ROM $106F: 23
        LD D,(HL)  ; ROM $1070: 56
        INC HL  ; ROM $1071: 23
        LD ($2000),HL  ; ROM $1072: 22 00 20
        LD A,(DE)  ; ROM $1075: 1A
        AND $F7  ; ROM $1076: E6 F7
        LD (DE),A  ; ROM $1078: 12
        RET  ; ROM $1079: C9
NATIVE_107A:
        LD HL,$2018  ; ROM $107A: 21 18 20
        LD A,(HL)  ; ROM $107D: 7E
        AND A  ; ROM $107E: A7
        RET Z  ; ROM $107F: C8
        DEC (HL)  ; ROM $1080: 35
        LD HL,$1676  ; ROM $1081: 21 76 16
        LD ($2000),HL  ; ROM $1084: 22 00 20
        LD HL,($201C)  ; ROM $1087: 2A 1C 20
        LD ($200B),HL  ; ROM $108A: 22 0B 20
        LD A,$08  ; ROM $108D: 3E 08
        OUT ($07),A  ; ROM $108F: D3 07
        IN A,($02)  ; ROM $1091: DB 02
        AND $03  ; ROM $1093: E6 03
        LD C,A  ; ROM $1095: 4F
        LD B,$00  ; ROM $1096: 06 00
        LD HL,$10AE  ; ROM $1098: 21 AE 10
        ADD HL,BC  ; ROM $109B: 09
        LD A,(HL)  ; ROM $109C: 7E
        LD ($2008),A  ; ROM $109D: 32 08 20
        LD A,$08  ; ROM $10A0: 3E 08
        OUT ($03),A  ; ROM $10A2: D3 03
        LD ($201F),A  ; ROM $10A4: 32 1F 20
        LD HL,$10B2  ; ROM $10A7: 21 B2 10
        LD ($2012),HL  ; ROM $10AA: 22 12 20
        RET  ; ROM $10AD: C9
        DB $43,$53,$63,$73,$84,$01,$08,$01,$0D,$01,$11,$01 ; ROM $10AE unclassified
        DB $08,$01,$0D,$01,$11,$01,$08,$01,$0D,$02,$11,$02 ; ROM $10BA unclassified
        DB $00,$01,$12,$01,$11,$01,$00,$01,$11,$01,$0F,$01 ; ROM $10C6 unclassified
        DB $00,$01,$0F,$03,$0D,$00,$85,$01,$00,$01,$0C,$02 ; ROM $10D2 unclassified
        DB $0F,$01,$0C,$01,$0D,$02,$0F,$01,$00,$01,$0C,$02 ; ROM $10DE unclassified
        DB $0F,$01,$0C,$01,$0D,$03,$0F,$00,$85,$02,$08,$02 ; ROM $10EA unclassified
        DB $0D,$02,$0F,$02,$12,$08,$11,$02,$08,$02,$0D,$02 ; ROM $10F6 unclassified
        DB $0F,$01,$12,$01,$11,$01,$0F,$07,$11,$00,$85,$02 ; ROM $1102 unclassified
        DB $0A,$01,$0A,$02,$0A,$01,$0A,$02,$0A,$01,$0A,$02 ; ROM $110E unclassified
        DB $11,$01,$0E,$02,$11,$01,$0E,$02,$11,$01,$0E,$03 ; ROM $111A unclassified
        DB $0A,$00,$85,$04,$0D,$03,$0C,$01,$0D,$02,$0A,$03 ; ROM $1126 unclassified
        DB $0D,$01,$00,$02,$0F,$02,$10,$02,$11,$02,$12,$02 ; ROM $1132 unclassified
        DB $13,$04,$14,$00 ; ROM $113E unclassified
NATIVE_1142:
        LD DE,$2008  ; ROM $1142: 11 08 20
        LD BC,$2083  ; ROM $1145: 01 83 20
        PUSH BC  ; ROM $1148: C5
        PUSH BC  ; ROM $1149: C5
        PUSH BC  ; ROM $114A: C5
        PUSH BC  ; ROM $114B: C5
        PUSH BC  ; ROM $114C: C5
        PUSH BC  ; ROM $114D: C5
        PUSH BC  ; ROM $114E: C5
        PUSH BC  ; ROM $114F: C5
        CALL $1033  ; ROM $1150: CD 33 10
        POP HL  ; ROM $1153: E1
        CALL $11AC  ; ROM $1154: CD AC 11
        POP HL  ; ROM $1157: E1
        LD A,$02  ; ROM $1158: 3E 02
        LD DE,$2400  ; ROM $115A: 11 00 24
        CALL $0132  ; ROM $115D: CD 32 01
        LD C,$03  ; ROM $1160: 0E 03
        CALL $1A06  ; ROM $1162: CD 06 1A
        CALL $0132  ; ROM $1165: CD 32 01
        POP HL  ; ROM $1168: E1
        LD BC,$4006  ; ROM $1169: 01 06 40
NATIVE_116C:
        LD (HL),B  ; ROM $116C: 70
        INC HL  ; ROM $116D: 23
        DEC C  ; ROM $116E: 0D
        JP NZ,$116C  ; ROM $116F: C2 6C 11
        POP HL  ; ROM $1172: E1
        LD A,($20B9)  ; ROM $1173: 3A B9 20
        AND A  ; ROM $1176: A7
        JP Z,$1181  ; ROM $1177: CA 81 11
NATIVE_117A:
        LD (HL),$5B  ; ROM $117A: 36 5B
        INC HL  ; ROM $117C: 23
        DEC A  ; ROM $117D: 3D
        JP NZ,$117A  ; ROM $117E: C2 7A 11
NATIVE_1181:
        POP HL  ; ROM $1181: E1
        LD A,$06  ; ROM $1182: 3E 06
        LD DE,$240C  ; ROM $1184: 11 0C 24
        CALL $0132  ; ROM $1187: CD 32 01
        LD C,$04  ; ROM $118A: 0E 04
        CALL $1A06  ; ROM $118C: CD 06 1A
        CALL $0132  ; ROM $118F: CD 32 01
        LD DE,$2009  ; ROM $1192: 11 09 20
        POP BC  ; ROM $1195: C1
        CALL $1033  ; ROM $1196: CD 33 10
        CALL $1033  ; ROM $1199: CD 33 10
        LD A,$30  ; ROM $119C: 3E 30
        LD (BC),A  ; ROM $119E: 02
        POP HL  ; ROM $119F: E1
        CALL $11AC  ; ROM $11A0: CD AC 11
        POP HL  ; ROM $11A3: E1
        LD A,$05  ; ROM $11A4: 3E 05
        LD DE,$241B  ; ROM $11A6: 11 1B 24
        JP $0132  ; ROM $11A9: C3 32 01
NATIVE_11AC:
        LD C,$04  ; ROM $11AC: 0E 04
NATIVE_11AE:
        LD A,(HL)  ; ROM $11AE: 7E
        CP $30  ; ROM $11AF: FE 30
        RET NZ  ; ROM $11B1: C0
        LD (HL),$40  ; ROM $11B2: 36 40
        INC HL  ; ROM $11B4: 23
        DEC C  ; ROM $11B5: 0D
        JP NZ,$11AE  ; ROM $11B6: C2 AE 11
        RET  ; ROM $11B9: C9
NATIVE_11BA:
        LD HL,$11C3  ; ROM $11BA: 21 C3 11
        LD SP,$4000  ; ROM $11BD: 31 00 40
        JP $0FD7  ; ROM $11C0: C3 D7 0F
        DB $21,$33,$16,$22,$00,$20,$21,$C9,$11,$E5,$FB,$D3 ; ROM $11C3 unclassified
        DB $04 ; ROM $11CF unclassified
NATIVE_11D0:
        LD HL,($2000)  ; ROM $11D0: 2A 00 20
        LD A,(HL)  ; ROM $11D3: 7E
        AND A  ; ROM $11D4: A7
        JP Z,$11EA  ; ROM $11D5: CA EA 11
        INC HL  ; ROM $11D8: 23
        LD ($2000),HL  ; ROM $11D9: 22 00 20
        EX DE,HL  ; ROM $11DC: EB
        LD HL,$0F61  ; ROM $11DD: 21 61 0F
        RLCA  ; ROM $11E0: 07
        LD C,A  ; ROM $11E1: 4F
        LD B,$00  ; ROM $11E2: 06 00
        ADD HL,BC  ; ROM $11E4: 09
        LD A,(HL)  ; ROM $11E5: 7E
        INC HL  ; ROM $11E6: 23
        LD H,(HL)  ; ROM $11E7: 66
        LD L,A  ; ROM $11E8: 6F
        JP (HL)  ; ROM $11E9: E9
NATIVE_11EA:
        CALL $12E5  ; ROM $11EA: CD E5 12
        CALL $12B1  ; ROM $11ED: CD B1 12
        CALL $129E  ; ROM $11F0: CD 9E 12
        CALL $1936  ; ROM $11F3: CD 36 19
        CALL $1232  ; ROM $11F6: CD 32 12
        CALL $1503  ; ROM $11F9: CD 03 15
        CALL $124E  ; ROM $11FC: CD 4E 12
        LD A,($200D)  ; ROM $11FF: 3A 0D 20
        AND A  ; ROM $1202: A7
        RET Z  ; ROM $1203: C8
        CALL $1318  ; ROM $1204: CD 18 13
        CALL $1142  ; ROM $1207: CD 42 11
        CALL $16F0  ; ROM $120A: CD F0 16
        RET  ; ROM $120D: C9
NATIVE_120E:
        LD HL,$2031  ; ROM $120E: 21 31 20
        LD DE,$000F  ; ROM $1211: 11 0F 00
NATIVE_1214:
        ADD HL,DE  ; ROM $1214: 19
        DEC A  ; ROM $1215: 3D
        JP P,$1214  ; ROM $1216: F2 14 12
        RET  ; ROM $1219: C9
NATIVE_121A:
        LD HL,$2085  ; ROM $121A: 21 85 20
        LD DE,$203B  ; ROM $121D: 11 3B 20
        LD BC,$0008  ; ROM $1220: 01 08 00
NATIVE_1223:
        INC DE  ; ROM $1223: 13
        ADD HL,BC  ; ROM $1224: 09
        LD A,(HL)  ; ROM $1225: 7E
        AND A  ; ROM $1226: A7
        JP NZ,$1223  ; ROM $1227: C2 23 12
        RET  ; ROM $122A: C9
NATIVE_122B:
        LD DE,$2080  ; ROM $122B: 11 80 20
        LD A,(DE)  ; ROM $122E: 1A
        OR B  ; ROM $122F: B0
        LD (DE),A  ; ROM $1230: 12
        RET  ; ROM $1231: C9
NATIVE_1232:
        PUSH HL  ; ROM $1232: E5
        LD HL,$201E  ; ROM $1233: 21 1E 20
        LD C,$00  ; ROM $1236: 0E 00
        LD A,(HL)  ; ROM $1238: 7E
        AND A  ; ROM $1239: A7
        JP NZ,$123E  ; ROM $123A: C2 3E 12
        DEC A  ; ROM $123D: 3D
NATIVE_123E:
        LD B,A  ; ROM $123E: 47
        AND $1D  ; ROM $123F: E6 1D
        JP PE,$1246  ; ROM $1241: EA 46 12
        LD C,$80  ; ROM $1244: 0E 80
NATIVE_1246:
        LD A,B  ; ROM $1246: 78
        RRCA  ; ROM $1247: 0F
        AND $7F  ; ROM $1248: E6 7F
        ADD A,C  ; ROM $124A: 81
        LD (HL),A  ; ROM $124B: 77
        POP HL  ; ROM $124C: E1
        RET  ; ROM $124D: C9
NATIVE_124E:
        LD HL,$2040  ; ROM $124E: 21 40 20
        LD DE,$204F  ; ROM $1251: 11 4F 20
        CALL $125D  ; ROM $1254: CD 5D 12
        LD HL,$205E  ; ROM $1257: 21 5E 20
        LD DE,$206D  ; ROM $125A: 11 6D 20
NATIVE_125D:
        LD A,(HL)  ; ROM $125D: 7E
        AND A  ; ROM $125E: A7
        RET P  ; ROM $125F: F0
        LD A,(DE)  ; ROM $1260: 1A
        AND A  ; ROM $1261: A7
        RET P  ; ROM $1262: F0
        PUSH DE  ; ROM $1263: D5
        CALL $127E  ; ROM $1264: CD 7E 12
        POP HL  ; ROM $1267: E1
        INC HL  ; ROM $1268: 23
        INC HL  ; ROM $1269: 23
        LD A,(HL)  ; ROM $126A: 7E
        AND A  ; ROM $126B: A7
        RET P  ; ROM $126C: F0
        INC HL  ; ROM $126D: 23
        LD A,(HL)  ; ROM $126E: 7E
        SUB $88  ; ROM $126F: D6 88
        RET NC  ; ROM $1271: D0
        DEC HL  ; ROM $1272: 2B
        LD A,(HL)  ; ROM $1273: 7E
        CPL  ; ROM $1274: 2F
        INC A  ; ROM $1275: 3C
        LD (HL),A  ; ROM $1276: 77
        DEC HL  ; ROM $1277: 2B
        DEC HL  ; ROM $1278: 2B
        LD A,(HL)  ; ROM $1279: 7E
        AND $EF  ; ROM $127A: E6 EF
        LD (HL),A  ; ROM $127C: 77
        RET  ; ROM $127D: C9
NATIVE_127E:
        INC HL  ; ROM $127E: 23
        LD C,(HL)  ; ROM $127F: 4E
        INC HL  ; ROM $1280: 23
        LD A,(HL)  ; ROM $1281: 7E
        AND A  ; ROM $1282: A7
        RET M  ; ROM $1283: F8
        LD B,$00  ; ROM $1284: 06 00
        INC HL  ; ROM $1286: 23
        EX DE,HL  ; ROM $1287: EB
        LD HL,$06DC  ; ROM $1288: 21 DC 06
        ADD HL,BC  ; ROM $128B: 09
        LD A,(HL)  ; ROM $128C: 7E
        SUB $80  ; ROM $128D: D6 80
        EX DE,HL  ; ROM $128F: EB
        CP (HL)  ; ROM $1290: BE
        RET NC  ; ROM $1291: D0
        DEC HL  ; ROM $1292: 2B
        LD A,(HL)  ; ROM $1293: 7E
        CPL  ; ROM $1294: 2F
        INC A  ; ROM $1295: 3C
        LD (HL),A  ; ROM $1296: 77
        DEC HL  ; ROM $1297: 2B
        DEC HL  ; ROM $1298: 2B
        LD A,(HL)  ; ROM $1299: 7E
        OR $10  ; ROM $129A: F6 10
        LD (HL),A  ; ROM $129C: 77
        RET  ; ROM $129D: C9
NATIVE_129E:
        LD HL,$207C  ; ROM $129E: 21 7C 20
        LD A,(HL)  ; ROM $12A1: 7E
        AND A  ; ROM $12A2: A7
        RET Z  ; ROM $12A3: C8
        LD (HL),$00  ; ROM $12A4: 36 00
        RRA  ; ROM $12A6: 1F
        PUSH AF  ; ROM $12A7: F5
        CALL C,$1C22  ; ROM $12A8: DC 22 1C
        POP AF  ; ROM $12AB: F1
        RRA  ; ROM $12AC: 1F
        CALL C,$1977  ; ROM $12AD: DC 77 19
        RET  ; ROM $12B0: C9
NATIVE_12B1:
        LD HL,$207D  ; ROM $12B1: 21 7D 20
        LD A,(HL)  ; ROM $12B4: 7E
        AND A  ; ROM $12B5: A7
        RET Z  ; ROM $12B6: C8
        LD (HL),$00  ; ROM $12B7: 36 00
        RRA  ; ROM $12B9: 1F
        PUSH AF  ; ROM $12BA: F5
        CALL C,$13F2  ; ROM $12BB: DC F2 13
        POP AF  ; ROM $12BE: F1
        RRA  ; ROM $12BF: 1F
        PUSH AF  ; ROM $12C0: F5
        CALL C,$13C1  ; ROM $12C1: DC C1 13
        POP AF  ; ROM $12C4: F1
        RRA  ; ROM $12C5: 1F
        PUSH AF  ; ROM $12C6: F5
        CALL C,$1C43  ; ROM $12C7: DC 43 1C
        POP AF  ; ROM $12CA: F1
        RRA  ; ROM $12CB: 1F
        PUSH AF  ; ROM $12CC: F5
        CALL C,$1345  ; ROM $12CD: DC 45 13
        POP AF  ; ROM $12D0: F1
        RRA  ; ROM $12D1: 1F
        PUSH AF  ; ROM $12D2: F5
        CALL C,$1C35  ; ROM $12D3: DC 35 1C
        POP AF  ; ROM $12D6: F1
        RRA  ; ROM $12D7: 1F
        PUSH AF  ; ROM $12D8: F5
        CALL C,$1D77  ; ROM $12D9: DC 77 1D
        POP AF  ; ROM $12DC: F1
        RRA  ; ROM $12DD: 1F
        RRA  ; ROM $12DE: 1F
        PUSH AF  ; ROM $12DF: F5
        CALL C,$1C2D  ; ROM $12E0: DC 2D 1C
        POP AF  ; ROM $12E3: F1
        RET  ; ROM $12E4: C9
NATIVE_12E5:
        LD HL,$207E  ; ROM $12E5: 21 7E 20
        LD A,(HL)  ; ROM $12E8: 7E
        AND A  ; ROM $12E9: A7
        RET Z  ; ROM $12EA: C8
        LD (HL),$00  ; ROM $12EB: 36 00
        RRA  ; ROM $12ED: 1F
        PUSH AF  ; ROM $12EE: F5
        CALL C,$1CE4  ; ROM $12EF: DC E4 1C
        POP AF  ; ROM $12F2: F1
        RRA  ; ROM $12F3: 1F
        PUSH AF  ; ROM $12F4: F5
        CALL C,$1CDB  ; ROM $12F5: DC DB 1C
        POP AF  ; ROM $12F8: F1
        RRA  ; ROM $12F9: 1F
        PUSH AF  ; ROM $12FA: F5
        CALL C,$1CD2  ; ROM $12FB: DC D2 1C
        POP AF  ; ROM $12FE: F1
        RRA  ; ROM $12FF: 1F
        PUSH AF  ; ROM $1300: F5
        CALL C,$1CC9  ; ROM $1301: DC C9 1C
        POP AF  ; ROM $1304: F1
        RRA  ; ROM $1305: 1F
        PUSH AF  ; ROM $1306: F5
        CALL C,$1DEA  ; ROM $1307: DC EA 1D
        POP AF  ; ROM $130A: F1
        RRA  ; ROM $130B: 1F
        PUSH AF  ; ROM $130C: F5
        CALL C,$1D4B  ; ROM $130D: DC 4B 1D
        POP AF  ; ROM $1310: F1
        RRA  ; ROM $1311: 1F
        PUSH AF  ; ROM $1312: F5
        CALL C,$1D36  ; ROM $1313: DC 36 1D
        POP AF  ; ROM $1316: F1
        RET  ; ROM $1317: C9
NATIVE_1318:
        LD HL,$2037  ; ROM $1318: 21 37 20
        LD A,(HL)  ; ROM $131B: 7E
        AND A  ; ROM $131C: A7
        JP NZ,$132E  ; ROM $131D: C2 2E 13
        LD A,($2040)  ; ROM $1320: 3A 40 20
        AND A  ; ROM $1323: A7
        JP M,$132E  ; ROM $1324: FA 2E 13
        LD A,($204F)  ; ROM $1327: 3A 4F 20
        AND A  ; ROM $132A: A7
        CALL P,$133C  ; ROM $132B: F4 3C 13
NATIVE_132E:
        INC HL  ; ROM $132E: 23
        LD A,(HL)  ; ROM $132F: 7E
        AND A  ; ROM $1330: A7
        RET NZ  ; ROM $1331: C0
        LD A,($205E)  ; ROM $1332: 3A 5E 20
        AND A  ; ROM $1335: A7
        RET M  ; ROM $1336: F8
        LD A,($206D)  ; ROM $1337: 3A 6D 20
        AND A  ; ROM $133A: A7
        RET M  ; ROM $133B: F8
NATIVE_133C:
        CALL $1232  ; ROM $133C: CD 32 12
        AND $3F  ; ROM $133F: E6 3F
        OR $20  ; ROM $1341: F6 20
        LD (HL),A  ; ROM $1343: 77
        RET  ; ROM $1344: C9
NATIVE_1345:
        CALL $1232  ; ROM $1345: CD 32 12
        AND $3F  ; ROM $1348: E6 3F
        OR $20  ; ROM $134A: F6 20
        LD ($2035),A  ; ROM $134C: 32 35 20
        LD A,($20BA)  ; ROM $134F: 3A BA 20
        AND A  ; ROM $1352: A7
        RET NZ  ; ROM $1353: C0
        LD A,$03  ; ROM $1354: 3E 03
NATIVE_1356:
        PUSH AF  ; ROM $1356: F5
        CALL $120E  ; ROM $1357: CD 0E 12
        LD A,(HL)  ; ROM $135A: 7E
        AND A  ; ROM $135B: A7
        JP P,$136C  ; ROM $135C: F2 6C 13
        AND $02  ; ROM $135F: E6 02
        JP NZ,$136C  ; ROM $1361: C2 6C 13
        PUSH HL  ; ROM $1364: E5
        CALL $13A6  ; ROM $1365: CD A6 13
        POP HL  ; ROM $1368: E1
        CALL $1372  ; ROM $1369: CD 72 13
NATIVE_136C:
        POP AF  ; ROM $136C: F1
        DEC A  ; ROM $136D: 3D
        JP P,$1356  ; ROM $136E: F2 56 13
        RET  ; ROM $1371: C9
NATIVE_1372:
        LD A,($200D)  ; ROM $1372: 3A 0D 20
        AND A  ; ROM $1375: A7
        RET Z  ; ROM $1376: C8
        LD A,($2032)  ; ROM $1377: 3A 32 20
        AND A  ; ROM $137A: A7
        RET NZ  ; ROM $137B: C0
        INC HL  ; ROM $137C: 23
        LD A,(HL)  ; ROM $137D: 7E
        DEC HL  ; ROM $137E: 2B
        AND $07  ; ROM $137F: E6 07
        JP Z,$138A  ; ROM $1381: CA 8A 13
        LD A,($2009)  ; ROM $1384: 3A 09 20
        CP $02  ; ROM $1387: FE 02
        RET M  ; ROM $1389: F8
NATIVE_138A:
        CALL $1232  ; ROM $138A: CD 32 12
        RLA  ; ROM $138D: 17
        RET C  ; ROM $138E: D8
        LD A,(HL)  ; ROM $138F: 7E
        XOR $10  ; ROM $1390: EE 10
        AND $FB  ; ROM $1392: E6 FB
        LD (HL),A  ; ROM $1394: 77
        INC HL  ; ROM $1395: 23
        LD A,(HL)  ; ROM $1396: 7E
        AND A  ; ROM $1397: A7
        CALL Z,$14AE  ; ROM $1398: CC AE 14
        INC HL  ; ROM $139B: 23
        LD A,(HL)  ; ROM $139C: 7E
        CPL  ; ROM $139D: 2F
        INC A  ; ROM $139E: 3C
        LD (HL),A  ; ROM $139F: 77
        LD A,$0C  ; ROM $13A0: 3E 0C
        LD ($203B),A  ; ROM $13A2: 32 3B 20
        RET  ; ROM $13A5: C9
NATIVE_13A6:
        INC HL  ; ROM $13A6: 23
        LD A,(HL)  ; ROM $13A7: 7E
        AND $07  ; ROM $13A8: E6 07
        CP $05  ; ROM $13AA: FE 05
        RET P  ; ROM $13AC: F0
        LD DE,$0005  ; ROM $13AD: 11 05 00
        ADD HL,DE  ; ROM $13B0: 19
        CALL $1232  ; ROM $13B1: CD 32 12
        AND $03  ; ROM $13B4: E6 03
        LD (HL),A  ; ROM $13B6: 77
        CALL $1232  ; ROM $13B7: CD 32 12
        RRA  ; ROM $13BA: 1F
        RET C  ; ROM $13BB: D8
        LD A,(HL)  ; ROM $13BC: 7E
        CPL  ; ROM $13BD: 2F
        INC A  ; ROM $13BE: 3C
        LD (HL),A  ; ROM $13BF: 77
        RET  ; ROM $13C0: C9
NATIVE_13C1:
        LD A,($20BA)  ; ROM $13C1: 3A BA 20
        AND A  ; ROM $13C4: A7
        RET NZ  ; ROM $13C5: C0
        LD HL,$2040  ; ROM $13C6: 21 40 20
        LD A,(HL)  ; ROM $13C9: 7E
        AND A  ; ROM $13CA: A7
        RET M  ; ROM $13CB: F8
        CALL $1422  ; ROM $13CC: CD 22 14
        ADD A,$0C  ; ROM $13CF: C6 0C
        LD DE,$14F3  ; ROM $13D1: 11 F3 14
        CALL $1494  ; ROM $13D4: CD 94 14
        LD (HL),$CC  ; ROM $13D7: 36 CC
        CALL $1232  ; ROM $13D9: CD 32 12
        RRA  ; ROM $13DC: 1F
        RET C  ; ROM $13DD: D8
        LD HL,$204F  ; ROM $13DE: 21 4F 20
        LD A,(HL)  ; ROM $13E1: 7E
        AND A  ; ROM $13E2: A7
        RET M  ; ROM $13E3: F8
        CALL $1422  ; ROM $13E4: CD 22 14
        ADD A,$0C  ; ROM $13E7: C6 0C
        LD DE,$14F3  ; ROM $13E9: 11 F3 14
        CALL $14A0  ; ROM $13EC: CD A0 14
        LD (HL),$DC  ; ROM $13EF: 36 DC
        RET  ; ROM $13F1: C9
NATIVE_13F2:
        LD A,($20BA)  ; ROM $13F2: 3A BA 20
        AND A  ; ROM $13F5: A7
        RET NZ  ; ROM $13F6: C0
        LD HL,$205E  ; ROM $13F7: 21 5E 20
        LD A,(HL)  ; ROM $13FA: 7E
        AND A  ; ROM $13FB: A7
        RET M  ; ROM $13FC: F8
        CALL $1422  ; ROM $13FD: CD 22 14
        ADD A,$66  ; ROM $1400: C6 66
        LD DE,$14E3  ; ROM $1402: 11 E3 14
        CALL $1494  ; ROM $1405: CD 94 14
        LD (HL),$CC  ; ROM $1408: 36 CC
        CALL $1232  ; ROM $140A: CD 32 12
        RET C  ; ROM $140D: D8
        LD HL,$206D  ; ROM $140E: 21 6D 20
        LD A,(HL)  ; ROM $1411: 7E
        AND A  ; ROM $1412: A7
        RET M  ; ROM $1413: F8
        CALL $1422  ; ROM $1414: CD 22 14
        ADD A,$66  ; ROM $1417: C6 66
        LD DE,$14E3  ; ROM $1419: 11 E3 14
        CALL $14A0  ; ROM $141C: CD A0 14
        LD (HL),$DC  ; ROM $141F: 36 DC
        RET  ; ROM $1421: C9
NATIVE_1422:
        LD DE,$000A  ; ROM $1422: 11 0A 00
        ADD HL,DE  ; ROM $1425: 19
        PUSH HL  ; ROM $1426: E5
        LD A,$3C  ; ROM $1427: 3E 3C
        LD ($2032),A  ; ROM $1429: 32 32 20
        CALL $1232  ; ROM $142C: CD 32 12
        AND $0F  ; ROM $142F: E6 0F
        LD C,A  ; ROM $1431: 4F
        LD B,$00  ; ROM $1432: 06 00
        LD HL,$14BB  ; ROM $1434: 21 BB 14
        ADD HL,BC  ; ROM $1437: 09
        LD A,(HL)  ; ROM $1438: 7E
        LD C,A  ; ROM $1439: 4F
        CP $07  ; ROM $143A: FE 07
        JP NZ,$1442  ; ROM $143C: C2 42 14
        LD ($2081),A  ; ROM $143F: 32 81 20
NATIVE_1442:
        LD HL,$14CB  ; ROM $1442: 21 CB 14
        ADD HL,BC  ; ROM $1445: 09
        ADD HL,BC  ; ROM $1446: 09
        LD E,(HL)  ; ROM $1447: 5E
        INC HL  ; ROM $1448: 23
        LD D,(HL)  ; ROM $1449: 56
        POP HL  ; ROM $144A: E1
        LD (HL),D  ; ROM $144B: 72
        DEC HL  ; ROM $144C: 2B
        LD (HL),E  ; ROM $144D: 73
        DEC HL  ; ROM $144E: 2B
        LD (HL),B  ; ROM $144F: 70
        DEC HL  ; ROM $1450: 2B
        CP $05  ; ROM $1451: FE 05
        RET P  ; ROM $1453: F0
        LD A,($201E)  ; ROM $1454: 3A 1E 20
        AND $3F  ; ROM $1457: E6 3F
        RET  ; ROM $1459: C9
NATIVE_145A:
        LD (HL),A  ; ROM $145A: 77
        DEC HL  ; ROM $145B: 2B
        PUSH HL  ; ROM $145C: E5
        LD HL,$14DB  ; ROM $145D: 21 DB 14
        ADD HL,BC  ; ROM $1460: 09
        LD A,(HL)  ; ROM $1461: 7E
        EX (SP),HL  ; ROM $1462: E3
        LD (HL),A  ; ROM $1463: 77
        DEC HL  ; ROM $1464: 2B
        EX (SP),HL  ; ROM $1465: E3
        EX DE,HL  ; ROM $1466: EB
        ADD HL,BC  ; ROM $1467: 09
        ADD HL,BC  ; ROM $1468: 09
        LD E,(HL)  ; ROM $1469: 5E
        INC HL  ; ROM $146A: 23
        LD D,(HL)  ; ROM $146B: 56
        POP HL  ; ROM $146C: E1
        LD (HL),D  ; ROM $146D: 72
        DEC HL  ; ROM $146E: 2B
        LD (HL),E  ; ROM $146F: 73
        DEC HL  ; ROM $1470: 2B
        RET  ; ROM $1471: C9
NATIVE_1472:
        EX DE,HL  ; ROM $1472: EB
        LD HL,$06DC  ; ROM $1473: 21 DC 06
        ADD HL,BC  ; ROM $1476: 09
        LD A,(HL)  ; ROM $1477: 7E
        DEC A  ; ROM $1478: 3D
        EX DE,HL  ; ROM $1479: EB
        LD (HL),A  ; ROM $147A: 77
        DEC HL  ; ROM $147B: 2B
NATIVE_147C:
        LD A,($2009)  ; ROM $147C: 3A 09 20
        CP $03  ; ROM $147F: FE 03
        JP NC,$1485  ; ROM $1481: D2 85 14
        INC A  ; ROM $1484: 3C
NATIVE_1485:
        CP $07  ; ROM $1485: FE 07
        JP C,$148C  ; ROM $1487: DA 8C 14
        LD A,$06  ; ROM $148A: 3E 06
NATIVE_148C:
        DEC C  ; ROM $148C: 0D
        JP P,$1492  ; ROM $148D: F2 92 14
        ADD A,$03  ; ROM $1490: C6 03
NATIVE_1492:
        INC C  ; ROM $1492: 0C
        RET  ; ROM $1493: C9
NATIVE_1494:
        CALL $145A  ; ROM $1494: CD 5A 14
        LD (HL),$01  ; ROM $1497: 36 01
        DEC HL  ; ROM $1499: 2B
        CALL $147C  ; ROM $149A: CD 7C 14
        JP $14A8  ; ROM $149D: C3 A8 14
NATIVE_14A0:
        CALL $145A  ; ROM $14A0: CD 5A 14
        CALL $1472  ; ROM $14A3: CD 72 14
        CPL  ; ROM $14A6: 2F
        INC A  ; ROM $14A7: 3C
NATIVE_14A8:
        LD (HL),A  ; ROM $14A8: 77
        DEC HL  ; ROM $14A9: 2B
        LD (HL),C  ; ROM $14AA: 71
        DEC HL  ; ROM $14AB: 2B
        DEC C  ; ROM $14AC: 0D
        RET P  ; ROM $14AD: F0
NATIVE_14AE:
        LD DE,$20B8  ; ROM $14AE: 11 B8 20
        LD A,(DE)  ; ROM $14B1: 1A
        AND A  ; ROM $14B2: A7
        RET NZ  ; ROM $14B3: C0
        LD A,$04  ; ROM $14B4: 3E 04
        LD (DE),A  ; ROM $14B6: 12
        LD ($203A),A  ; ROM $14B7: 32 3A 20
        RET  ; ROM $14BA: C9
        DB $00,$00,$00,$01,$01,$01,$02,$02,$03,$03,$04,$05 ; ROM $14BB unclassified
        DB $06,$06,$07,$07,$FE,$0B,$23,$07,$C3,$0A,$95,$07 ; ROM $14C7 unclassified
        DB $52,$0D,$2C,$0E,$D1,$08,$F5,$09,$01,$01,$01,$01 ; ROM $14D3 unclassified
        DB $01,$04,$02,$03,$66,$A4,$66,$A7,$66,$96,$66,$A0 ; ROM $14DF unclassified
        DB $66,$A8,$66,$97,$66,$A0,$66,$9E,$0C,$4A,$0C,$4D ; ROM $14EB unclassified
        DB $0C,$3C,$0C,$46,$0C,$4E,$0C,$3D,$0C,$46,$0C,$44 ; ROM $14F7 unclassified
NATIVE_1503:
        LD A,$03  ; ROM $1503: 3E 03
NATIVE_1505:
        PUSH AF  ; ROM $1505: F5
        CALL $120E  ; ROM $1506: CD 0E 12
        LD A,(HL)  ; ROM $1509: 7E
        AND A  ; ROM $150A: A7
        JP P,$155E  ; ROM $150B: F2 5E 15
        PUSH HL  ; ROM $150E: E5
        LD D,A  ; ROM $150F: 57
        INC HL  ; ROM $1510: 23
        LD E,(HL)  ; ROM $1511: 5E
        LD BC,$0007  ; ROM $1512: 01 07 00
        ADD HL,BC  ; ROM $1515: 09
        LD C,E  ; ROM $1516: 4B
        PUSH HL  ; ROM $1517: E5
        LD HL,$1584  ; ROM $1518: 21 84 15
        AND $02  ; ROM $151B: E6 02
        JP Z,$1523  ; ROM $151D: CA 23 15
        LD HL,$158C  ; ROM $1520: 21 8C 15
NATIVE_1523:
        ADD HL,BC  ; ROM $1523: 09
        LD A,(HL)  ; ROM $1524: 7E
        POP HL  ; ROM $1525: E1
        CP (HL)  ; ROM $1526: BE
        JP NC,$1538  ; ROM $1527: D2 38 15
        LD (HL),$00  ; ROM $152A: 36 00
        EX (SP),HL  ; ROM $152C: E3
        LD A,(HL)  ; ROM $152D: 7E
        AND $02  ; ROM $152E: E6 02
        JP Z,$1537  ; ROM $1530: CA 37 15
        LD A,(HL)  ; ROM $1533: 7E
        AND $F7  ; ROM $1534: E6 F7
        LD (HL),A  ; ROM $1536: 77
NATIVE_1537:
        EX (SP),HL  ; ROM $1537: E3
NATIVE_1538:
        EX DE,HL  ; ROM $1538: EB
        LD A,H  ; ROM $1539: 7C
        LD HL,$1564  ; ROM $153A: 21 64 15
        AND $02  ; ROM $153D: E6 02
        JP Z,$1545  ; ROM $153F: CA 45 15
        LD HL,$1574  ; ROM $1542: 21 74 15
NATIVE_1545:
        ADD HL,BC  ; ROM $1545: 09
        ADD HL,BC  ; ROM $1546: 09
        LD A,(HL)  ; ROM $1547: 7E
        INC HL  ; ROM $1548: 23
        LD H,(HL)  ; ROM $1549: 66
        LD L,A  ; ROM $154A: 6F
        LD A,(DE)  ; ROM $154B: 1A
NATIVE_154C:
        INC HL  ; ROM $154C: 23
        INC HL  ; ROM $154D: 23
        CP (HL)  ; ROM $154E: BE
        INC HL  ; ROM $154F: 23
        JP NC,$154C  ; ROM $1550: D2 4C 15
        LD C,(HL)  ; ROM $1553: 4E
        INC HL  ; ROM $1554: 23
        LD B,(HL)  ; ROM $1555: 46
        EX DE,HL  ; ROM $1556: EB
        INC HL  ; ROM $1557: 23
        DI  ; ROM $1558: F3
        LD (HL),C  ; ROM $1559: 71
        INC HL  ; ROM $155A: 23
        LD (HL),B  ; ROM $155B: 70
        EI  ; ROM $155C: FB
        POP HL  ; ROM $155D: E1
NATIVE_155E:
        POP AF  ; ROM $155E: F1
        DEC A  ; ROM $155F: 3D
        JP P,$1505  ; ROM $1560: F2 05 15
        RET  ; ROM $1563: C9
        DB $CE,$15,$1F,$16,$B9,$15,$0D,$16,$92,$15,$A4,$15 ; ROM $1564 unclassified
        DB $E0,$15,$F5,$15,$DA,$15,$2B,$16,$C5,$15,$19,$16 ; ROM $1570 unclassified
        DB $9E,$15,$B3,$15,$EF,$15,$FE,$15,$04,$08,$08,$0C ; ROM $157C unclassified
        DB $14,$17,$3A,$25,$14,$14,$0F,$14,$19,$19,$14,$1E ; ROM $1588 unclassified
        DB $05,$52,$0D,$0A,$8C,$0D,$0F,$C6,$0D,$FF,$8C,$0D ; ROM $1594 unclassified
        DB $05,$E4,$06,$FF,$29,$0D,$06,$2C,$0E,$0A,$9D,$0E ; ROM $15A0 unclassified
        DB $0F,$02,$0F,$13,$9D,$0E,$FF,$2C,$0E,$05,$E4,$06 ; ROM $15AC unclassified
        DB $FF,$00,$0E,$02,$C3,$0A,$04,$FB,$0A,$06,$33,$0B ; ROM $15B8 unclassified
        DB $FF,$6B,$0B,$05,$E4,$06,$0F,$A3,$0B,$FF,$C3,$0B ; ROM $15C4 unclassified
        DB $01,$FE,$0B,$02,$24,$0C,$03,$4A,$0C,$FF,$70,$0C ; ROM $15D0 unclassified
        DB $05,$E4,$06,$FF,$E6,$0B,$05,$65,$09,$19,$9D,$09 ; ROM $15DC unclassified
        DB $1E,$D1,$08,$37,$15,$09,$FF,$65,$09,$05,$E4,$06 ; ROM $15E8 unclassified
        DB $FF,$DE,$09,$0E,$27,$0A,$19,$F5,$09,$FF,$27,$0A ; ROM $15F4 unclassified
        DB $05,$E4,$06,$0F,$F5,$09,$14,$65,$0A,$19,$91,$0A ; ROM $1600 unclassified
        DB $FF,$AF,$0A,$03,$95,$07,$06,$EF,$07,$09,$49,$08 ; ROM $160C unclassified
        DB $FF,$EF,$07,$05,$E4,$06,$FF,$A3,$08,$02,$49,$07 ; ROM $1618 unclassified
        DB $04,$6F,$07,$06,$49,$07,$FF,$23,$07,$05,$E4,$06 ; ROM $1624 unclassified
        DB $FF,$12,$07 ; ROM $1630 unclassified
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
        DB $0C,$0C,$4B,$1A,$B4,$3E,$02,$1E,$00,$04,$64,$16 ; ROM $166A unclassified
CMD_1676_SET_MODE:
        DB $02 ; SET_MODE
        DB $1E ; inline B
CMD_1678_FRAME_SCHEDULER:
        DB $00 ; FRAME_SCHEDULER
        DB $06,$01,$08,$02,$78,$00,$01,$09,$02,$3C,$00,$0C ; ROM $1679 unclassified
        DB $0D,$4B,$1A,$09,$30,$05,$06,$B9,$20,$05,$01,$0D ; ROM $1685 unclassified
        DB $20,$05,$01,$81,$20,$05,$01,$35,$20,$00,$05,$00 ; ROM $1691 unclassified
        DB $0D,$20,$05,$00,$37,$20,$05,$00,$38,$20,$0C,$10 ; ROM $169D unclassified
        DB $4B,$1A,$00,$24,$0C,$10,$4B,$1A,$10,$24,$0C,$10 ; ROM $16A9 unclassified
        DB $4B,$1A,$A0,$3E,$0C,$10,$4B,$1A,$B0,$3E,$08,$06 ; ROM $16B5 unclassified
        DB $20,$A0,$3E,$01,$05,$08,$0B,$20,$00,$24,$01,$06 ; ROM $16C1 unclassified
        DB $01,$04,$08,$1C,$20,$1B,$24,$02,$1E,$00,$0A,$40 ; ROM $16CD unclassified
        DB $20,$0A,$4F,$20,$0A,$5E,$20,$0A,$6D,$20,$02,$0F ; ROM $16D9 unclassified
        DB $00,$09,$00,$09,$01,$02,$F0,$00,$04,$33,$16 ; ROM $16E5 unclassified
NATIVE_16F0:
        LD HL,$20B2  ; ROM $16F0: 21 B2 20
        IN A,($02)  ; ROM $16F3: DB 02
        CPL  ; ROM $16F5: 2F
        AND $80  ; ROM $16F6: E6 80
        LD B,A  ; ROM $16F8: 47
        XOR (HL)  ; ROM $16F9: AE
        RET Z  ; ROM $16FA: C8
        LD (HL),B  ; ROM $16FB: 70
        LD A,B  ; ROM $16FC: 78
        AND A  ; ROM $16FD: A7
        RET Z  ; ROM $16FE: C8
        LD A,($20B5)  ; ROM $16FF: 3A B5 20
        AND A  ; ROM $1702: A7
        RET NZ  ; ROM $1703: C0
        LD HL,$20B9  ; ROM $1704: 21 B9 20
        LD A,(HL)  ; ROM $1707: 7E
        AND A  ; ROM $1708: A7
        JP Z,$189F  ; ROM $1709: CA 9F 18
        DEC (HL)  ; ROM $170C: 35
        JP NZ,$1718  ; ROM $170D: C2 18 17
        LD ($20BA),A  ; ROM $1710: 32 BA 20
        LD A,$04  ; ROM $1713: 3E 04
        LD ($2036),A  ; ROM $1715: 32 36 20
NATIVE_1718:
        LD B,$04  ; ROM $1718: 06 04
        CALL $122B  ; ROM $171A: CD 2B 12
        LD A,$18  ; ROM $171D: 3E 18
        OUT ($03),A  ; ROM $171F: D3 03
        LD A,$02  ; ROM $1721: 3E 02
        LD ($2034),A  ; ROM $1723: 32 34 20
        LD HL,$1A4B  ; ROM $1726: 21 4B 1A
        LD DE,$2F86  ; ROM $1729: 11 86 2F
        LD A,$13  ; ROM $172C: 3E 13
        CALL $0132  ; ROM $172E: CD 32 01
        LD A,($2015)  ; ROM $1731: 3A 15 20
        CP $0F  ; ROM $1734: FE 0F
        JP C,$17D6  ; ROM $1736: DA D6 17
        CP $59  ; ROM $1739: FE 59
        JP C,$1748  ; ROM $173B: DA 48 17
        CP $69  ; ROM $173E: FE 69
        JP C,$17D6  ; ROM $1740: DA D6 17
        CP $D1  ; ROM $1743: FE D1
        JP NC,$17D6  ; ROM $1745: D2 D6 17
NATIVE_1748:
        SUB $03  ; ROM $1748: D6 03
        LD D,A  ; ROM $174A: 57
        LD A,($2014)  ; ROM $174B: 3A 14 20
        CP $03  ; ROM $174E: FE 03
        JP C,$17D6  ; ROM $1750: DA D6 17
        CP $FC  ; ROM $1753: FE FC
        JP NC,$17D6  ; ROM $1755: D2 D6 17
        SUB $03  ; ROM $1758: D6 03
        LD E,A  ; ROM $175A: 5F
        PUSH DE  ; ROM $175B: D5
        PUSH AF  ; ROM $175C: F5
        CALL $01B1  ; ROM $175D: CD B1 01
        EX DE,HL  ; ROM $1760: EB
        LD A,$07  ; ROM $1761: 3E 07
        LD DE,$0000  ; ROM $1763: 11 00 00
        LD BC,$001F  ; ROM $1766: 01 1F 00
NATIVE_1769:
        PUSH AF  ; ROM $1769: F5
        LD A,(HL)  ; ROM $176A: 7E
        OR D  ; ROM $176B: B2
        LD D,A  ; ROM $176C: 57
        LD A,L  ; ROM $176D: 7D
        INC HL  ; ROM $176E: 23
        AND $1F  ; ROM $176F: E6 1F
        LD A,B  ; ROM $1771: 78
        JP Z,$1776  ; ROM $1772: CA 76 17
        LD A,(HL)  ; ROM $1775: 7E
NATIVE_1776:
        OR E  ; ROM $1776: B3
        LD E,A  ; ROM $1777: 5F
        ADD HL,BC  ; ROM $1778: 09
        POP AF  ; ROM $1779: F1
        DEC A  ; ROM $177A: 3D
        JP NZ,$1769  ; ROM $177B: C2 69 17
        PUSH DE  ; ROM $177E: D5
        CALL $18B6  ; ROM $177F: CD B6 18
        POP HL  ; ROM $1782: E1
        POP AF  ; ROM $1783: F1
        AND $07  ; ROM $1784: E6 07
        INC A  ; ROM $1786: 3C
NATIVE_1787:
        ADD HL,HL  ; ROM $1787: 29
        DEC A  ; ROM $1788: 3D
        JP NZ,$1787  ; ROM $1789: C2 87 17
        LD A,H  ; ROM $178C: 7C
        AND $7F  ; ROM $178D: E6 7F
        POP DE  ; ROM $178F: D1
        LD HL,$20B3  ; ROM $1790: 21 B3 20
        JP Z,$17DC  ; ROM $1793: CA DC 17
        LD (HL),$00  ; ROM $1796: 36 00
        LD A,D  ; ROM $1798: 7A
        CP $59  ; ROM $1799: FE 59
        JP C,$1802  ; ROM $179B: DA 02 18
        CP $B3  ; ROM $179E: FE B3
        JP C,$1815  ; ROM $17A0: DA 15 18
        LD BC,$FFFF  ; ROM $17A3: 01 FF FF
        LD A,B  ; ROM $17A6: 78
NATIVE_17A7:
        ADD A,$40  ; ROM $17A7: C6 40
        CP E  ; ROM $17A9: BB
        INC BC  ; ROM $17AA: 03
        JP C,$17A7  ; ROM $17AB: DA A7 17
        LD HL,$20AD  ; ROM $17AE: 21 AD 20
        ADD HL,BC  ; ROM $17B1: 09
        LD A,(HL)  ; ROM $17B2: 7E
        AND A  ; ROM $17B3: A7
        RET NZ  ; ROM $17B4: C0
        LD ($20B7),A  ; ROM $17B5: 32 B7 20
        LD A,$10  ; ROM $17B8: 3E 10
        LD (HL),A  ; ROM $17BA: 77
        CALL $18A9  ; ROM $17BB: CD A9 18
        LD A,$04  ; ROM $17BE: 3E 04
        LD ($2033),A  ; ROM $17C0: 32 33 20
        LD HL,$1922  ; ROM $17C3: 21 22 19
        ADD HL,BC  ; ROM $17C6: 09
        ADD HL,BC  ; ROM $17C7: 09
        ADD HL,BC  ; ROM $17C8: 09
        LD E,(HL)  ; ROM $17C9: 5E
        INC HL  ; ROM $17CA: 23
        LD D,(HL)  ; ROM $17CB: 56
        EX DE,HL  ; ROM $17CC: EB
        LD DE,$0D03  ; ROM $17CD: 11 03 0D
        LD BC,$1002  ; ROM $17D0: 01 02 10
        JP $0FF9  ; ROM $17D3: C3 F9 0F
NATIVE_17D6:
        CALL $18B6  ; ROM $17D6: CD B6 18
        LD HL,$20B3  ; ROM $17D9: 21 B3 20
NATIVE_17DC:
        LD A,(HL)  ; ROM $17DC: 7E
        INC (HL)  ; ROM $17DD: 34
        LD HL,$1AA0  ; ROM $17DE: 21 A0 1A
        LD DE,$2F86  ; ROM $17E1: 11 86 2F
        AND A  ; ROM $17E4: A7
        LD A,$07  ; ROM $17E5: 3E 07
        JP Z,$17EC  ; ROM $17E7: CA EC 17
        LD A,$0D  ; ROM $17EA: 3E 0D
NATIVE_17EC:
        CALL $0132  ; ROM $17EC: CD 32 01
        CALL $1232  ; ROM $17EF: CD 32 12
        RRA  ; ROM $17F2: 1F
        LD HL,$1AAD  ; ROM $17F3: 21 AD 1A
        LD A,$05  ; ROM $17F6: 3E 05
        JP C,$17FF  ; ROM $17F8: DA FF 17
        LD HL,$1AB2  ; ROM $17FB: 21 B2 1A
        INC A  ; ROM $17FE: 3C
NATIVE_17FF:
        DB $C3 ; ROM $17FF unclassified

        ORG $1800
; Device desertgu.e, SHA1 202433dfb174901bd3b91e843d9d697a8333ef9e
        DB $32,$01 ; ROM $1800 unclassified
NATIVE_1802:
        LD HL,$2040  ; ROM $1802: 21 40 20
        CALL $188C  ; ROM $1805: CD 8C 18
        JP C,$1825  ; ROM $1808: DA 25 18
        LD HL,$204F  ; ROM $180B: 21 4F 20
        CALL $188C  ; ROM $180E: CD 8C 18
        JP C,$1825  ; ROM $1811: DA 25 18
        RET  ; ROM $1814: C9
NATIVE_1815:
        LD HL,$205E  ; ROM $1815: 21 5E 20
        CALL $188C  ; ROM $1818: CD 8C 18
        JP C,$1825  ; ROM $181B: DA 25 18
        LD HL,$206D  ; ROM $181E: 21 6D 20
        CALL $188C  ; ROM $1821: CD 8C 18
        RET NC  ; ROM $1824: D0
NATIVE_1825:
        PUSH HL  ; ROM $1825: E5
        PUSH DE  ; ROM $1826: D5
        CALL $121A  ; ROM $1827: CD 1A 12
        LD A,$03  ; ROM $182A: 3E 03
        LD (HL),A  ; ROM $182C: 77
        LD (DE),A  ; ROM $182D: 12
        POP DE  ; ROM $182E: D1
        INC HL  ; ROM $182F: 23
        EX (SP),HL  ; ROM $1830: E3
        DEC HL  ; ROM $1831: 2B
        DEC HL  ; ROM $1832: 2B
        LD C,(HL)  ; ROM $1833: 4E
        INC HL  ; ROM $1834: 23
        LD E,(HL)  ; ROM $1835: 5E
        INC HL  ; ROM $1836: 23
        LD A,(HL)  ; ROM $1837: 7E
        SUB E  ; ROM $1838: 93
        LD E,A  ; ROM $1839: 5F
        INC HL  ; ROM $183A: 23
        INC HL  ; ROM $183B: 23
        INC HL  ; ROM $183C: 23
        LD D,(HL)  ; ROM $183D: 56
        INC HL  ; ROM $183E: 23
        LD A,(HL)  ; ROM $183F: 7E
        SUB D  ; ROM $1840: 92
        SUB $68  ; ROM $1841: D6 68
        JP NC,$1848  ; ROM $1843: D2 48 18
        ADD A,$5C  ; ROM $1846: C6 5C
NATIVE_1848:
        CP $20  ; ROM $1848: FE 20
        LD A,(HL)  ; ROM $184A: 7E
        JP C,$1854  ; ROM $184B: DA 54 18
        SUB $10  ; ROM $184E: D6 10
        LD D,A  ; ROM $1850: 57
        JP $1858  ; ROM $1851: C3 58 18
NATIVE_1854:
        LD D,A  ; ROM $1854: 57
        ADD A,$10  ; ROM $1855: C6 10
        LD (HL),A  ; ROM $1857: 77
NATIVE_1858:
        EX (SP),HL  ; ROM $1858: E3
        CALL $01B1  ; ROM $1859: CD B1 01
        LD (HL),C  ; ROM $185C: 71
        INC HL  ; ROM $185D: 23
        LD (HL),E  ; ROM $185E: 73
        INC HL  ; ROM $185F: 23
        LD (HL),D  ; ROM $1860: 72
        INC HL  ; ROM $1861: 23
        PUSH HL  ; ROM $1862: E5
        LD HL,$192E  ; ROM $1863: 21 2E 19
        ADD HL,BC  ; ROM $1866: 09
        EX DE,HL  ; ROM $1867: EB
        LD A,(DE)  ; ROM $1868: 1A
        CALL $18A9  ; ROM $1869: CD A9 18
        POP BC  ; ROM $186C: C1
        CALL $1033  ; ROM $186D: CD 33 10
        LD A,$30  ; ROM $1870: 3E 30
        LD (BC),A  ; ROM $1872: 02
        INC BC  ; ROM $1873: 03
        LD A,$40  ; ROM $1874: 3E 40
        LD (BC),A  ; ROM $1876: 02
        POP HL  ; ROM $1877: E1
        INC HL  ; ROM $1878: 23
        LD (HL),$00  ; ROM $1879: 36 00
        DEC HL  ; ROM $187B: 2B
        DEC HL  ; ROM $187C: 2B
        LD (HL),$01  ; ROM $187D: 36 01
        DEC HL  ; ROM $187F: 2B
        DEC HL  ; ROM $1880: 2B
        DEC HL  ; ROM $1881: 2B
        DEC HL  ; ROM $1882: 2B
        LD (HL),$00  ; ROM $1883: 36 00
        DEC HL  ; ROM $1885: 2B
        DEC HL  ; ROM $1886: 2B
        LD A,(HL)  ; ROM $1887: 7E
        OR $02  ; ROM $1888: F6 02
        LD (HL),A  ; ROM $188A: 77
        RET  ; ROM $188B: C9
NATIVE_188C:
        LD A,(HL)  ; ROM $188C: 7E
        AND A  ; ROM $188D: A7
        RET P  ; ROM $188E: F0
        AND $02  ; ROM $188F: E6 02
        RET NZ  ; ROM $1891: C0
        INC HL  ; ROM $1892: 23
        INC HL  ; ROM $1893: 23
        INC HL  ; ROM $1894: 23
        LD A,(HL)  ; ROM $1895: 7E
        SUB $08  ; ROM $1896: D6 08
        CP E  ; ROM $1898: BB
        RET NC  ; ROM $1899: D0
        ADD A,$28  ; ROM $189A: C6 28
        CP E  ; ROM $189C: BB
        CCF  ; ROM $189D: 3F
        RET  ; ROM $189E: C9
NATIVE_189F:
        LD A,$03  ; ROM $189F: 3E 03
        LD ($2034),A  ; ROM $18A1: 32 34 20
        LD B,$02  ; ROM $18A4: 06 02
        JP $122B  ; ROM $18A6: C3 2B 12
NATIVE_18A9:
        LD HL,$200A  ; ROM $18A9: 21 0A 20
        ADD A,(HL)  ; ROM $18AC: 86
        DAA  ; ROM $18AD: 27
        LD (HL),A  ; ROM $18AE: 77
        DEC HL  ; ROM $18AF: 2B
        LD A,$00  ; ROM $18B0: 3E 00
        ADC A,(HL)  ; ROM $18B2: 8E
        DAA  ; ROM $18B3: 27
        LD (HL),A  ; ROM $18B4: 77
        RET  ; ROM $18B5: C9
NATIVE_18B6:
        LD A,($2014)  ; ROM $18B6: 3A 14 20
        CP $03  ; ROM $18B9: FE 03
        JP NC,$18C0  ; ROM $18BB: D2 C0 18
        LD A,$03  ; ROM $18BE: 3E 03
NATIVE_18C0:
        CP $FC  ; ROM $18C0: FE FC
        JP C,$18C7  ; ROM $18C2: DA C7 18
        LD A,$FC  ; ROM $18C5: 3E FC
NATIVE_18C7:
        SUB $03  ; ROM $18C7: D6 03
        LD L,A  ; ROM $18C9: 6F
        AND $07  ; ROM $18CA: E6 07
        INC A  ; ROM $18CC: 3C
        LD C,A  ; ROM $18CD: 4F
        LD A,($2015)  ; ROM $18CE: 3A 15 20
        SUB $03  ; ROM $18D1: D6 03
        JP NC,$18D8  ; ROM $18D3: D2 D8 18
        LD A,$03  ; ROM $18D6: 3E 03
NATIVE_18D8:
        LD H,A  ; ROM $18D8: 67
        LD ($20B4),HL  ; ROM $18D9: 22 B4 20
        EX DE,HL  ; ROM $18DC: EB
        CALL $01B1  ; ROM $18DD: CD B1 01
        LD A,$0A  ; ROM $18E0: 3E 0A
        LD ($2039),A  ; ROM $18E2: 32 39 20
        LD B,$80  ; ROM $18E5: 06 80
NATIVE_18E7:
        LD HL,$191C  ; ROM $18E7: 21 1C 19
        LD A,$06  ; ROM $18EA: 3E 06
NATIVE_18EC:
        PUSH AF  ; ROM $18EC: F5
        PUSH HL  ; ROM $18ED: E5
        LD L,(HL)  ; ROM $18EE: 6E
        LD H,$00  ; ROM $18EF: 26 00
        LD A,C  ; ROM $18F1: 79
NATIVE_18F2:
        ADD HL,HL  ; ROM $18F2: 29
        DEC A  ; ROM $18F3: 3D
        JP NZ,$18F2  ; ROM $18F4: C2 F2 18
        EX DE,HL  ; ROM $18F7: EB
        DEC B  ; ROM $18F8: 05
        JP M,$1906  ; ROM $18F9: FA 06 19
        LD A,E  ; ROM $18FC: 7B
        OR (HL)  ; ROM $18FD: B6
        LD (HL),A  ; ROM $18FE: 77
        INC HL  ; ROM $18FF: 23
        LD A,D  ; ROM $1900: 7A
        OR (HL)  ; ROM $1901: B6
        LD (HL),A  ; ROM $1902: 77
        JP $190F  ; ROM $1903: C3 0F 19
NATIVE_1906:
        LD A,E  ; ROM $1906: 7B
        CPL  ; ROM $1907: 2F
        AND (HL)  ; ROM $1908: A6
        LD (HL),A  ; ROM $1909: 77
        INC HL  ; ROM $190A: 23
        LD A,D  ; ROM $190B: 7A
        CPL  ; ROM $190C: 2F
        AND (HL)  ; ROM $190D: A6
        LD (HL),A  ; ROM $190E: 77
NATIVE_190F:
        LD DE,$001F  ; ROM $190F: 11 1F 00
        ADD HL,DE  ; ROM $1912: 19
        EX DE,HL  ; ROM $1913: EB
        POP HL  ; ROM $1914: E1
        INC HL  ; ROM $1915: 23
        POP AF  ; ROM $1916: F1
        DEC A  ; ROM $1917: 3D
        JP NZ,$18EC  ; ROM $1918: C2 EC 18
        RET  ; ROM $191B: C9
        DB $44,$20,$1A,$18,$20,$44,$24,$3B,$1B,$8C,$3C,$10 ; ROM $191C unclassified
        DB $54,$3B,$1A,$9C,$3C,$10,$50,$30,$20,$20,$20,$20 ; ROM $1928 unclassified
        DB $20,$20 ; ROM $1934 unclassified
NATIVE_1936:
        LD A,($2081)  ; ROM $1936: 3A 81 20
        AND A  ; ROM $1939: A7
        RET Z  ; ROM $193A: C8
        LD DE,$20B1  ; ROM $193B: 11 B1 20
        LD A,(DE)  ; ROM $193E: 1A
        AND A  ; ROM $193F: A7
        RET NZ  ; ROM $1940: C0
        CPL  ; ROM $1941: 2F
        LD (DE),A  ; ROM $1942: 12
        LD HL,$1A4B  ; ROM $1943: 21 4B 1A
        LD DE,$3EA7  ; ROM $1946: 11 A7 3E
        LD A,$13  ; ROM $1949: 3E 13
        CALL $0132  ; ROM $194B: CD 32 01
        LD HL,$1965  ; ROM $194E: 21 65 19
NATIVE_1951:
        LD E,(HL)  ; ROM $1951: 5E
        INC HL  ; ROM $1952: 23
        LD D,(HL)  ; ROM $1953: 56
        INC HL  ; ROM $1954: 23
        LD A,D  ; ROM $1955: 7A
        OR E  ; ROM $1956: B3
        RET Z  ; ROM $1957: C8
        PUSH DE  ; ROM $1958: D5
        LD E,(HL)  ; ROM $1959: 5E
        INC HL  ; ROM $195A: 23
        LD D,(HL)  ; ROM $195B: 56
        INC HL  ; ROM $195C: 23
        EX (SP),HL  ; ROM $195D: E3
        CALL $0FF4  ; ROM $195E: CD F4 0F
        POP HL  ; ROM $1961: E1
        JP $1951  ; ROM $1962: C3 51 19
        DB $96,$0C,$24,$3B,$B3,$0C,$8C,$3C,$D5,$0C,$54,$3B ; ROM $1965 unclassified
        DB $F1,$0C,$9C,$3C,$00,$00 ; ROM $1971 unclassified
NATIVE_1977:
        LD HL,$20B6  ; ROM $1977: 21 B6 20
        LD A,(HL)  ; ROM $197A: 7E
        AND A  ; ROM $197B: A7
        JP NZ,$19AF  ; ROM $197C: C2 AF 19
        INC (HL)  ; ROM $197F: 34
        IN A,($02)  ; ROM $1980: DB 02
        RRCA  ; ROM $1982: 0F
        RRCA  ; ROM $1983: 0F
        RRCA  ; ROM $1984: 0F
        RRCA  ; ROM $1985: 0F
        AND $03  ; ROM $1986: E6 03
        LD C,A  ; ROM $1988: 4F
        LD B,$00  ; ROM $1989: 06 00
        LD HL,$19FF  ; ROM $198B: 21 FF 19
        ADD HL,BC  ; ROM $198E: 09
        LD A,($2009)  ; ROM $198F: 3A 09 20
        CP (HL)  ; ROM $1992: BE
        JP C,$19AF  ; ROM $1993: DA AF 19
        LD HL,$1A02  ; ROM $1996: 21 02 1A
        ADD HL,BC  ; ROM $1999: 09
        LD A,(HL)  ; ROM $199A: 7E
        LD ($2008),A  ; ROM $199B: 32 08 20
        LD ($201F),A  ; ROM $199E: 32 1F 20
        LD HL,$10D8  ; ROM $19A1: 21 D8 10
        LD ($2012),HL  ; ROM $19A4: 22 12 20
        LD C,$07  ; ROM $19A7: 0E 07
        CALL $1A06  ; ROM $19A9: CD 06 1A
        JP $0132  ; ROM $19AC: C3 32 01
NATIVE_19AF:
        LD BC,$2009  ; ROM $19AF: 01 09 20
        LD HL,$201C  ; ROM $19B2: 21 1C 20
        LD DE,$10F2  ; ROM $19B5: 11 F2 10
        CALL $19F6  ; ROM $19B8: CD F6 19
        JP C,$19CD  ; ROM $19BB: DA CD 19
        LD HL,$2006  ; ROM $19BE: 21 06 20
        LD DE,$110C  ; ROM $19C1: 11 0C 11
        CALL $19F6  ; ROM $19C4: CD F6 19
        JP C,$19CD  ; ROM $19C7: DA CD 19
        LD DE,$1128  ; ROM $19CA: 11 28 11
NATIVE_19CD:
        EX DE,HL  ; ROM $19CD: EB
        LD ($2012),HL  ; ROM $19CE: 22 12 20
        LD HL,$2006  ; ROM $19D1: 21 06 20
        CALL $19F6  ; ROM $19D4: CD F6 19
        JP C,$19E0  ; ROM $19D7: DA E0 19
        LD HL,($2009)  ; ROM $19DA: 2A 09 20
        LD ($2006),HL  ; ROM $19DD: 22 06 20
NATIVE_19E0:
        LD A,$01  ; ROM $19E0: 3E 01
        LD ($2031),A  ; ROM $19E2: 32 31 20
        LD ($201F),A  ; ROM $19E5: 32 1F 20
        LD HL,($2009)  ; ROM $19E8: 2A 09 20
        LD ($201C),HL  ; ROM $19EB: 22 1C 20
        EX DE,HL  ; ROM $19EE: EB
        LD HL,$0000  ; ROM $19EF: 21 00 00
        LD ($2009),HL  ; ROM $19F2: 22 09 20
        RET  ; ROM $19F5: C9
NATIVE_19F6:
        LD A,(BC)  ; ROM $19F6: 0A
        CP (HL)  ; ROM $19F7: BE
        RET NZ  ; ROM $19F8: C0
        INC HL  ; ROM $19F9: 23
        INC BC  ; ROM $19FA: 03
        LD A,(BC)  ; ROM $19FB: 0A
        CP (HL)  ; ROM $19FC: BE
        DEC BC  ; ROM $19FD: 0B
        RET  ; ROM $19FE: C9
        DB $05,$07,$09,$30,$30,$30,$35 ; ROM $19FF unclassified
NATIVE_1A06:
        LD HL,$1A37  ; ROM $1A06: 21 37 1A
        LD B,$00  ; ROM $1A09: 06 00
        ADD HL,BC  ; ROM $1A0B: 09
        ADD HL,BC  ; ROM $1A0C: 09
        LD E,(HL)  ; ROM $1A0D: 5E
        INC HL  ; ROM $1A0E: 23
        LD D,(HL)  ; ROM $1A0F: 56
        IN A,($02)  ; ROM $1A10: DB 02
        RRCA  ; ROM $1A12: 0F
        RRCA  ; ROM $1A13: 0F
        AND $03  ; ROM $1A14: E6 03
        PUSH BC  ; ROM $1A16: C5
        LD HL,$1A2F  ; ROM $1A17: 21 2F 1A
        LD C,A  ; ROM $1A1A: 4F
        ADD HL,BC  ; ROM $1A1B: 09
        ADD HL,BC  ; ROM $1A1C: 09
        LD A,(HL)  ; ROM $1A1D: 7E
        INC HL  ; ROM $1A1E: 23
        LD H,(HL)  ; ROM $1A1F: 66
        LD L,A  ; ROM $1A20: 6F
        POP BC  ; ROM $1A21: C1
NATIVE_1A22:
        LD A,(HL)  ; ROM $1A22: 7E
        INC HL  ; ROM $1A23: 23
        AND A  ; ROM $1A24: A7
        JP P,$1A22  ; ROM $1A25: F2 22 1A
        DEC C  ; ROM $1A28: 0D
        JP P,$1A22  ; ROM $1A29: F2 22 1A
        AND $7F  ; ROM $1A2C: E6 7F
        RET  ; ROM $1A2E: C9
        DB $C3,$1A,$1B,$1B,$79,$1B,$D9,$1B,$08,$28,$08,$34 ; ROM $1A2F unclassified
        DB $B4,$3E,$04,$24,$15,$24,$A6,$3E,$06,$24,$A7,$3E ; ROM $1A3B unclassified
        DB $0B,$30,$0B,$30,$40,$40,$40,$40,$40,$40,$40,$40 ; ROM $1A47 unclassified
        DB $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$44 ; ROM $1A53 unclassified
        DB $45,$53,$45,$52,$54,$40,$47,$55,$4E,$00,$40,$40 ; ROM $1A5F unclassified
        DB $40,$40,$40,$32,$30,$30,$40,$42,$4F,$4E,$55,$53 ; ROM $1A6B unclassified
        DB $40,$40,$40,$40,$40,$31,$30,$30,$40,$55,$47,$48 ; ROM $1A77 unclassified
        DB $4A,$42,$55,$46,$4A,$41,$52,$47,$4A,$50,$4F,$57 ; ROM $1A83 unclassified
        DB $4A,$5A,$4F,$57,$4A,$42,$4F,$50,$4A,$57,$41,$4D ; ROM $1A8F unclassified
        DB $4A,$42,$41,$4D,$4A,$4D,$49,$53,$53,$45,$44,$40 ; ROM $1A9B unclassified
        DB $41,$47,$41,$49,$4E,$40,$44,$55,$4D,$4D,$59,$54 ; ROM $1AA7 unclassified
        DB $55,$52,$4B,$45,$59,$52,$45,$4C,$4F,$41,$44,$43 ; ROM $1AB3 unclassified
        DB $59,$43,$4C,$45,$84,$47,$41,$4D,$45,$84,$4F,$56 ; ROM $1ABF unclassified
        DB $45,$52,$8B,$49,$4E,$53,$45,$52,$54,$40,$43,$4F ; ROM $1ACB unclassified
        DB $49,$4E,$84,$54,$49,$4D,$45,$85,$53,$43,$4F,$52 ; ROM $1AD7 unclassified
        DB $45,$8A,$48,$49,$47,$48,$40,$53,$43,$4F,$52,$45 ; ROM $1AE3 unclassified
        DB $89,$4C,$41,$53,$54,$40,$47,$41,$4D,$45,$8D,$45 ; ROM $1AEF unclassified
        DB $58,$54,$45,$4E,$44,$45,$44,$40,$54,$49,$4D,$45 ; ROM $1AFB unclassified
        DB $89,$47,$45,$54,$40,$52,$45,$41,$44,$59,$89,$40 ; ROM $1B07 unclassified
        DB $40,$53,$48,$4F,$4F,$54,$40,$40,$84,$47,$41,$4D ; ROM $1B13 unclassified
        DB $45,$84,$4F,$56,$45,$52,$89,$45,$49,$4E,$57,$45 ; ROM $1B1F unclassified
        DB $52,$46,$45,$4E,$84,$5A,$45,$49,$54,$86,$50,$55 ; ROM $1B2B unclassified
        DB $4E,$4B,$54,$45,$86,$52,$45,$4B,$4F,$52,$44,$88 ; ROM $1B37 unclassified
        DB $45,$4E,$44,$53,$50,$49,$45,$4C,$91,$5A,$45,$49 ; ROM $1B43 unclassified
        DB $54,$56,$45,$52,$4C,$41,$45,$4E,$47,$45,$52,$55 ; ROM $1B4F unclassified
        DB $4E,$47,$8D,$46,$45,$52,$54,$49,$47,$40,$4D,$41 ; ROM $1B5B unclassified
        DB $43,$48,$45,$4E,$8D,$40,$40,$53,$43,$48,$49,$45 ; ROM $1B67 unclassified
        DB $53,$53,$45,$4E,$40,$40,$83,$46,$49,$4E,$81,$40 ; ROM $1B73 unclassified
        DB $8C,$4D,$45,$54,$54,$45,$5A,$40,$50,$49,$45,$43 ; ROM $1B7F unclassified
        DB $45,$85,$54,$45,$4D,$50,$53,$85,$53,$43,$4F,$52 ; ROM $1B8B unclassified
        DB $45,$8A,$48,$49,$47,$48,$40,$53,$43,$4F,$52,$45 ; ROM $1B97 unclassified
        DB $8C,$44,$45,$52,$4E,$49,$45,$52,$40,$43,$4F,$55 ; ROM $1BA3 unclassified
        DB $50,$8C,$50,$52,$4F,$4C,$4F,$4E,$47,$41,$54,$49 ; ROM $1BAF unclassified
        DB $4F,$4E,$8D,$50,$52,$45,$50,$41,$52,$45,$5A,$40 ; ROM $1BBB unclassified
        DB $56,$4F,$55,$53,$8D,$40,$40,$40,$40,$53,$48,$4F ; ROM $1BC7 unclassified
        DB $4F,$54,$40,$40,$40,$40,$84,$53,$50,$49,$4C,$84 ; ROM $1BD3 unclassified
        DB $53,$4C,$55,$54,$87,$49,$4E,$44,$4B,$41,$53,$54 ; ROM $1BDF unclassified
        DB $83,$54,$49,$44,$85,$50,$4F,$49,$4E,$54,$89,$54 ; ROM $1BEB unclassified
        DB $4F,$50,$40,$50,$4F,$49,$4E,$54,$8B,$53,$49,$44 ; ROM $1BF7 unclassified
        DB $53,$54,$45,$40,$53,$50,$49,$4C,$8A,$45,$4B,$53 ; ROM $1C03 unclassified
        DB $54,$52,$41,$40,$54,$49,$44,$85,$50,$41,$52,$41 ; ROM $1C0F unclassified
        DB $54,$85,$40,$53,$4B,$59,$44 ; ROM $1C1B unclassified
NATIVE_1C22:
        XOR A  ; ROM $1C22: AF
        LD ($2031),A  ; ROM $1C23: 32 31 20
        LD HL,($2019)  ; ROM $1C26: 2A 19 20
        LD ($2000),HL  ; ROM $1C29: 22 00 20
        RET  ; ROM $1C2C: C9
NATIVE_1C2D:
        LD HL,($2000)  ; ROM $1C2D: 2A 00 20
        INC HL  ; ROM $1C30: 23
        LD ($2000),HL  ; ROM $1C31: 22 00 20
        RET  ; ROM $1C34: C9
NATIVE_1C35:
        LD A,$08  ; ROM $1C35: 3E 08
        OUT ($03),A  ; ROM $1C37: D3 03
        LD DE,$2080  ; ROM $1C39: 11 80 20
        LD A,(DE)  ; ROM $1C3C: 1A
        AND $09  ; ROM $1C3D: E6 09
        LD (DE),A  ; ROM $1C3F: 12
        OUT ($07),A  ; ROM $1C40: D3 07
        RET  ; ROM $1C42: C9
NATIVE_1C43:
        LD A,$01  ; ROM $1C43: 3E 01
        LD ($2003),A  ; ROM $1C45: 32 03 20
        LD HL,$208D  ; ROM $1C48: 21 8D 20
        LD BC,$0008  ; ROM $1C4B: 01 08 00
        LD A,(HL)  ; ROM $1C4E: 7E
        ADD HL,BC  ; ROM $1C4F: 09
        OR (HL)  ; ROM $1C50: B6
        ADD HL,BC  ; ROM $1C51: 09
        OR (HL)  ; ROM $1C52: B6
        ADD HL,BC  ; ROM $1C53: 09
        OR (HL)  ; ROM $1C54: B6
        JP Z,$1C5E  ; ROM $1C55: CA 5E 1C
        LD A,$0A  ; ROM $1C58: 3E 0A
        LD ($2036),A  ; ROM $1C5A: 32 36 20
        RET  ; ROM $1C5D: C9
NATIVE_1C5E:
        LD HL,$20BA  ; ROM $1C5E: 21 BA 20
        LD A,(HL)  ; ROM $1C61: 7E
        INC (HL)  ; ROM $1C62: 34
        DEC A  ; ROM $1C63: 3D
        JP NZ,$1C7C  ; ROM $1C64: C2 7C 1C
        LD A,$03  ; ROM $1C67: 3E 03
NATIVE_1C69:
        PUSH AF  ; ROM $1C69: F5
        CALL $120E  ; ROM $1C6A: CD 0E 12
        LD A,(HL)  ; ROM $1C6D: 7E
        AND $BB  ; ROM $1C6E: E6 BB
        LD (HL),A  ; ROM $1C70: 77
        POP AF  ; ROM $1C71: F1
        DEC A  ; ROM $1C72: 3D
        JP P,$1C69  ; ROM $1C73: F2 69 1C
        LD A,$04  ; ROM $1C76: 3E 04
        LD ($2036),A  ; ROM $1C78: 32 36 20
        RET  ; ROM $1C7B: C9
NATIVE_1C7C:
        DEC A  ; ROM $1C7C: 3D
        JP NZ,$1C9B  ; ROM $1C7D: C2 9B 1C
        LD A,$5A  ; ROM $1C80: 3E 5A
        LD ($2036),A  ; ROM $1C82: 32 36 20
        LD HL,$1AB8  ; ROM $1C85: 21 B8 1A
        LD DE,$2804  ; ROM $1C88: 11 04 28
        LD A,$06  ; ROM $1C8B: 3E 06
        CALL $0167  ; ROM $1C8D: CD 67 01
        LD HL,$1ABE  ; ROM $1C90: 21 BE 1A
        LD DE,$3406  ; ROM $1C93: 11 06 34
        LD A,$05  ; ROM $1C96: 3E 05
        JP $0167  ; ROM $1C98: C3 67 01
NATIVE_1C9B:
        LD (HL),$00  ; ROM $1C9B: 36 00
        LD HL,$1A4B  ; ROM $1C9D: 21 4B 1A
        LD DE,$2804  ; ROM $1CA0: 11 04 28
        LD A,$06  ; ROM $1CA3: 3E 06
        CALL $0167  ; ROM $1CA5: CD 67 01
        LD DE,$3406  ; ROM $1CA8: 11 06 34
        LD A,$05  ; ROM $1CAB: 3E 05
        CALL $0167  ; ROM $1CAD: CD 67 01
        LD A,$03  ; ROM $1CB0: 3E 03
NATIVE_1CB2:
        PUSH AF  ; ROM $1CB2: F5
        CALL $120E  ; ROM $1CB3: CD 0E 12
        LD A,(HL)  ; ROM $1CB6: 7E
        OR $44  ; ROM $1CB7: F6 44
        LD (HL),A  ; ROM $1CB9: 77
        POP AF  ; ROM $1CBA: F1
        DEC A  ; ROM $1CBB: 3D
        JP P,$1CB2  ; ROM $1CBC: F2 B2 1C
        LD A,$06  ; ROM $1CBF: 3E 06
        LD ($20B9),A  ; ROM $1CC1: 32 B9 20
        XOR A  ; ROM $1CC4: AF
        LD ($2003),A  ; ROM $1CC5: 32 03 20
        RET  ; ROM $1CC8: C9
NATIVE_1CC9:
        LD HL,$208D  ; ROM $1CC9: 21 8D 20
        LD BC,$203C  ; ROM $1CCC: 01 3C 20
        JP $1CEA  ; ROM $1CCF: C3 EA 1C
NATIVE_1CD2:
        LD HL,$2095  ; ROM $1CD2: 21 95 20
        LD BC,$203D  ; ROM $1CD5: 01 3D 20
        JP $1CEA  ; ROM $1CD8: C3 EA 1C
NATIVE_1CDB:
        LD HL,$209D  ; ROM $1CDB: 21 9D 20
        LD BC,$203E  ; ROM $1CDE: 01 3E 20
        JP $1CEA  ; ROM $1CE1: C3 EA 1C
NATIVE_1CE4:
        LD HL,$20A5  ; ROM $1CE4: 21 A5 20
        LD BC,$203F  ; ROM $1CE7: 01 3F 20
NATIVE_1CEA:
        LD A,(HL)  ; ROM $1CEA: 7E
        DEC (HL)  ; ROM $1CEB: 35
        DEC A  ; ROM $1CEC: 3D
        JP NZ,$1CFD  ; ROM $1CED: C2 FD 1C
        INC HL  ; ROM $1CF0: 23
        INC HL  ; ROM $1CF1: 23
        LD E,(HL)  ; ROM $1CF2: 5E
        INC HL  ; ROM $1CF3: 23
        LD D,(HL)  ; ROM $1CF4: 56
        LD HL,$1A4B  ; ROM $1CF5: 21 4B 1A
        LD A,$04  ; ROM $1CF8: 3E 04
        JP $0132  ; ROM $1CFA: C3 32 01
NATIVE_1CFD:
        DEC A  ; ROM $1CFD: 3D
        JP NZ,$1D0F  ; ROM $1CFE: C2 0F 1D
        LD A,$3C  ; ROM $1D01: 3E 3C
        LD (BC),A  ; ROM $1D03: 02
        INC HL  ; ROM $1D04: 23
        INC HL  ; ROM $1D05: 23
        LD E,(HL)  ; ROM $1D06: 5E
        INC HL  ; ROM $1D07: 23
        LD D,(HL)  ; ROM $1D08: 56
        INC HL  ; ROM $1D09: 23
        LD A,$04  ; ROM $1D0A: 3E 04
        JP $0132  ; ROM $1D0C: C3 32 01
NATIVE_1D0F:
        LD A,$14  ; ROM $1D0F: 3E 14
        LD (BC),A  ; ROM $1D11: 02
        INC HL  ; ROM $1D12: 23
        LD A,(HL)  ; ROM $1D13: 7E
        AND A  ; ROM $1D14: A7
        LD A,$88  ; ROM $1D15: 3E 88
        JP NZ,$1D1C  ; ROM $1D17: C2 1C 1D
        LD A,$48  ; ROM $1D1A: 3E 48
NATIVE_1D1C:
        OUT ($03),A  ; ROM $1D1C: D3 03
        LD A,$0F  ; ROM $1D1E: 3E 0F
        LD ($2034),A  ; ROM $1D20: 32 34 20
        LD A,(HL)  ; ROM $1D23: 7E
        INC HL  ; ROM $1D24: 23
        LD E,(HL)  ; ROM $1D25: 5E
        INC HL  ; ROM $1D26: 23
        LD D,(HL)  ; ROM $1D27: 56
        LD HL,$1A80  ; ROM $1D28: 21 80 1A
        RLCA  ; ROM $1D2B: 07
        RLCA  ; ROM $1D2C: 07
        LD C,A  ; ROM $1D2D: 4F
        LD B,$00  ; ROM $1D2E: 06 00
        ADD HL,BC  ; ROM $1D30: 09
        LD A,$04  ; ROM $1D31: 3E 04
        JP $0132  ; ROM $1D33: C3 32 01
NATIVE_1D36:
        LD HL,($20B4)  ; ROM $1D36: 2A B4 20
        XOR A  ; ROM $1D39: AF
        LD ($20B5),A  ; ROM $1D3A: 32 B5 20
        LD A,L  ; ROM $1D3D: 7D
        AND $07  ; ROM $1D3E: E6 07
        INC A  ; ROM $1D40: 3C
        LD C,A  ; ROM $1D41: 4F
        EX DE,HL  ; ROM $1D42: EB
        CALL $01B1  ; ROM $1D43: CD B1 01
        LD B,$00  ; ROM $1D46: 06 00
        JP $18E7  ; ROM $1D48: C3 E7 18
NATIVE_1D4B:
        LD HL,$20B8  ; ROM $1D4B: 21 B8 20
        LD DE,$2080  ; ROM $1D4E: 11 80 20
        LD A,(HL)  ; ROM $1D51: 7E
        DEC (HL)  ; ROM $1D52: 35
        DEC A  ; ROM $1D53: 3D
        JP NZ,$1D60  ; ROM $1D54: C2 60 1D
        XOR A  ; ROM $1D57: AF
NATIVE_1D58:
        LD ($203A),A  ; ROM $1D58: 32 3A 20
        LD A,(DE)  ; ROM $1D5B: 1A
        AND $FE  ; ROM $1D5C: E6 FE
        LD (DE),A  ; ROM $1D5E: 12
        RET  ; ROM $1D5F: C9
NATIVE_1D60:
        DEC A  ; ROM $1D60: 3D
        JP NZ,$1D6E  ; ROM $1D61: C2 6E 1D
NATIVE_1D64:
        LD A,$03  ; ROM $1D64: 3E 03
        LD ($203A),A  ; ROM $1D66: 32 3A 20
        LD A,(DE)  ; ROM $1D69: 1A
        OR $01  ; ROM $1D6A: F6 01
        LD (DE),A  ; ROM $1D6C: 12
        RET  ; ROM $1D6D: C9
NATIVE_1D6E:
        DEC A  ; ROM $1D6E: 3D
        JP NZ,$1D64  ; ROM $1D6F: C2 64 1D
        LD A,$02  ; ROM $1D72: 3E 02
        JP $1D58  ; ROM $1D74: C3 58 1D
NATIVE_1D77:
        LD HL,$20B7  ; ROM $1D77: 21 B7 20
        LD A,(HL)  ; ROM $1D7A: 7E
        INC (HL)  ; ROM $1D7B: 34
        AND A  ; ROM $1D7C: A7
        JP NZ,$1D8D  ; ROM $1D7D: C2 8D 1D
        LD A,$28  ; ROM $1D80: 3E 28
        OUT ($03),A  ; ROM $1D82: D3 03
        LD A,$04  ; ROM $1D84: 3E 04
        LD ($2034),A  ; ROM $1D86: 32 34 20
        LD ($2033),A  ; ROM $1D89: 32 33 20
        RET  ; ROM $1D8C: C9
NATIVE_1D8D:
        LD HL,$1922  ; ROM $1D8D: 21 22 19
        LD DE,$20AD  ; ROM $1D90: 11 AD 20
        LD A,$04  ; ROM $1D93: 3E 04
NATIVE_1D95:
        PUSH AF  ; ROM $1D95: F5
        LD A,(DE)  ; ROM $1D96: 1A
        INC DE  ; ROM $1D97: 13
        PUSH DE  ; ROM $1D98: D5
        PUSH AF  ; ROM $1D99: F5
        LD E,(HL)  ; ROM $1D9A: 5E
        INC HL  ; ROM $1D9B: 23
        LD D,(HL)  ; ROM $1D9C: 56
        INC HL  ; ROM $1D9D: 23
        LD A,(HL)  ; ROM $1D9E: 7E
        SUB $03  ; ROM $1D9F: D6 03
        LD B,A  ; ROM $1DA1: 47
        INC HL  ; ROM $1DA2: 23
        LD C,$01  ; ROM $1DA3: 0E 01
        POP AF  ; ROM $1DA5: F1
        PUSH HL  ; ROM $1DA6: E5
        EX DE,HL  ; ROM $1DA7: EB
        LD DE,$2310  ; ROM $1DA8: 11 10 23
        AND A  ; ROM $1DAB: A7
        JP Z,$1DBA  ; ROM $1DAC: CA BA 1D
        CALL $0FF9  ; ROM $1DAF: CD F9 0F
        LD DE,$0D23  ; ROM $1DB2: 11 23 0D
        LD B,$03  ; ROM $1DB5: 06 03
        CALL $0FF9  ; ROM $1DB7: CD F9 0F
NATIVE_1DBA:
        POP HL  ; ROM $1DBA: E1
        POP DE  ; ROM $1DBB: D1
        POP AF  ; ROM $1DBC: F1
        DEC A  ; ROM $1DBD: 3D
        JP NZ,$1D95  ; ROM $1DBE: C2 95 1D
        LD HL,$20AD  ; ROM $1DC1: 21 AD 20
        LD BC,$0504  ; ROM $1DC4: 01 04 05
NATIVE_1DC7:
        LD A,(HL)  ; ROM $1DC7: 7E
        INC HL  ; ROM $1DC8: 23
        AND A  ; ROM $1DC9: A7
        RET Z  ; ROM $1DCA: C8
        DEC C  ; ROM $1DCB: 0D
        JP NZ,$1DC7  ; ROM $1DCC: C2 C7 1D
NATIVE_1DCF:
        LD (HL),C  ; ROM $1DCF: 71
        DEC HL  ; ROM $1DD0: 2B
        DEC B  ; ROM $1DD1: 05
        JP NZ,$1DCF  ; ROM $1DD2: C2 CF 1D
        XOR A  ; ROM $1DD5: AF
        LD ($2081),A  ; ROM $1DD6: 32 81 20
        LD HL,$1A69  ; ROM $1DD9: 21 69 1A
        LD DE,$3EA7  ; ROM $1DDC: 11 A7 3E
        LD A,$11  ; ROM $1DDF: 3E 11
        CALL $0132  ; ROM $1DE1: CD 32 01
        LD A,$20  ; ROM $1DE4: 3E 20
        JP $18A9  ; ROM $1DE6: C3 A9 18
        DB $C9 ; ROM $1DE9 unclassified
NATIVE_1DEA:
        LD A,($20BA)  ; ROM $1DEA: 3A BA 20
        AND A  ; ROM $1DED: A7
        JP Z,$1DF7  ; ROM $1DEE: CA F7 1D
        LD A,$0C  ; ROM $1DF1: 3E 0C
        LD ($203B),A  ; ROM $1DF3: 32 3B 20
        RET  ; ROM $1DF6: C9
NATIVE_1DF7:
        LD A,$03  ; ROM $1DF7: 3E 03
NATIVE_1DF9:
        PUSH AF  ; ROM $1DF9: F5
        CALL $120E  ; ROM $1DFA: CD 0E 12
        LD A,(HL)  ; ROM $1DFD: 7E
        AND A  ; ROM $1DFE: A7
        JP P,$1E0B  ; ROM $1DFF: F2 0B 1E
        AND $04  ; ROM $1E02: E6 04
        JP NZ,$1E0B  ; ROM $1E04: C2 0B 1E
        LD A,(HL)  ; ROM $1E07: 7E
        OR $04  ; ROM $1E08: F6 04
        LD (HL),A  ; ROM $1E0A: 77
NATIVE_1E0B:
        POP AF  ; ROM $1E0B: F1
        DEC A  ; ROM $1E0C: 3D
        JP P,$1DF9  ; ROM $1E0D: F2 F9 1D
        RET  ; ROM $1E10: C9
NATIVE_1E11:
        LD HL,$2016  ; ROM $1E11: 21 16 20
        IN A,($02)  ; ROM $1E14: DB 02
        CPL  ; ROM $1E16: 2F
        AND $40  ; ROM $1E17: E6 40
        LD B,A  ; ROM $1E19: 47
        XOR (HL)  ; ROM $1E1A: AE
        RET Z  ; ROM $1E1B: C8
        LD (HL),B  ; ROM $1E1C: 70
        LD A,B  ; ROM $1E1D: 78
        AND A  ; ROM $1E1E: A7
        RET Z  ; ROM $1E1F: C8
        LD A,$04  ; ROM $1E20: 3E 04
        OUT ($03),A  ; ROM $1E22: D3 03
        LD A,$0A  ; ROM $1E24: 3E 0A
        LD ($2034),A  ; ROM $1E26: 32 34 20
        XOR A  ; ROM $1E29: AF
        OUT ($07),A  ; ROM $1E2A: D3 07
        IN A,($02)  ; ROM $1E2C: DB 02
        LD C,A  ; ROM $1E2E: 4F
        AND $02  ; ROM $1E2F: E6 02
        LD HL,$2017  ; ROM $1E31: 21 17 20
        JP Z,$1E46  ; ROM $1E34: CA 46 1E
        INC (HL)  ; ROM $1E37: 34
        LD A,(HL)  ; ROM $1E38: 7E
        CP $02  ; ROM $1E39: FE 02
        RET C  ; ROM $1E3B: D8
        LD (HL),$00  ; ROM $1E3C: 36 00
        INC HL  ; ROM $1E3E: 23
        LD A,C  ; ROM $1E3F: 79
        RRA  ; ROM $1E40: 1F
        INC (HL)  ; ROM $1E41: 34
        RET NC  ; ROM $1E42: D0
        INC (HL)  ; ROM $1E43: 34
        INC (HL)  ; ROM $1E44: 34
        RET  ; ROM $1E45: C9
NATIVE_1E46:
        LD (HL),$00  ; ROM $1E46: 36 00
        INC HL  ; ROM $1E48: 23
        INC (HL)  ; ROM $1E49: 34
        LD A,C  ; ROM $1E4A: 79
        RRA  ; ROM $1E4B: 1F
        RET NC  ; ROM $1E4C: D0
        INC (HL)  ; ROM $1E4D: 34
        RET  ; ROM $1E4E: C9
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1E4F unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1E5B unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1E67 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1E73 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1E7F unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1E8B unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1E97 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1EA3 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1EAF unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1EBB unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1EC7 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1ED3 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1EDF unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1EEB unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1EF7 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F03 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F0F unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F1B unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F27 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F33 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F3F unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F4B unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F57 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F63 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F6F unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F7B unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F87 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F93 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1F9F unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1FAB unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1FB7 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1FC3 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1FCF unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1FDB unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1FE7 unclassified
        DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ROM $1FF3 unclassified
        DB $4E ; ROM $1FFF unclassified
