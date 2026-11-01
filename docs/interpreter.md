# Desert Gun — ROM-verified 8080 indexed interpreter

Source: original desertgu.zip, SHA256 bcc3ea2125ba8a987923370c5a2545c771a7e04eef2440d2f072ea488b851916

## Dispatcher ABI

- Dispatcher $11D0–$11E9; script pointer in RAM $2000.
- Token $00 is a frame handoff to $11EA, without advancing the script PC.
- Nonzero tokens advance RAM $2000 past the opcode; DE addresses inline operands.
- Little-endian native vector fetch from $0F61 + 2 x opcode.
- Tail at $11E0: 07 4F 06 00 09 7E 23 66 6F E9.
- 13 table slots: 12 executed nonzero words; slot zero points to RET at $0FAB
  but is bypassed by the zero-scheduler branch.

## Native word vectors and inline operand widths

| Op | Native entry | Payload bytes | Working operation |
|---|---|---:|---|
| $00 | $0FAB | 0 | FRAME_HANDOFF |
| $01 | $0F94 | 1 | DRAW_WITH_MODE_0132 |
| $02 | $0FA2 | 1 | SET_2031 |
| $03 | $0FAC | 3 | SET_2030_AND_POINTER |
| $04 | $0FBE | 2 | GOTO_SCRIPT |
| $05 | $0FC7 | 3 | STORE_IMMEDIATE_AT_ADDRESS |
| $06 | $0FD3 | 0 | CLEAR_DISPLAY_MEMORY |
| $07 | $100E | 0 | INITIALIZE_RAM_DESCRIPTOR |
| $08 | $1047 | 4 | INITIALIZE_DRAW_AND_BRANCH |
| $09 | $0F8E | 1 | DRAW_WITH_MODE_0167 |
| $0A | $106D | 2 | CLEAR_BIT_08 |
| $0B | $107A | 0 | ROUND_OR_SCENE_RESET |
| $0C | $0F7B | 5 | DRAW_OR_COPY_PACKET |

Word names describe observed machine behavior, not original DNA vocabulary.
Script starts: $1633 (initial), $1676 (round reset).
See [decoded scripts](decoded-scripts.md) and [word semantics](8080-WORD-SEMANTICS.md).

## Evolution and reuse

Boot Hill, Sea Wolf, Tornado Baseball, Double Play and Extra Inning share the
exact 10-byte indexing/indirect-jump tail. Desert Gun uses RAM $2000 for
its script PC, while Boot Hill uses RAM $2006. The zero scheduler handoff
is distinct from Gun Fight zero-command behavior. Opcode number alone
does not establish identical handler semantics or ABI.
