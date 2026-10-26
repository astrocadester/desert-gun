# Desert Gun — native implementation of the indexed game words

This report is generated from the original-ROM-reconstructed assembly at this PR's head. It distinguishes **native vector slots**, their **ROM command packet occurrences**, and the **initial native instructions** at each entry. Names are descriptive reconstructed identifiers, not original DNA spellings.

- Original ROM image size: 8192 bytes.
- Native instruction starts identified: 2229, native byte coverage: 3730 bytes.
- Bounded unique bytecode packet sites: 20 (not a dynamic invocation count).
- Native words: 13 indexed slots. Zero branches to the frame scheduler at $11EA without using the table's $0FAB return stub.

## Native word entry table

| Word | Descriptive name | Entry | Statically decoded ROM command sites |
|---|---|---|---:|
| `$00` | `FRAME_HANDOFF` | `$0FAB` | 2 |
| `$01` | `DRAW_MODE_A` | `$0F94` | 4 |
| `$02` | `SET_RAM_2031` | `$0FA2` | 2 |
| `$03` | `SET_MODE_AND_PTR` | `$0FAC` | 1 |
| `$04` | `BRANCH_SCRIPT` | `$0FBE` | 0 |
| `$05` | `STORE_BYTE` | `$0FC7` | 4 |
| `$06` | `CLEAR_DISPLAY` | `$0FD3` | 1 |
| `$07` | `INIT_DESCRIPTOR` | `$100E` | 1 |
| `$08` | `DRAW_AND_BRANCH` | `$1047` | 3 |
| `$09` | `DRAW_MODE_B` | `$0F8E` | 0 |
| `$0A` | `CLEAR_FLAG_BIT3` | `$106D` | 0 |
| `$0B` | `RESET_ROUND` | `$107A` | 1 |
| `$0C` | `DRAW_PACKET` | `$0F7B` | 1 |

## ROM-native handler entry instructions

Each section shows the first native instructions at a handler entry, stopping at an unconditional `RET` or `JP` or after twelve instructions. This is a *bounded entry trace*, not a claim that all conditional paths or called services are semantically resolved. Detailed argument analysis is in [8080-WORD-SEMANTICS.md](8080-WORD-SEMANTICS.md).

### $00 — FRAME_HANDOFF ($0FAB)

2 known ROM command packet site(s). Native entry:

```asm
RET  ; ROM $0FAB: C9
```

### $01 — DRAW_MODE_A ($0F94)

4 known ROM command packet site(s). Native entry:

```asm
LD HL,$0132  ; ROM $0F94: 21 32 01
```

### $02 — SET_RAM_2031 ($0FA2)

2 known ROM command packet site(s). Native entry:

```asm
EX DE,HL  ; ROM $0FA2: EB
LD A,(HL)  ; ROM $0FA3: 7E
LD ($2031),A  ; ROM $0FA4: 32 31 20
INC HL  ; ROM $0FA7: 23
LD ($2000),HL  ; ROM $0FA8: 22 00 20
```

### $03 — SET_MODE_AND_PTR ($0FAC)

1 known ROM command packet site(s). Native entry:

```asm
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
```

### $04 — BRANCH_SCRIPT ($0FBE)

0 known ROM command packet site(s). Native entry:

```asm
EX DE,HL  ; ROM $0FBE: EB
LD E,(HL)  ; ROM $0FBF: 5E
INC HL  ; ROM $0FC0: 23
LD D,(HL)  ; ROM $0FC1: 56
EX DE,HL  ; ROM $0FC2: EB
LD ($2000),HL  ; ROM $0FC3: 22 00 20
RET  ; ROM $0FC6: C9
```

### $05 — STORE_BYTE ($0FC7)

4 known ROM command packet site(s). Native entry:

```asm
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
```

### $06 — CLEAR_DISPLAY ($0FD3)

1 known ROM command packet site(s). Native entry:

```asm
POP HL  ; ROM $0FD3: E1
LD SP,$4030  ; ROM $0FD4: 31 30 40
```

### $07 — INIT_DESCRIPTOR ($100E)

1 known ROM command packet site(s). Native entry:

```asm
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
```

### $08 — DRAW_AND_BRANCH ($1047)

3 known ROM command packet site(s). Native entry:

```asm
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
```

### $09 — DRAW_MODE_B ($0F8E)

0 known ROM command packet site(s). Native entry:

```asm
LD HL,$0167  ; ROM $0F8E: 21 67 01
JP $0F97  ; ROM $0F91: C3 97 0F
```

### $0A — CLEAR_FLAG_BIT3 ($106D)

0 known ROM command packet site(s). Native entry:

```asm
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
```

### $0B — RESET_ROUND ($107A)

1 known ROM command packet site(s). Native entry:

```asm
LD HL,$2018  ; ROM $107A: 21 18 20
LD A,(HL)  ; ROM $107D: 7E
AND A  ; ROM $107E: A7
RET Z  ; ROM $107F: C8
```

### $0C — DRAW_PACKET ($0F7B)

1 known ROM command packet site(s). Native entry:

```asm
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
```

## RE boundary

Remaining raw `DB` sections include graphics, vector tables, command packets, native-unreached data, and potentially code copied into RAM. Do not call them 'unknown interpreter words' merely because their bytes resemble opcodes. Source-generation provenance and unresolved ranges are recorded in [DB-PROVENANCE.md](DB-PROVENANCE.md). Regenerating the source must preserve the original chip SHA-1s.
