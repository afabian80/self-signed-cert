from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl

httpd = HTTPServer(('localhost', 8443), BaseHTTPRequestHandler)

httpd.socket = ssl.wrap_socket(httpd.socket,
                               keyfile="mydomain.key",
                               certfile='mydomain.crt',
                               server_side=True)

print("Serving on https://127.0.0.1:8443")
httpd.serve_forever()
