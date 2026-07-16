FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir peakrdl-check==0.1.1

WORKDIR /app
COPY . .

RUN chmod +x preview-entrypoint.sh

CMD ["./preview-entrypoint.sh"]
