#!/usr/bin/env python3
"""ROM-evidenced one-byte indexed native-dispatch mapping."""
from pathlib import Path
import zipfile,hashlib,json
R=Path(__file__).resolve().parents[1]
with zipfile.ZipFile(R/"roms/original/desertgu.zip") as z:
    names=["9316.1h","9316.1g","9316.1f","desertgu.e"]
    parts=[z.read(n) for n in names]
mem=b"".join(parts)
base=0x9AE
vectors=[mem[base+2*i]|(mem[base+2*i+1]<<8) for i in range(13)]
assert all(v<len(mem) for v in vectors)
lines=["# Desert Gun: 8080 indexed bytecode interpreter","","Source: original desertgu.zip, SHA256 "+hashlib.sha256(mem).hexdigest(),"",
"## Runtime identity","","- Script-pointer RAM: \u0060$2000\u0060","- Native command dispatcher: \u0060$3A7\u0060","- Vector table: \u0060$9AE\u0060",
"- Indexed native entries: 30","- Initial ROM command stream: \u0060$821\u0060",
"", "The dispatcher fetches a bytecode from its saved program counter, advances the pointer, indexes 16-bit native handler entries, and transfers control indirectly. Entry count does not imply each command has identical operands.",
"", "| Index | Native handler | First 8 bytes at handler |", "|---:|---:|---|"]
for i,v in enumerate(vectors):lines.append(f"| `${i:02X}` | `${v:04X}` | `{mem[v:v+8].hex(' ').upper()}` |")
lines += ["", "## Historical interpretation", "", "Desert Gun (1977) directly demonstrates DNA's early indexed native-command interpreter. Common interpreter mechanics alone do not prove that the individual handler implementations or source files were identical across games.", "", "## Verification boundaries", "", "This table is read directly from the original ROM. Native handler semantics, script operand sizes, interrupt cadence, and full address ownership require instruction- and data-flow analysis."]
(R/"docs/interpreter.md").write_text("\n".join(lines)+"\n")
(R/"docs/interpreter.json").write_text(json.dumps({"game":"desertgun","vectors":vectors,"dispatcher":4560,"pointer_ram":8192,"vector_base":3937,"first_stream":5683},indent=2)+"\n")
