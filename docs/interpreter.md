# Desert Gun: 8080 indexed bytecode interpreter

Source: original desertgu.zip, SHA256 bcc3ea2125ba8a987923370c5a2545c771a7e04eef2440d2f072ea488b851916

## Runtime identity

- Script-pointer RAM: `$2000`
- Native command dispatcher: `$3A7`
- Vector table: `$9AE`
- Indexed native entries: 30
- Initial ROM command stream: `$821`

The dispatcher fetches a bytecode from its saved program counter, advances the pointer, indexes 16-bit native handler entries, and transfers control indirectly. Entry count does not imply each command has identical operands.

| Index | Native handler | First 8 bytes at handler |
|---:|---:|---|
| `$00` | `$0FAB` | `C9 EB 7E 32 30 20 23 5E` |
| `$01` | `$0F94` | `21 32 01 E5 EB 4E 23 22` |
| `$02` | `$0FA2` | `EB 7E 32 31 20 23 22 00` |
| `$03` | `$0FAC` | `EB 7E 32 30 20 23 5E 23` |
| `$04` | `$0FBE` | `EB 5E 23 56 EB 22 00 20` |
| `$05` | `$0FC7` | `EB 7E 23 5E 23 56 23 22` |
| `$06` | `$0FD3` | `E1 31 30 40 F3 01 00 00` |
| `$07` | `$100E` | `21 4A 20 01 FE 0B 70 2B` |
| `$08` | `$1047` | `EB 5E 23 56 23 01 83 20` |
| `$09` | `$0F8E` | `21 67 01 C3 97 0F 21 32` |
| `$0A` | `$106D` | `EB 5E 23 56 23 22 00 20` |
| `$0B` | `$107A` | `21 18 20 7E A7 C8 35 21` |
| `$0C` | `$0F7B` | `EB 7E 23 5E 23 56 23 D5` |

## Historical interpretation

Desert Gun (1977) directly demonstrates DNA's early indexed native-command interpreter. Common interpreter mechanics alone do not prove that the individual handler implementations or source files were identical across games.

## Verification boundaries

This table is read directly from the original ROM. Native handler semantics, script operand sizes, interrupt cadence, and full address ownership require instruction- and data-flow analysis.
