#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build roms docs
python3 tools/audit_words.py
python3 tools/recover_8080.py desertgun
python3 tools/interpreter_lineage.py
python3 tools/memory_map.py
./tools/zmac -c -o build/desertgu.bin -x build/desertgu.lst src/desertgun.asm
python3 tools/verify_rom.py
