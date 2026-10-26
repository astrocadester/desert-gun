# Desert Gun (1977) — typed 8080 interpreter and event tables

These ranges are confirmed by the original chip bytes and are emitted by `tools/recover_8080.py` as named **`DW` little-endian pointer entries**, not anonymous `DB`. This does not reclassify graphic or script bytes as native code.

| ROM range | Entries | Ownership |
|---|---:|---|
| `$0F61–$0F7A` | 13 | 13 index positions ($0F61–$0F7A), including bypassed zero stub; zero runs frame scheduler $11EA |

The dispatcher at `$11D0` checks zero before indexing the table. Command `$00` invokes scheduler `$11EA` and does not call table entry `$0FAB` (a return stub). Commands `$01–$0C` are the 12 nonzero indexed words. These 13 vector slots do not imply 13 called native routines in the zero path.

## Interpreter-level semantic distinctions

- Word `$03` writes a mode byte to `$2030` and a 16-bit pointer to `$2019`.
- Word `$05` writes an inline immediate byte to an inline absolute RAM address.
- Word `$08` reads two inline 16-bit addresses, calls helper `$1033` twice and transfers to rendering service `$0132`; exact game-level rendering semantics require deeper graphics-state tracing.
- Word `$0B` conditionally decrements round state `$2018` and selects script `$1676`.
- Zero is an explicit frame handoff, not a named native dictionary word invoked via the vector table.

## Reproduction

`build.sh` and `build.bat` regenerate `src/*.asm`, assemble with the bundled zmac, and compare reconstructed ROM bytes to the original ZIP. A pointer entry remains `DW` only when its original two bytes produce a ROM-resident address; the generator asserts there are no overlaps with traced native code or decoded script bytes.
