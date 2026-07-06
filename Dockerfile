FROM python:3.11-slim

WORKDIR /app

COPY pyproject.toml README.md /app/
COPY niow /app/niow

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir .

ENTRYPOINT ["niow"]
