import http.server
import socketserver
import os

class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

os.chdir(r"d:/web\03_前端工程完整代码")
with socketserver.TCPServer(("", 5173), NoCacheHandler) as httpd:
    print("前端服务器已启动: http://localhost:5173 (no-cache)")
    httpd.serve_forever()
