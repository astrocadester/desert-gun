# desertgun — decoded 8080 game-command scripts

Distinct statically decoded packet sites: 20

| ROM | Word | Operand bytes | Length |
|---|---|---|---:|
| 1633 | 06 |  | 1 |
| 1634 | 08 | 0620A03E | 5 |
| 1639 | 01 | 05 | 2 |
| 163B | 08 | 0B200024 | 5 |
| 1640 | 01 | 06 | 2 |
| 1642 | 01 | 04 | 2 |
| 1644 | 08 | 1C201B24 | 5 |
| 1649 | 07 |  | 1 |
| 164A | 05 | 018120 | 4 |
| 164E | 05 | 01B120 | 4 |
| 1652 | 03 | 103316 | 4 |
| 1656 | 05 | 013520 | 4 |
| 165A | 05 | 013820 | 4 |
| 165E | 0C | 0B5E1A8A2F | 6 |
| 1664 | 0B |  | 1 |
| 1665 | 01 | 02 | 2 |
| 1667 | 02 | 3C | 2 |
| 1669 | 00 |  | 1 |
| 1676 | 02 | 1E | 2 |
| 1678 | 00 |  | 1 |

## Root traversal

| Root | Packets | Stop |
|---|---:|---|
| 1633 | 18 | zero-frame-handoff at 1669 |
| 1676 | 2 | zero-frame-handoff at 1678 |

## Distinct ROM word use

| Word | Sites |
|---|---:|
| 00 | 2 |
| 01 | 4 |
| 02 | 2 |
| 03 | 1 |
| 05 | 4 |
| 06 | 1 |
| 07 | 1 |
| 08 | 3 |
| 0B | 1 |
| 0C | 1 |

Desert Gun opcode $05 writes an immediate byte to an inline 16-bit address; opcode $06 clears screen memory using no inline operands.

This is static rooted decoding; it is not a complete emulation of interrupt-driven execution.

