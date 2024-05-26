FROM python:3
COPY . sqlmap-dev
ARG WEBSOCKET_CLIENT=websocket-client
RUN apt update && apt install -y tor && \
    pip install $WEBSOCKET_CLIENT
ENTRYPOINT ["python","sqlmap-dev/sqlmap.py"]
CMD ["-h"]