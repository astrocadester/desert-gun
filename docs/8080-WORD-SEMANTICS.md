# Desert Gun (1977) — indexed interpreter word semantics, pass 2

Source: original 8 KB 8080 ROM, dispatcher `$11D0–$11E9`, script pointer RAM `$2000`, vector base `$0F61`, initial script `$1633`.

The vector region has 13 entries `$00–$0C`; **12 nonzero dispatched words plus the zero scheduler instruction**. Slot zero's table entry `$0FAB` is a `RET` stub but is bypassed by the interpreter's `JZ $11EA` before table lookup.

| Op | Entry | Working descriptive name (not original) | Input and observed effect | Confidence |
|---|---|---|---|---|
| 00 | scheduler 11EA | FRAME_HANDOFF | No pointer advancement; invokes native frame/update services at `$12E5/$12B1/$129E/$1936/$1232/$1503/$124E`, conditional extras | H |
| 01 | 0F94 | DRAW_WITH_MODE_0132 | Consumes 1 byte to C, then invokes renderer/helper `$1A06`, continuation via `$0132` | M |
| 02 | 0FA2 | SET_2031 | Reads 1 immediate byte, writes `$2031` | H |
| 03 | 0FAC | SET_2030_AND_POINTER | Reads 1 byte into `$2030` followed by address16 into `$2019` | H |
| 04 | 0FBE | GOTO_SCRIPT | Reads address16, replaces bytecode pointer `$2000` | H |
| 05 | 0FC7 | STORE_IMMEDIATE_AT_ADDRESS | Reads immediate byte then address16; writes byte to designated RAM address | H |
| 06 | 0FD3 | CLEAR_DISPLAY_MEMORY | Pops return continuation, sets SP `$4030`, disables interrupts, writes 16 zero words per iteration until counter wraps, restores SP `$2400` and resumes via `PCHL` | H |
| 07 | 100E | INITIALIZE_RAM_DESCRIPTOR | Installs fixed 11-byte descriptor structure in RAM around `$204A` | M |
| 08 | 1047 | INITIALIZE_DRAW_AND_BRANCH | Reads address16, calls `$1033` twice, writes `$2083` and passes through `$11AC`; then reads second address16, changes `$2000` and dispatches drawing service `$0132` | M |
| 09 | 0F8E | DRAW_WITH_MODE_0167 | No additional local operands before common `$0F97`; mode/continuation differs from op `01` | M |
| 0A | 106D | CLEAR_BIT_08 | Reads address16, masks target byte with `$F7` | H |
| 0B | 107A | ROUND_OR_SCENE_RESET | Checks/decrements `$2018`, redirects script pointer to `$1676`, initializes outputs `$07/$03`, reads input port `$02`, resets related game-state pointers | M |
| 0C | 0F7B | DRAW_OR_COPY_PACKET | Reads 1 byte and two address16 values, updates script pointer, jumps to rendering service `$0132` | M |

**Widths:** after the opcode, `02:1`, `03:3`, `04:2`, `05:3`, `0A:2`, `0C:5`, `08:4`; other opcodes need control-flow-aware packet checks. Hardware port operations are direct evidence, but “scene”/“draw” labels describe observed call sites rather than recovered original source names.

## Comparison to Gun Fight

Both games retain a native 8080 handler vocabulary, pointer `$2000`, address-bearing inline command operands and graphics-state words. In Gun Fight the zero handler repeats/conditions a command using `$20C5`; in Desert Gun a **separate zero path performs the frame scheduler**. This is a meaningful architectural refinement, not evidence that their vocabularies are numeric-position compatible.

---
# DNA 8080 indexed-command evolution — second semantic pass

Scope: **8080 arcade games only**. The Z80/TERSE generation is excluded.

## Chronological evidence

| Game | Date | Architecture established | Meaningful contrast |
|---|---|---|---|
| Gun Fight | 1975 | byte-indexed native dispatch; pointer `$2000`; vector base `$09AE` | command words combine memory mutation, display preparation, interrupt/I/O management and game-state handling |
| Tornado Baseball | 1976 | 26-command indexed interpreter; pointer `$2000`; frame handoff `$1A` | larger game-action vocabulary and explicit scheduled frame transition |
| Boot Hill | 1977 | 16 nonzero command vectors; pointer `$2006`; zero scheduler handoff | related architecture, but changed pointer convention; direct source ancestry not established |
| Desert Gun | 1977 | 12 nonzero command vectors; pointer `$2000`; zero scheduler handoff | small, specialized game-word set; follows later dispatcher/scheduler organization |
| Double Play | 1977 | 28 command positions; pointer `$2000` | extensible 28-position baseball command family |
| Extra Inning | 1978 | 28 command positions; pointer `$2000` | strong continuity with Double Play in ordered command packets |

**What is established:** the 1975 Gun Fight ROM implements a one-byte index into native addresses at `$09AE`, and the 1977 Desert Gun ROM similarly indexes `$0F61`. This pushes bytecode-style native dispatch earlier than Tornado Baseball. A shared word name or direct reuse of source must be supported by matching native behavior and operand ABI; corresponding opcode numbers alone are not evidence.

## Two execution styles, not a monotonic command count

Gun Fight dispatch (`$03A7–$03C8`) takes the next byte from the ROM script, stores the advanced pointer at `$2000`, doubles the index into the little-endian vector table, pushes a continuation (`$03A6`) and transfers by `PCHL`. A byte at `$20C6` can redirect command fetch to alternate stream `$089B`. The dispatcher has no obvious bounds check. **Only vectors `$00–$14` have defensible native code targets.** Apparent entries `$15–$1D` after this section point into byte sequences that look like structured game data rather than independently valid handlers. The earlier “30 words” assertion was therefore overcounted.

Desert Gun dispatch (`$11D0–$11E9`) tests opcode zero before table lookup. **Zero invokes the frame scheduler at `$11EA`** rather than the table's `$0FAB` return stub. Nonzero values dispatch through `$0F61`, with a saved bytecode pointer at `$2000`; 12 nonzero handlers are tabulated. This arrangement resembles the scheduler handoff in several later 8080 games, but the exact inheritance chain is unresolved.

## Word-analysis method

Distinguish **slot** (index addressable by dispatch), **handler** (native code with a reachable entry), **word** (defined machine-state effect and operand format), and **invoked word** (actually found in decoded game scripts). The attached catalogs use confidence labels: **H** = direct machine-state semantics and operand width identifiable; **M** = operation established but high-level game meaning incomplete; **L** = partial semantics only. “Handler exists” must not be counted as a fully understood source-language word. In particular, no speculative friendly label is treated as an original DNA name.

Next RE checks: trace actual script packet boundaries from script roots, build per-word frequency and calls-to-native-services maps, distinguish game-local words from reusable runtime services, and cross-reference operand addresses with hardware documentation.
