FROM python:3.9-slim-bullseye

WORKDIR /home
COPY setup.py .
COPY main.py .

RUN apt update && apt upgrade -y

RUN groupadd -g 999 appusers && \
    useradd -r -u 999 -g appusers appuser

RUN pip install --no-cache-dir --upgrade pip setuptools
RUN pip install --no-cache-dir --upgrade -e .

USER appuser

CMD uvicorn main:service --host 0.0.0.0 --port 8001