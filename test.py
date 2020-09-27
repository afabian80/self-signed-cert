from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl

httpd = HTTPServer(('localhost', 8443), SimpleHTTPRequestHandler)

httpd.socket = ssl.wrap_socket(httpd.socket,
                               keyfile="mydomain.key",
                               certfile='mydomain.crt',
                               server_side=True)

print("Update /etc/hosts to include \"127.0.0.1   mydomain.com\"")
print("Serving on https://mydomain.com:8443")
httpd.serve_forever()
