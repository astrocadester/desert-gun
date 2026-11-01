#!/usr/bin/env python3
"""ROM-grounded Desert Gun (1977) 8080 interpreter, never Gun Fight offsets."""
from pathlib import Path
import hashlib, json, zipfile
from audit_words import audit

R=Path(__file__).resolve().parents[1]
CHIPS=("9316.1h","9316.1g","9316.1f","desertgu.e")
with zipfile.ZipFile(R/"roms/original/desertgu.zip") as z:
    image=b"".join(z.read(name) for name in CHIPS)
assert len(image)==0x2000
le16=lambda at: int.from_bytes(image[at:at+2],"little")
BASE=0x0F61
DISPATCH=0x11D0
FRAME=0x11EA
assert image[DISPATCH:DISPATCH+16]==bytes.fromhex("2a 00 20 7e a7 ca ea 11 23 22 00 20 eb 21 61 0f")
assert image[0x11E0:0x11EA]==bytes.fromhex("07 4f 06 00 09 7e 23 66 6f e9")
vectors=[le16(BASE+2*i) for i in range(13)]
assert vectors==[0x0FAB,0x0F94,0x0FA2,0x0FAC,0x0FBE,0x0FC7,0x0FD3,0x100E,0x1047,0x0F8E,0x106D,0x107A,0x0F7B],vectors
word_names=("FRAME_HANDOFF","DRAW_WITH_MODE_0132","SET_2031","SET_2030_AND_POINTER","GOTO_SCRIPT",
              "STORE_IMMEDIATE_AT_ADDRESS","CLEAR_DISPLAY_MEMORY","INITIALIZE_RAM_DESCRIPTOR",
              "INITIALIZE_DRAW_AND_BRANCH","DRAW_WITH_MODE_0167","CLEAR_BIT_08",
              "ROUND_OR_SCENE_RESET","DRAW_OR_COPY_PACKET")
widths=(0,1,1,3,2,3,0,0,4,1,2,0,5)
audit_report=audit(R,"desertgun")
assert [v["known_operand_width"] for v in audit_report["vector_entries"]]==list(widths)
report={"game":"desertgun","sha256":hashlib.sha256(image).hexdigest(),
    "dispatcher":DISPATCH,"dispatcher_tail":0x11E0,
    "script_pointer_ram":0x2000,"frame_scheduler":FRAME,
    "vector_base":BASE,"vector_slots":len(vectors),
    "native_words":12,"zero_entry":vectors[0],
    "zero_is_frame_handoff":True,"initial_script":0x1633,
    "other_script_root":0x1676,"vectors":vectors,
    "operand_widths":widths,"packet_sites":audit_report["distinct_packet_count"]}
(R/"docs/interpreter.json").write_text(json.dumps(report,indent=2)+"\n")
lines=["# Desert Gun — ROM-verified 8080 indexed interpreter","",
    "Source: original desertgu.zip, SHA256 "+report["sha256"],"",
    "## Dispatcher ABI","",
    "- Dispatcher $11D0–$11E9; script pointer in RAM $2000.",
    "- Token $00 is a frame handoff to $11EA, without advancing the script PC.",
    "- Nonzero tokens advance RAM $2000 past the opcode; DE addresses inline operands.",
    "- Little-endian native vector fetch from $0F61 + 2 x opcode.",
    "- Tail at $11E0: 07 4F 06 00 09 7E 23 66 6F E9.",
    "- 13 table slots: 12 executed nonzero words; slot zero points to RET at $0FAB",
    "  but is bypassed by the zero-scheduler branch.","",
    "## Native word vectors and inline operand widths","",
    "| Op | Native entry | Payload bytes | Working operation |",
    "|---|---|---:|---|"]
for i,entry in enumerate(vectors):
    lines.append(f"| ${i:02X} | ${entry:04X} | {widths[i]} | {word_names[i]} |")
lines+=["","Word names describe observed machine behavior, not original DNA vocabulary.",
    "Script starts: $1633 (initial), $1676 (round reset).",
    "See [decoded scripts](decoded-scripts.md) and [word semantics](8080-WORD-SEMANTICS.md).",
    "","## Evolution and reuse","",
    "Boot Hill, Sea Wolf, Tornado Baseball, Double Play and Extra Inning share the",
    "exact 10-byte indexing/indirect-jump tail. Desert Gun uses RAM $2000 for",
    "its script PC, while Boot Hill uses RAM $2006. The zero scheduler handoff",
    "is distinct from Gun Fight zero-command behavior. Opcode number alone",
    "does not establish identical handler semantics or ABI.",""]
(R/"docs/interpreter.md").write_text("\n".join(lines))
print("PASS Desert Gun interpreter",hex(DISPATCH),len(vectors),"slots")
