from flask import Flask, request, jsonify
import logging

app = Flask(__name__)

# Настройка логирования
logging.basicConfig(level=logging.DEBUG)

@app.route("/mcp", methods=["POST"])
def handle_request():
    """
    Обработка JSONRPC-запросов.
    """
    try:
        # Получаем JSONRPC-запрос из тела HTTP-запроса
        data = request.get_json()
        logging.debug(f"Received JSONRPC request: {data}")

        # Проверяем метод
        if data.get("method") == "ping":
            return jsonify({"jsonrpc": "2.0", "result": "pong", "id": data.get("id")})
        elif data.get("method") == "initialize":
            return jsonify({"jsonrpc": "2.0", "result": {"status": "initialized"}, "id": data.get("id")})
        else:
            return jsonify({"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": data.get("id")})
    except Exception as e:
        logging.error(f"Error processing request: {e}")
        return jsonify({"jsonrpc": "2.0", "error": {"code": -32700, "message": "Parse error"}, "id": None})

if __name__ == "__main__":
    # Запуск HTTP-сервера на порту 8080
    app.run(host="0.0.0.0", port=8080)