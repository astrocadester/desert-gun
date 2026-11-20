#!/usr/bin/env bash
# Desert Gun ROM build — original Intel 8080 source, zmac v1.3; no Python.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

fail() { echo "ERROR: $*" >&2; exit 1; }
for cmd in dd sha1sum zip stat; do
    command -v "$cmd" >/dev/null 2>&1 || fail "Missing command: $cmd"
done
if [[ -n "${ZMAC:-}" ]]; then
    zmac_bin="$ZMAC"
elif [[ -x tools/zmac ]]; then
    zmac_bin=tools/zmac
else
    zmac_bin=zmac
fi
command -v "$zmac_bin" >/dev/null 2>&1 || fail 'zmac v1.3 not found (set ZMAC or use tools/zmac)'
[[ -f src/desertgun.asm ]] || fail 'Missing src/desertgun.asm'

rom_names=(9316.1h 9316.1g 9316.1f desertgu.e)
rom_sha1=(
    4d0a3a59d4f8181c6e30966a6b1d19ba5b29c398
    8fb8e85844a8ec6c0722883013ecdd4eeaeb08c1
    1cc4e9b0aa7e9546c133bd40d40ede6f2fbe93ba
    202433dfb174901bd3b91e843d9d697a8333ef9e
)

echo 'Desert Gun ROM build'
echo '[1/4] Prepare output'
mkdir -p build roms
rm -f build/desertgu.bin build/desertgu.lst roms/desertgu.zip
for name in "${rom_names[@]}"; do rm -f "build/$name"; done

echo '[2/4] Assemble Intel 8080 source (zmac v1.3)'
"$zmac_bin" -c -o build/desertgu.bin -x build/desertgu.lst src/desertgun.asm || fail 'Assembly failed'
[[ -s build/desertgu.bin ]] || fail 'Assembler did not produce a binary image'
size=$(stat -c %s build/desertgu.bin)
(( size == 8192 )) || fail "Binary image is $size bytes; expected 8192"

echo '[3/4] Split and verify four 2 KB ROMs'
for i in 0 1 2 3; do
    name=${rom_names[i]}
    dd if=build/desertgu.bin of="build/$name" bs=2048 skip="$i" count=1 status=none
    size=$(stat -c %s "build/$name")
    (( size == 2048 )) || fail "$name is $size bytes; expected 2048"
    actual=$(sha1sum "build/$name"); actual=${actual%% *}
    if [[ "$actual" != "${rom_sha1[i]}" ]]; then
        echo "ERROR: $name SHA1 mismatch: expected ${rom_sha1[i]}, got $actual" >&2
        if command -v unzip >/dev/null 2>&1 && command -v cmp >/dev/null 2>&1; then
            echo "First byte differences (device offset is decimal, values are octal):" >&2
            echo "  offset  original  assembled" >&2
            cmp -l <(unzip -p roms/original/desertgu.zip "$name") "build/$name" |
                awk 'NR<=30 {printf "  %6d  %8s  %9s\n", $1-1, $2, $3} END {printf "  Total differing bytes: %d\n", NR}' >&2 || true
        fi
        fail "ROM verification failed; original ROM archive and generated bank remain available"
    fi
    echo "  $name  OK  $actual"
done

echo '[4/4] Package roms/desertgu.zip'
(cd build && zip -q -X ../roms/desertgu.zip "${rom_names[@]}") || fail 'ZIP packaging failed'
[[ -s roms/desertgu.zip ]] || fail 'ROM ZIP was not created'
echo 'Build complete: roms/desertgu.zip'
