import json
import socket
import tkinter as tk
import threading
from http.server import BaseHTTPRequestHandler, HTTPServer
import pyperclip


class JSONRequestHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        try:
            json_data = json.loads(post_data.decode('utf-8'))
            self.server.set_received_json(json_data)
            self.send_response(200)
        except ValueError:
            self.send_response(400)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()


class JSONServer(HTTPServer):
    def __init__(self, server_address, request_handler_class):
        super().__init__(server_address, request_handler_class)
        self.received_json = None

    def set_received_json(self, json_data):
        self.received_json = json_data


class JSONReceiver:
    def __init__(self, port=8080):
        self.server_address = ('', port)
        self.server = JSONServer(self.server_address, JSONRequestHandler)
        self.server_thread = None

    def start(self):
        self.server_thread = threading.Thread(target=self.server.serve_forever)
        self.server_thread.start()

    def stop(self):
        self.server.shutdown()
        self.server_thread.join()

    def get_ip(self):
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.connect(('8.8.8.8', 80))
            ip_address = s.getsockname()[0]
        return ip_address

    def get_received_json(self):
        return self.server.received_json


class JSONReceiverUI:
    def __init__(self):
        self.receiver = JSONReceiver()
        self.root = tk.Tk()
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)
        self.ip_label = tk.Label(self.root, text='IP address:')
        self.ip_value = tk.Label(self.root, text=self.receiver.get_ip())
        self.json_label = tk.Label(self.root, text='Received List:')
        self.json_value = tk.Label(self.root, text='')
        self.start_server()
        #self.start_button = tk.Button(self.root, text='Start', command=self.start_server)
        #self.stop_button = tk.Button(self.root, text='Stop', command=self.stop_server, state=tk.DISABLED)

    def start_server(self):
        self.receiver.start()
        self.ip_value.configure(text=self.receiver.get_ip())
        #self.start_button.configure(state=tk.DISABLED)
        #self.stop_button.configure(state=tk.NORMAL)
        self.root.after(500, self.update_received_json)

    def stop_server(self):
        self.receiver.stop()
        #self.start_button.configure(state=tk.NORMAL)
        #self.stop_button.configure(state=tk.DISABLED)

    def update_received_json(self):
        received_json = self.receiver.get_received_json()
        if received_json:
            list = '\n'.join(received_json["timesList"])
            self.json_value.configure(text=list)
            pyperclip.copy(list)
        self.root.after(500, self.update_received_json)

    def run(self):
        self.root.title('RemeberTimes List Receiver')
        self.ip_label.grid(row=0, column=0, sticky='W')
        self.ip_value.grid(row=0, column=1, sticky='W')
        self.json_label.grid(row=1, column=0, sticky='W')
        self.json_value.grid(row=1, column=1, sticky='W')
        #self.start_button.grid(row=2, column=0, sticky='W')
        #self.stop_button.grid(row=2, column=1, sticky='W')
        self.root.mainloop()

    def on_close(self):
        self.stop_server()
        self.root.destroy()            


if __name__ == '__main__':
    ui = JSONReceiverUI()
    ui.run()
