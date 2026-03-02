import socket
import json
import logging

# Настройки сервера
HOST = "127.0.0.1"
PORT = 8080

def handle_request(request):
    """
    Обработка JSONRPC-запроса.
    """
    try:
        # Парсим JSON
        data = json.loads(request)
        
        # Проверяем метод
        if data.get("method") == "ping":
            return json.dumps({"jsonrpc": "2.0", "result": "pong", "id": data.get("id")})
        elif data.get("method") == "echo":
            return json.dumps({"jsonrpc": "2.0", "result": data.get("params"), "id": data.get("id")})
        else:
            return json.dumps({"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found"}, "id": data.get("id")})
    except json.JSONDecodeError:
        return json.dumps({"jsonrpc": "2.0", "error": {"code": -32700, "message": "Parse error"}, "id": None})

def start_server():
    """
    Запуск сервера.
    """
    logging.basicConfig(level=logging.DEBUG)
    logging.debug(f"Starting server on {HOST}:{PORT}")
    
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
        server_socket.bind((HOST, PORT))
        server_socket.listen()
        logging.debug(f"Server is listening on {HOST}:{PORT}")
        
        while True:
            client_socket, client_address = server_socket.accept()
            logging.debug(f"Client connected: {client_address}")
            
            with client_socket:
                while True:
                    data = client_socket.recv(1024)
                    if not data:
                        break
                    
                    request = data.decode("utf-8")
                    logging.debug(f"Received request: {request}")
                    
                    response = handle_request(request)
                    client_socket.sendall(response.encode("utf-8"))

if __name__ == "__main__":
    start_server()