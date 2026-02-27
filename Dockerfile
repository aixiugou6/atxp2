FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Playwright/Chromium 运行依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdbus-1-3 libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 \
    libx11-xcb1 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 \
    libxrandr2 xdg-utils fonts-liberation \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt \
 && python -m playwright install chromium

# 把整个项目写进镜像（必须）
COPY . /app

RUN mkdir -p /app/data
EXPOSE 8741

# 用 /app/data/accounts.json 作为账号池（配合 Zeabur Volume）
CMD ["python", "api_server.py", "-a", "/app/data/accounts.json", "-p", "8741"]
