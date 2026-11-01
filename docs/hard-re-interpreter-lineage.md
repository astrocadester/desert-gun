# Desert Gun (1977) — hard 8080 RE, interpreter ABI and DNA evolution

**RE revision:** v20261031-0001. **Primary evidence:** `roms/original/desertgu.zip`, four 2 KB ROMs, SHA-256 `bcc3ea2125ba8a987923370c5a2545c771a7e04eef2440d2f072ea488b851916`. Companion: [main assembly](../src/desertgun.asm), [native word semantics](8080-WORD-SEMANTICS.md), [decoded programs](decoded-scripts.md).

## 1. The executable engine

The Desert Gun interpreter uses a byte-indexed 8080 handler table, a two-byte saved script PC, and a native frame scheduler. At `$11D0` it loads the pointer held in RAM `$2000`, reads a command, and branches on zero. Nonzero commands advance the script PC past the opcode, put the inline operand position in **DE**, then index a table of native handler addresses at **`$0F61 + 2×opcode`**. This exact dispatch tail appears at `$11E0`:

```asm
; Actual ROM $11D0-$11E9, symbolic operand labels shortened:
LD HL,($2000)       ; $11D0 - interpreted instruction pointer
LD A,(HL)           ; $11D3 - token
AND A               ; $11D4
JP Z,$11EA          ; $11D5 - $00 yields to native scheduler
INC HL              ; $11D8
LD ($2000),HL       ; $11D9 - operand cursor
EX DE,HL            ; $11DC
LD HL,$0F61         ; $11DD - vector base
RLCA                ; $11E0 - index * 2
LD C,A              ; $11E1
LD B,$00            ; $11E2
ADD HL,BC           ; $11E4
LD A,(HL)           ; $11E5
INC HL              ; $11E6
LD H,(HL)           ; $11E7
LD L,A              ; $11E8
JP (HL)             ; $11E9 - native handler
```

The physical table `$0F61–$0F7A` has thirteen 16-bit entries `$00–$0C`. **Zero is reserved for frame handoff**: although slot zero contains `$0FAB` (a native `RET`), `$11D5` branches to `$11EA` first. Thus there are **12 nonzero executable words**, not 13 dispatched handler bodies.

The boot continuation at **`$11C3–$11CF`** was previously misclassified as `DB`. It executes `LD HL,$1633; LD ($2000),HL; LD HL,$11C9; PUSH HL; EI; OUT ($04),A`, then falls into the fetch loop. The pushed `$11C9` forms the native return continuation: handler `RET` returns to a short sequence that pushes its return address again and re-enters dispatch. This is a concrete **native return trampoline**, not a threaded TERSE data stack.

## 2. Word dictionary: original opcode → native handler → operand contract

| Token | Native entry | Inline bytes | Observed native effect |
|---|---|---:|---|
| `00` | scheduler `11EA` | 0 | Frame handoff; no bytecode PC increment |
| `01` | `0F94` | 1 | Drawing mode $0132; reads C from inline byte and calls $1A06 |
| `02` | `0FA2` | 1 | Writes inline byte to RAM $2031 |
| `03` | `0FAC` | 3 | Writes immediate mode to RAM $2030; 16-bit operand to RAM $2019 |
| `04` | `0FBE` | 2 | Replaces script PC at RAM $2000 with inline little-endian address |
| `05` | `0FC7` | 3 | Stores inline byte at inline 16-bit destination address |
| `06` | `0FD3` | 0 | Clears video memory using stack writes and resumes native continuation |
| `07` | `100E` | 0 | Initializes fixed descriptor bytes in RAM around $2040–$204A |
| `08` | `1047` | 4 | Reads two inline 16-bit fields; sets drawing/descriptor state and routes to renderer |
| `09` | `0F8E` | 1 | Drawing mode $0167; shares common operand-fetch path with $01 |
| `0A` | `106D` | 2 | Clears bit $08 at inline RAM address (mask $F7) |
| `0B` | `107A` | 0 | Conditional round/reset service; installs resume script $1676 and sets outputs |
| `0C` | `0F7B` | 5 | One-byte drawing parameter followed by two 16-bit addresses; dispatches renderer $0132 |

The names are behavior descriptions, not claimed original DNA source spellings. See [semantic catalog](8080-WORD-SEMANTICS.md) for per-word confidence and calls to shared drawing services. Every word has a concrete vector; script scans establish **20 statically reachable command packets** at two entry roots. This is not a claim to have discovered every runtime-generated execution path.

## 3. Decoded startup example

The original script begins at **`$1633`**:

```text
$1633  06                 CLEAR_DISPLAY_MEMORY
$1634  08 06 20 A0 3E     INITIALIZE_DRAW_AND_BRANCH  ($2006, $3EA0)
$1639  01 05              DRAW_WITH_MODE_0132         $05
$163B  08 0B 20 00 24     INITIALIZE_DRAW_AND_BRANCH  ($200B, $2400)
$1640  01 06              DRAW_WITH_MODE_0132         $06
$1642  01 04              DRAW_WITH_MODE_0132         $04
$1644  08 1C 20 1B 24     INITIALIZE_DRAW_AND_BRANCH  ($201C, $241B)
$1649  07                 INITIALIZE_RAM_DESCRIPTOR
$164A  05 01 81 20        STORE_IMMEDIATE_AT_ADDRESS   $01 -> $2081
$164E  05 01 B1 20        STORE_IMMEDIATE_AT_ADDRESS   $01 -> $20B1
...
$1669  00                 FRAME_HANDOFF
```

The second currently rooted program starts at **`$1676`**: `02 1E` stores $1E in $2031, followed by `00` at $1678 for frame handoff. These packets are **bytecode**, not native instructions. The source annotates opcode and operand boundaries explicitly.

## 4. Frame lifecycle and native services

At **`$11EA`**, the zero path calls `$12E5, $12B1, $129E, $1936, $1232, $1503, $124E`. It checks RAM $200D and conditionally calls `$1318, $1142, $16F0`. The scheduler returns to the native continuation; a zero script token can therefore remain at its site across frames until code changes the script pointer.

**Shared drawing ABI:** word $01 sets HL=$0132; word $09 sets HL=$0167; both jump to native helper `$0F97`, which pushes the renderer continuation, obtains the inline parameter from DE, advances RAM $2000, then calls `$1A06`. Word $0C parses five inline bytes and jumps to `$0132`. These are actual shared handler bodies, unlike coincidentally numbered words in other games.

**Fast screen clear:** word $06 at `$0FD3` pops its return continuation into HL; the shared clear routine at `$0FD7` disables interrupts, writes zeros by pushing BC repeatedly over video memory using SP, restores SP=$2400, then does `JP (HL)` at $0FF3. The same clear primitive is called at boot from `$11BA` and from diagnostics `$01C7`: both set HL to a **different continuation address**, then jump directly to `$0FD7`.

## 5. Previously hidden native code, now disassembled

| Address | Native region | Reason it was missed |
|---|---|---|
| `$01D0–$0267` | Display diagnostic and hardware exercise; includes screen sweeps, port $02 reads, tests and display helper calls | Reached via `$01C7 → $0FD7 → JP (HL)`, not a direct CALL edge |
| `$11C3–$11CF` | Initialize script PC, native return trampoline and I/O; boot continuation | Reached via `$11BA → $0FD7 → JP (HL)` |
| `$1DE9` | One-byte `RET` return stub | Isolated fallthrough between native routines |
| `$17FF–$1801` | Single `JP $0132`, physically spanning 2 KB chip boundary | Old generator split instruction into raw DB bytes at device boundary |

The recovered code adds **82 instruction starts** to the prior native source, for **2,311 native instructions / 3,896 native instruction bytes** in the revised assembly. Real image data and compact game scripts remain as data. The preserved assembly's 8,192 reconstructed bytes compare exactly against the previous ROM-authoritative source, with no duplicate bytes, holes, or undefined symbolic labels. This is an **independent source-byte check**, not a substitute for a freshly assembled zmac roundtrip.

## 6. Data ownership and why DB remains legitimate

Data labels now distinguish ROM checksum references ($0121), diagnostic constants ($01C3), diagnostic bit-step table ($0268), character-font bitmap rows ($0288), screen-coordinate lookup ($04FB), packed gun/drawing shapes ($06DC–$0F60), object sequences ($10AE), frame patterns ($14BB), object pointer words ($1564), movement patterns ($1580), drawing records ($191C), sprite transfer pointer pairs ($1965), DIP-selected thresholds ($19FF), screen message pointer tables ($1A2F/$1A37), encoded text ($1A60), and FF padding ($1E4F). Native pointers use `DW` where supported; the alphabet/digit glyphs have inline 8-bit pixel rows. Retaining `DB` for **actual bitmap/text/packed data** is correct assembly, not a failure to recover native code.

## 7. Connections to DNA's other systems

| Game | Era | Dispatcher and script PC | Observed continuity |
|---|---|---|---|
| Gun Fight | 1975 | $03A7, RAM $2000; 21 credible indexed entries | Early byte-indexed native handlers; $00 is repeat/wait rather than direct zero frame handoff; fast stack-based screen clear also appears |
| Sea Wolf | 1976 | $045E, RAM $2000, vector base $09E8 | Same ten-byte native indexing/jump tail; native renderer and time/game services |
| Tornado Baseball | 1976 | 26-word interpreter, RAM $2000 | Same ten-byte indexing/jump tail, larger vocabulary and timed frame scheduling |
| Boot Hill | 1977 | $0F85, RAM $2006, 16 nonzero handlers | Same tail and zero scheduler; different script pointer address and game-word ABI |
| **Desert Gun** | **1977** | **$11D0, RAM $2000, 12 nonzero handlers** | Identical dispatcher tail, $00 native frame scheduler, several compact display/state/branch words |
| Double Play | 1977 | 28 positions, RAM $2000 | Same dispatch tail with expanded baseball game program |
| Extra Inning | 1978 | $073E, RAM $2000, table $120C, 28 positions | Explicit boundary $1C and frame scheduler; additional extensions and ROM-resident script banks |
| Sea Wolf II | 1978 | Z80 TERSE | Later *direct-threaded* words; different runtime, stack convention and native ABI |

**Interpretation:** the byte-for-byte match of the *tail* and shared RAM script-PC pattern support strong continuity of DNA's 8080 indexed execution mechanism. The **individual word numbers do not define a stable cross-game ABI**. A particularly concrete reuse *inside Desert Gun* is the same video-clear primitive serving word $06, startup, and diagnostics. A likely design progression is a native reusable service collection plus small 8080 script vocabularies, then larger sports/game vocabularies, and subsequently the Z80 TERSE direct-threaded production framework. Keep the verified mechanics distinct from chronological attribution.

## 8. Verification and scope

The checked-in native source preserves the complete 8 KB reference byte sequence; 2,311 instruction starts, 3,896 native bytes, no overlaps/gaps. The existing `build.sh` and `build.bat` still regenerate the source through the existing decoder, assemble with bundled zmac v1.3, then verify every original ROM bank. **An actual assembler run and final bank verification were not performed through the GitHub connector**, and should be completed before merge. No GitHub Actions, new build system, or modifications to the original ROM archive were introduced.
