FROM python:3
COPY . sqlmap-dev
RUN apt update && apt install -y tor
ENTRYPOINT ["python","sqlmap-dev/sqlmap.py"]
CMD ["-h"]