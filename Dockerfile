# Используем официальный Python-образ
FROM python:3.11-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем код сервера в контейнер
COPY mcp-server.py /app/mcp-server.py

# Устанавливаем переменные окружения
ENV HOST=127.0.0.1
ENV PORT=65432

# Создаем пользователя для безопасности
RUN addgroup --system --gid 1001 pythonusers && \
    adduser --system --uid 1001 mcp && \
    chown -R mcp:pythonusers /app

# Создаем скрипт запуска сервера
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'set -e' >> /app/entrypoint.sh && \
    echo 'echo "Starting MCP Server on $HOST:$PORT"' >> /app/entrypoint.sh && \
    echo 'exec python /app/mcp-server.py' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh && \
    chown -R mcp:pythonusers /app

# Переключаемся на пользователя
USER mcp

# Устанавливаем точку входа
ENTRYPOINT ["/app/entrypoint.sh"]