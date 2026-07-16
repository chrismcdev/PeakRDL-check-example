#!/bin/sh
set -eu

: "${PORT:?Set PORT to the viewer listening port}"

base_dir="$(mktemp -d)"
trap 'rm -rf "$base_dir"' EXIT

git clone --quiet --depth 1 --branch main \
    https://github.com/chrismcdev/PeakRDL-check-example.git "$base_dir"

peakrdl-check build registers/design.rdl -o build/review
peakrdl-check diff \
    --base "$base_dir/registers/design.rdl" \
    --head registers/design.rdl \
    --format json \
    -o build/review/changes.json

rm -rf "$base_dir"
trap - EXIT

exec peakrdl-check serve build/review --host 0.0.0.0 --port "$PORT"
