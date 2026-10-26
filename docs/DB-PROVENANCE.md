# Desert Gun — third-pass ROM data and word audit

This is a byte-preserving classification of the original 8,192-byte ROM source; text annotations change no emitted ROM bytes.

## Static interpreter facts
- The dispatch loop at `$11D0–$11E9` reads from pointer RAM `$2000`.
- Opcode `$00` branches directly to scheduler `$11EA` before incrementing the pointer; the table's slot-zero `$0FAB` is not used for that instruction.
- Twelve nonzero handlers occupy vector slots `$01–$0C` in the 26-byte table `$0F61–$0F7A`. Widths for `$01/$02/$03/$04/$05/$08/$09/$0A/$0C` are obtained from native pointer movement. `$06/$07/$0B` have no immediate bytes in the bounded linear pass.
- Opcode `$04` stores a 16-bit destination directly into `$2000`. Opcode `$0B` may redirect program state to `$1676` depending on round conditions.

## Raw DB provenance

From `src/desertgun.asm`, 4,465 original ROM bytes remain `DB` (385 grouped directives before this annotation pass). Principal contiguous ranges:

| ROM interval | DB bytes | Interpretation |
| --- | ---: | --- |
| `$0288–$0403` | 380 | Repeating glyph/bitmap rows rather than plausible executable routines. |
| `$06DC–$0F7A` | 2,207 | Large mixed tables, graphics and the confirmed vector table at `$0F61–$0F7A`; individual owners still need to be mapped. |
| `$10AE–$1141` | 148 | Untraced native-adjacent data; do not invent code at these locations. |
| `$1564–$16EF` | 396 | Script-bearing interval with rooted streams `$1633` and `$1676` and embedded values. |
| `$1A2F–$1C21` | 499 | Packed native-adjacent data and rendering tables, unresolved at finer granularity. |
| `$1E4F–$1FFF` | 433 | End-ROM data; table/bitmap purposes require referencing routines. |

## Rooted packet audit (deterministic)

Run `python3 tools/audit_words.py` to regenerate `docs/word-audit.json` from original ROM bytes. This is a **static** bounded parser, not a dynamic 8080 execution trace.

| Root | Safely parsed packets | Stop | Meaning |
| --- | ---: | --- | --- |
| `$1633` | 18 | `$1669` (`00`) | Frame-handoff instruction; zero pointer is not advanced before the scheduler branch. |
| `$1676` | 2 | `$1678` (`00`) | Second rooted frame-handoff instruction. |

The audit stops at the first zero rather than inventing a native return or advancing past the live frame loop. These 20 packet instances include two scheduler zeros; they do **not** enumerate all runtime game words. See [the word semantic catalog](8080-WORD-SEMANTICS.md) for native effects and confidence.

## Remaining high-value RE

Resolve native 0x08's two-address draw/branch semantics including its final `$0132` transfer; enumerate reachable scripts under state-mutating 0x0B; identify the exact ownership of table and graphics DB spans by all memory references. Direct opcode equivalence with other DNA 8080 games must be established through ABI, not index alignment.
