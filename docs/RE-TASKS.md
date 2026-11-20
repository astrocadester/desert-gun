# Desert Gun — RE Progress and Technical Debt

**Active branch:** `re/desertgun-hard-re-20261031` (PR #3). **This is the sole task/progress tracker.** Research, reverse-engineered structures, technical descriptions and findings are in `DESERT-GUN-TECHNICAL-REFERENCE.md`. The README is for project orientation and build instructions.

## RE task register

| ID | Priority | Status | Work and required acceptance evidence |
| --- | --- | --- | --- |
| RE-001 | P0 | IN PROGRESS | **Byte-exact build:** zmac v1.3 assembly of current `src/desertgun.asm`; all four SHA-1s match original ROM devices; MAME executes; Windows build reproduces them. A suspected cause of the third-ROM mismatch is the set of long symbolic names with overlapping leading prefixes. Source now uses unique short label names; source-level address/data comparisons PASS. **Latest zmac/ROM SHA-1 and MAME run still require confirmation.** |
| RE-002 | P0 | OPEN | **Complete interpreter frame lifecycle:** trace zero-command frame handoffs, resumption, and real reachability of 39 linearly parsed post-$1678 commands; record script-PC changes and reachable command counts. |
| RE-003 | P0 | OPEN | **Motion record consumer:** trace $1564/$1574 pointer lookup, sixteen object-motion streams, selector behavior, address field semantics, $FF processing, object flags, and transitions. |
| RE-004 | P1 | OPEN | **Graphic record encoding:** resolve the formats, dimensions and rendering semantics of 47 source-referenced packed graphic records; add representative inline bitmaps with byte-address confirmation. |
| RE-005 | P1 | OPEN | **Audio:** trace timed event encoding and durations of five sound streams, indexed sound-generator values at $04FB, and output ports $05/$06; verify against actual sound behavior. |
| RE-006 | P1 | OPEN | **Frame/object table semantics:** determine precise uses of the 16 frame indices, eight graphic pointers, motion thresholds, and control-parameter fields from their native consumers. |
| RE-007 | P1 | OPEN | **Hardware:** verify RAM mirrors, framebuffer, stack video-clear, I/O, DIP and input bits, and unmapped regions against original board documentation/MAME. |
| RE-008 | P2 | OPEN | **DNA interpreter lineage:** confirm byte-exact shared dispatch-tail implementations, native-word ABI differences, and verified cross-game chronology. |

## Engineering task register

| ID | Priority | Status | Work and acceptance evidence |
| --- | --- | --- | --- |
| ENG-001 | P0 | COMPLETE | **Remove obsolete GitHub Actions reconstruction:** the workflow stages generated ROM/source, uses Python and references an abandoned branch. No build-generated artifacts may be tracked. |
| ENG-002 | P1 | COMPLETE | **Single technical research reference:** merge and reconcile research into `DESERT-GUN-TECHNICAL-REFERENCE.md`; remove superseded reports after checking preservation. |
| ENG-003 | P1 | COMPLETE | **Single task tracker:** this file contains all remaining RE progress, verification, debt, priorities and acceptance gates; none of those belong in the README or research text. |
| ENG-004 | P1 | COMPLETE | **Remove generated JSON from Git:** remove `interpreter.json`, `word-audit.json`, `recovery.json`, redirect any retained RE tool's outputs to ignored `build/recovery/`. |
| ENG-005 | P1 | COMPLETE | **Remove unused Python:** remove obsolete generators and Python verifier from the repository. Retain only RE tools that have a continuing investigative function, never in the build. |
| ENG-006 | P1 | COMPLETE | **Reference consistency:** README, ASM, tech reference, single SVG and current utilities describe the same software; update any stale links, labels, numbers and commands. |
| ENG-007 | P1 | OPEN | **Clean reproducible builds:** Linux/Windows produce only ignored intermediates and MAME ZIP; original ROM archive unchanged, Git working tree clean. |

## Build issue and resolution record

- **Reported failure:** bank `9316.1f` returned SHA-1 `5214eea1685abc191a8df12b86817d0faf191156` while the first two banks passed.
- **Potential assembler ambiguity addressed:** overlapping long symbol prefixes, notably `GRAPHIC_RESOURCE_*` and `MOTION_SEQUENCE_*`, were replaced with short unique symbolic names throughout the ASM. All current labels have distinct first 16 characters; branch instructions and pointer tables continue to use meaningful symbolic operands.
- **Static validation:** 2,311 native instruction addresses unchanged; all 4,296 typed data bytes match their original 8 KB positions; 251 symbolic instruction targets match the original encoded addresses.
- **Outstanding acceptance test:** assemble the latest commit locally using bundled `tools/zmac`, check all four SHA-1s, and run MAME. An unexecuted code change is not recorded as a passing build.

## Completed evidence checkpoints

| Topic | Established result |
| --- | --- |
| Hardware ROM image | 8 KB, four preserved 2 KB devices, original SHA-1s documented |
| Interpreter | $11D0, 13 indexed slots $00–$0C, twelve nonzero native handler entries, zero scheduler at $11EA |
| Native reconstruction | 2,311 Intel 8080 instruction starts, 3,896 instruction bytes, boot continuations and cross-device jump identified |
| Scripts | Initial $1633 / round $1676; 20 bounded original-root packet sites; 39 additional linearly parsed records following $1678 |
| Graphics | $0288 font as 38 individually labeled 8×10 glyphs; $06DC–$0F60 split into 47 address-referenced graphic resources |
| Motion | 8 + 6 object motion pointers, 16 labeled streams and data-record boundaries |
| Sound | Five indexed audio event streams and sound I/O service |
| Text | DESERT GUN title, English/German/French/Danish high-bit-terminated messages |
| Checksum | Original fourth-device balancing byte $4E at $1FFF |
| Source-level audit | 8,192 address positions, 2,311 instruction positions, 4,296 typed data bytes and 251 symbolic machine-address references checked before the latest build correction |

**Acceptance rule:** A byte-exact source-level structural audit does not replace a real `./build.sh` + MAME run. Record only verified hardware/software behavior as complete.
