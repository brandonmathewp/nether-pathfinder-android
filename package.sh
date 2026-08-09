#!/usr/bin/env bash
set -e

if [ ! -f "libnether_pathfinder.so" ]; then
    echo "Run build.sh first to build libnether_pathfinder.so"
    exit 1
fi

VERSION="${1:-1.4.1}"
OFFICIAL_JAR_URL="https://babbaj.github.io/maven/dev/babbaj/nether-pathfinder/${VERSION}/nether-pathfinder-${VERSION}.jar"
OUTPUT_JAR="nether-pathfinder-${VERSION}-android.jar"

echo "Downloading official v${VERSION} JAR..."
wget -q "$OFFICIAL_JAR_URL" -O /tmp/np-orig.jar

python3 - "$OUTPUT_JAR" << 'PYEOF'
import lzma, zipfile, io, sys

JAR_IN = '/tmp/np-orig.jar'
NEW_SO = 'libnether_pathfinder.so'
JAR_OUT = sys.argv[1]

with zipfile.ZipFile(JAR_IN, 'r') as z:
    jar_entries = {n: z.read(n) for n in z.namelist() if n != 'natives.zip.xz'}
    old_xz = z.read('natives.zip.xz')

old_zip_data = lzma.decompress(old_xz)
with zipfile.ZipFile(io.BytesIO(old_zip_data), 'r') as old_z:
    natives = {n: old_z.read(n) for n in old_z.namelist()}

orig_size = len(natives['libnether_pathfinder-aarch64.so'])
new_size = len(open(NEW_SO, 'rb').read())
print(f"Replacing libnether_pathfinder-aarch64.so: {orig_size} -> {new_size} bytes")
natives['libnether_pathfinder-aarch64.so'] = open(NEW_SO, 'rb').read()

new_zip_buf = io.BytesIO()
with zipfile.ZipFile(new_zip_buf, 'w', zipfile.ZIP_STORED) as new_z:
    for name, data in natives.items():
        new_z.writestr(name, data)
new_xz = lzma.compress(new_zip_buf.getvalue())

with zipfile.ZipFile(JAR_OUT, 'w', zipfile.ZIP_DEFLATED) as out_z:
    for name, data in jar_entries.items():
        out_z.writestr(name, data)
    out_z.writestr('natives.zip.xz', new_xz)

print(f"Wrote {JAR_OUT}")
PYEOF

echo "Done: $OUTPUT_JAR"
