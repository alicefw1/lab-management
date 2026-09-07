# -*- coding: utf-8 -*-
import subprocess, os, time

# 1. 停掉旧的 5173 前端服务
import signal
result = subprocess.run('netstat -ano | findstr :5173', shell=True, capture_output=True, text=True)
print('当前5173占用:')
print(result.stdout)

# 2. 杀掉占用 5173 的进程
pids = set()
for line in result.stdout.split('\n'):
    parts = line.split()
    if len(parts) >= 5 and 'LISTENING' in line:
        pids.add(parts[-1])

for pid in pids:
    subprocess.run(f'taskkill /F /PID {pid}', shell=True, capture_output=True)
    print(f'已停掉 PID {pid}')

time.sleep(2)

# 3. 重新启动前端服务器（带 no-cache 头，防止浏览器缓存）
front_dir = os.path.join('d:/web', '03_前端工程完整代码')

# 用 Python http.server 自定义处理器，添加 no-cache 头
server_code = '''import http.server
import socketserver
import os

class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

os.chdir(r"''' + front_dir + '''")
with socketserver.TCPServer(("", 5173), NoCacheHandler) as httpd:
    print("前端服务器已启动: http://localhost:5173 (no-cache)")
    httpd.serve_forever()
'''

server_file = os.path.join('d:/web', '_front_server.py')
with open(server_file, 'w', encoding='utf-8') as f:
    f.write(server_code)

# 后台启动
proc = subprocess.Popen(['python', server_file], creationflags=subprocess.CREATE_NEW_PROCESS_GROUP)
print(f'前端服务器已后台启动 PID: {proc.pid}')
print('等待启动...')
time.sleep(3)
print('完成！请刷新浏览器访问 http://localhost:5173/board_dashboard.html')
