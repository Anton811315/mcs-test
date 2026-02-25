# Use the official Python image as the base image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the MCP server code into the container
COPY mcp_server.py /app/mcp_server.py

# Install any required Python dependencies (if you have a requirements.txt)
# Uncomment the following lines if you have dependencies
# COPY requirements.txt /app/requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables for configuration (if needed)
ENV HOST=127.0.0.1
ENV PORT=65432

# Create a non-root user for security
RUN addgroup --system --gid 1001 pythonusers && \
    adduser --system --uid 1001 mcp && \
    chown -R mcp:pythonusers /app

# Create an entrypoint script to start the MCP server
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'set -e' >> /app/entrypoint.sh && \
    echo 'echo "Starting MCP Server on $HOST:$PORT"' >> /app/entrypoint.sh && \
    echo 'exec python /app/mcp_server.py $HOST $PORT' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh && \
    chown -R mcp:pythonusers /app

# Switch to the non-root user
USER mcp

# Set the entrypoint to the script
ENTRYPOINT ["/app/entrypoint.sh"]