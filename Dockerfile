FROM python:3
COPY . sqlmap-dev
ARG WEBSOCKET_CLIENT=websocket-client==1.8.*
RUN apt update && apt install -y tor curl && \
    pip install $WEBSOCKET_CLIENT && \
    curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"
ENTRYPOINT ["uv","run","sqlmap-dev/sqlmap.py"]
CMD ["-h"]