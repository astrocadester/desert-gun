# Desert Gun

![Desert Gun](images/desert-gun-02584-01.jpg)

Desert Gun (1977) is an Intel 8080 Midway/Dave Nutting Associates arcade game. This repository preserves the original ROM set, reconstructs native executable instructions, and documents an indexed-bytecode interpreter present in its program ROM.

## Hard RE: native code and DNA lineage

**Revision v20261031-0001:** [Hard RE interpreter and lineage study](docs/hard-re-interpreter-lineage.md).

- Added 82 native instruction starts recovered from startup/display continuations and a return stub; corrected an 8080 JP instruction straddling the $17FF/$1800 ROM boundary.
- 2,311 native instruction starts representing 3,896 ROM bytes. True font, graphics, data tables and bytecode remain typed data, with readable ROM data labels and inline 8-bit glyph drawings.
- Restored executable code at $01D0–$0267 and $11C3–$11CF. Native $0FD7 display clear is reused by startup and interpreted word $06.
- Native game-word table at $0F61 contains 13 slots ($00–$0C), of which $00 branches directly to the frame scheduler and 12 are nonzero handler words.
- The dispatcher at $11D0 uses the **exact shared ten-byte 8080 dispatch tail** identified in Boot Hill, Sea Wolf, Tornado Baseball, Double Play and Extra Inning.
- A source-byte audit against the original authoritative 8 KB disassembly produced **zero mismatches and zero gaps**, but the updated source still requires a fresh local zmac build and bank-level verification before merge.

## Interpreter and DNA 8080 history

The native dispatcher at `$11D0` fetches indexed 8080 game commands through script pointer `$2000` and vector table `$0F61`; the initial script begins at `$1633`. Second-pass word decoding establishes **13 entries ($00–$0C), with $00 taking an explicit scheduler branch and 12 nonzero native words**. Opcode $00 hands off directly to the frame scheduler at $11EA, in contrast with Gun Fight's zero-command repeat/wait logic.

See [per-word native effects and operand formats](docs/8080-WORD-SEMANTICS.md), [original recovered vectors](docs/interpreter.md), and [machine-readable trace](docs/recovery.json). Working names in the semantic catalog describe recovered machine behavior; they are not claimed as the original DNA source-language spellings.

## Project layout

| Path | Purpose |
|---|---|
| `roms/original/desertgu.zip` | Original ROM devices; source of truth |
| `src/desertgun.asm` | Annotated native reconstruction generated from original ROM |
| `src/zout/desertgun.lst` | zmac assembler listing |
| `tools/recover_8080.py` | Reset/IRQ, branch, and command-vector traced native 8080 recovery |
| `tools/interpreter_lineage.py` | Native bytecode vector inventory |
| `tools/verify_rom.py` | Byte-for-byte rebuilt ROM verification, SHA hashes and MAME ROM ZIP |
| `docs/memory-map.svg` | Dark-theme device/region map with evidence caveats |
| `build.sh`, `build.bat` | Linux and Windows reproducible build scripts using bundled zmac 1.3 |

## Build

Linux: `./build.sh`; Windows: `build.bat`. Both regenerate source from the preserved original chips, assemble with the repository's bundled zmac 1.3, split the resulting binary into original chip devices, and fail if **any ROM byte differs**. Built ROM devices and the MAME ZIP are written to `roms/build/`.

## Research status

Confirmed: native indexed dispatch, original device ordering/hashes and target handlers. Native reconstruction also follows the two recovered startup continuations loaded through HL before `JP (HL)`. Original bitmap, text, and other legitimate data remain `DB` or typed `DW` rather than being misrepresented as executable opcodes. The map marks candidate board RAM/video addresses separately from verified ROM ranges. Detailed command operand types and all alternate native entry paths remain subjects for deeper RE.
