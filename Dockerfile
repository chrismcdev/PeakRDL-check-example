FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir peakrdl-check==0.2.2

WORKDIR /app
COPY . .

# The 800k map is a standalone entry (not wired into design.rdl) so the CI
# review gate stays cheap; the preview builds and diffs it directly.
RUN base_dir="$(mktemp -d)" \
    && git clone --quiet --depth 1 --branch main \
        https://github.com/chrismcdev/PeakRDL-check-example.git "$base_dir" \
    && peakrdl-check build registers/800k.rdl -o build/review \
    && peakrdl-check diff \
        --base "$base_dir/registers/design.rdl" \
        --head registers/800k.rdl \
        --format json \
        -o build/review/changes.json \
    && rm -rf "$base_dir"

CMD ["sh", "-c", "exec peakrdl-check serve build/review --host 0.0.0.0 --port \"$PORT\""]
