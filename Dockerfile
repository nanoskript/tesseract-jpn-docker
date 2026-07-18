FROM python:3.10-slim-buster

# Install system dependencies.
# Buster is EOL: its packages moved to archive.debian.org and the Release
# files are no longer refreshed. Staying on buster keeps tesseract at 4.x
# (bookworm ships 5.x, which changes OCR output).
RUN sed -i 's|deb.debian.org|archive.debian.org|g; /buster-updates/d' /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-jpn \
    tesseract-ocr-jpn-vert

# Install dependencies.
RUN pip install --no-cache-dir pdm
ADD ./pyproject.toml ./pdm.lock ./
RUN pdm sync && pdm cache clear

ADD ./main.py ./
CMD pdm run uvicorn --host 0.0.0.0 --port $PORT main:app

