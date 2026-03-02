FROM python:3.12-alpine

WORKDIR /app

RUN pip install --no-cache-dir mcp

# Пишем минимальный MCP-сервер с одним tool "ping"
RUN cat > /app/server.py <<'PY'
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("test-mcp")

@mcp.tool()
def ping(text: str = "hello") -> str:
    return f"pong: {text}"

if __name__ == "__main__":
    mcp.run(transport="stdio")
PY

CMD ["python", "/app/server.py"]