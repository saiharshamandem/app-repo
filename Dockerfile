# Build stage
FROM python:3.11-slim as builder
WORKDIR /build

# Install dependencies required for psycopg2 compilation
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Final stage
FROM python:3.11-slim
WORKDIR /app

# Install postgres client libraries
RUN apt-get update && apt-get install -y libpq5 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

COPY app/ /app/app/
COPY templates/ /app/templates/

EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--chdir", "/app/app", "app:app"]
