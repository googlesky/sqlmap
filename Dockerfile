FROM python:3-slim

# Keep Python lean and logs unbuffered
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ARG WEBSOCKET_CLIENT=websocket-client
ARG BUILDTIME
ARG VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --upgrade pip \
    && pip install --no-cache-dir "$WEBSOCKET_CLIENT"

WORKDIR /sqlmap-dev
COPY . /sqlmap-dev

ENTRYPOINT ["python", "sqlmap.py"]
CMD ["-h"]