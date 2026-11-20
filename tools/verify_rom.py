#!/usr/bin/env python3
"""Verify the assembled Desert Gun image and package the MAME ROM set."""
import hashlib
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = "desertgu.zip"
DEVICES = ("9316.1h", "9316.1g", "9316.1f", "desertgu.e")
DEVICE_SIZE = 2048

with zipfile.ZipFile(ROOT / "roms" / "original" / ARCHIVE) as source:
    original = [source.read(name) for name in DEVICES]

assert all(len(part) == DEVICE_SIZE for part in original)
reference = b"".join(original)
rebuilt = ROOT / "build" / "desertgu.bin"
assert rebuilt.exists(), f"Missing assembled image: {rebuilt}"
actual = rebuilt.read_bytes()
assert len(actual) == len(reference), (len(actual), len(reference))

for index, (found, expected) in enumerate(zip(actual, reference)):
    assert found == expected, (
        "First ROM byte mismatch at CPU ${:04X}: {:02X} != {:02X}"
        .format(index, found, expected)
    )

out = ROOT / "build"
out.mkdir(parents=True, exist_ok=True)
for index, (name, expected) in enumerate(zip(DEVICES, original)):
    part = actual[index * DEVICE_SIZE:(index + 1) * DEVICE_SIZE]
    assert part == expected
    (out / name).write_bytes(part)
    print("PASS", name, len(part), "SHA1", hashlib.sha1(part).hexdigest())

print("PASS exact desertgu", len(reference), "SHA256", hashlib.sha256(actual).hexdigest())

archive_path = ROOT / "roms" / ARCHIVE
with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as packed:
    for name in DEVICES:
        packed.write(out / name, arcname=name)

with zipfile.ZipFile(archive_path) as packed:
    assert packed.namelist() == list(DEVICES)
    assert all(packed.read(name) == original[index] for index, name in enumerate(DEVICES))

print("PASS MAME ROM archive", archive_path)
