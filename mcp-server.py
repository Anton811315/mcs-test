import socket

# Server configuration: define the address and port to listen on
HOST = '127.0.0.1'  # Localhost address
PORT = 65432        # Port number to listen on

def handle_request(request):
    """
    Function to handle client requests.
    It takes a text request and returns a text response.
    
    :param request: string request from the client
    :return: string response from the server
    """
    if request == "PING":
        # If the request is "PING", return "PONG"
        return "PONG"
    elif request.startswith("ECHO "):
        # If the request starts with "ECHO ", return the text after "ECHO "
        return request[5:]
    else:
        # If the request is unknown, return an error message
        return "UNKNOWN COMMAND"

def start_server():
    """
    Main function to start the server.
    It creates a socket, listens for incoming connections, and processes requests.
    """
    # Create a socket using IPv4 (AF_INET) and TCP (SOCK_STREAM)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
        # Bind the socket to the specified host and port
        server_socket.bind((HOST, PORT))
        # Start listening for incoming connections
        server_socket.listen()
        print(f"Server started on {HOST}:{PORT}")
        
        # Infinite loop to handle multiple clients
        while True:
            # Wait for a client to connect
            client_socket, client_address = server_socket.accept()
            print(f"Client connected: {client_address}")
            
            # Handle the connected client
            with client_socket:
                while True:
                    # Receive data from the client (up to 1024 bytes)
                    data = client_socket.recv(1024)
                    if not data:
                        # If no data is received, the client has disconnected
                        break
                    
                    # Decode the received data to a string
                    request = data.decode('utf-8')
                    print(f"Received request: {request}")
                    
                    # Process the request using the handle_request function
                    response = handle_request(request)
                    
                    # Send the response back to the client
                    client_socket.sendall(response.encode('utf-8'))

if __name__ == "__main__":
    # If the script is run directly, start the server
    start_server()