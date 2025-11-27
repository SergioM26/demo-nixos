from http.server import BaseHTTPRequestHandler, HTTPServer

with open("version.txt") as f:
    VERSION = f.read().strip()

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        message = f"Hello from version {VERSION}\n"
        self.send_response(200)
        self.end_headers()
        self.wfile.write(message.encode())

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), Handler)
    print(f"Server running, version {VERSION}")
    server.serve_forever()
