#!/usr/bin/env python3
"""RE-only ROM device inventory.

The maintained map is images/desertgun-memory-map.svg. This analysis utility
updates the textual device inventory, never generates or replaces the SVG.
It is not part of build.sh or build.bat.
"""
from pathlib import Path
from zipfile import ZipFile
import hashlib

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = "desertgu.zip"
NAMES = ("9316.1h", "9316.1g", "9316.1f", "desertgu.e")
SIZE = 2048

with ZipFile(ROOT / "roms" / "original" / ARCHIVE) as archive:
    roms = [archive.read(name) for name in NAMES]

assert all(len(data) == SIZE for data in roms)
rows = [
    "# Desert Gun original ROM devices",
    "",
    "The source of truth is `roms/original/desertgu.zip`.",
    "The maintained graphics map is `images/desertgun-memory-map.svg`.",
    "",
    "| CPU address | Device | SHA-1 |",
    "| --- | --- | --- |",
]
for index, (name, data) in enumerate(zip(NAMES, roms)):
    start = index * SIZE
    end = start + SIZE - 1
    rows.append(
        f"| `${start:04X}–${end:04X}` | `{name}` | `{hashlib.sha1(data).hexdigest()}` |"
    )

(ROOT / "docs" / "memory-map.md").write_text("\n".join(rows) + "\n")
print("PASS original ROM device inventory")
