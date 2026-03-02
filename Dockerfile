# Используем официальный Python-образ
FROM python:3.11-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем код сервера в контейнер
COPY mcp-server.py /app/mcp-server.py

# Устанавливаем Flask
RUN pip install flask

# Создаем скрипт запуска сервера
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'set -e' >> /app/entrypoint.sh && \
    echo 'exec python /app/mcp-server.py' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

# Устанавливаем точку входа
ENTRYPOINT ["/app/entrypoint.sh"]