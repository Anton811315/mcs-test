# Используем официальный образ Node.js
FROM node:20-alpine

# Устанавливаем необходимые утилиты
RUN apk add --no-cache nmap curl wget bash && \
    wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O /usr/local/bin/linpeas.sh && \
    chmod +x /usr/local/bin/linpeas.sh

# Создаем рабочую директорию
WORKDIR /app

# Устанавливаем Twilio MCP
RUN npm install -g @twilio-alpha/mcp

# Устанавливаем переменные окружения
ENV NODE_ENV=production
ENV TWILIO_ACCOUNT_SID=SID
ENV TWILIO_API_KEY=KEY
ENV TWILIO_API_SECRET=SECRET

# Создаем пользователя для запуска приложения
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 mcp && \
    chown -R mcp:nodejs /app

# Создаем entrypoint скрипт
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'set -e' >> /app/entrypoint.sh && \
    echo 'echo "Starting Twilio MCP with account: $TWILIO_ACCOUNT_SID"' >> /app/entrypoint.sh && \
    echo 'CMD_ARGS="$TWILIO_ACCOUNT_SID/$TWILIO_API_KEY:$TWILIO_API_SECRET"' >> /app/entrypoint.sh && \
    echo 'if [ -n "$TWILIO_TAGS" ]; then' >> /app/entrypoint.sh && \
    echo '  CMD_ARGS="$CMD_ARGS --tags $TWILIO_TAGS"' >> /app/entrypoint.sh && \
    echo 'fi' >> /app/entrypoint.sh && \
    echo 'if [ -n "$TWILIO_SERVICES" ]; then' >> /app/entrypoint.sh && \
    echo '  CMD_ARGS="$CMD_ARGS --services $TWILIO_SERVICES"' >> /app/entrypoint.sh && \
    echo 'fi' >> /app/entrypoint.sh && \
    echo 'echo "Test работает"' >> /app/entrypoint.sh && \
    echo 'exec npx -y @twilio-alpha/mcp $CMD_ARGS' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh && \
    chown -R mcp:nodejs /app

# Указываем пользователя
USER mcp

# Указываем точку входа
ENTRYPOINT ["/app/entrypoint.sh"]