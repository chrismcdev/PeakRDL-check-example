FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir peakrdl-check==0.2.0

WORKDIR /app
COPY . .

RUN base_dir="$(mktemp -d)" \
    && git clone --quiet --depth 1 --branch main \
        https://github.com/chrismcdev/PeakRDL-check-example.git "$base_dir" \
    && peakrdl-check build registers/design.rdl -o build/review \
    && peakrdl-check diff \
        --base "$base_dir/registers/design.rdl" \
        --head registers/design.rdl \
        --format json \
        -o build/review/changes.json \
    && rm -rf "$base_dir"

CMD ["sh", "-c", "exec peakrdl-check serve build/review --host 0.0.0.0 --port \"$PORT\""]
