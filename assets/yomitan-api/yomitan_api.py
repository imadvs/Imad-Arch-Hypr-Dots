#!/usr/bin/python3

import os
import sys
import datetime
import traceback

# Setup logging immediately
script_path = os.path.realpath(os.path.dirname(__file__))
def debug_log(msg):
    try:
        utc_time = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d_%H-%M-%S")
        with open(script_path + "/error.log", "a", encoding="utf8") as f:
            f.write(f"{utc_time}, {msg}\n")
    except:
        pass

debug_log("Script entry point reached")

try:
    debug_log("Importing modules...")
    import http.server
    import json
    import signal
    import struct
    import time
    import urllib.parse
    debug_log("Modules imported successfully")

    ADDR = "127.0.0.1"
    PORT = 19633
    PROCESS_STARTUP_WAIT = 5
    YOMITAN_API_NATIVE_MESSAGING_VERSION = 1
    BLACKLISTED_PATHS = ["favicon.ico"]
    crowbarfile_path = script_path + "/.crowbar"

    def ensure_single_instance() -> None:
        wait_time = 0
        try:
            if os.path.exists(crowbarfile_path):
                with open(crowbarfile_path, "r") as crowbarfile:
                    pid_str = crowbarfile.read().strip()
                    if pid_str:
                        os.kill(int(pid_str), signal.SIGTERM)
                        wait_time = PROCESS_STARTUP_WAIT
        except Exception as e:
            debug_log(f"ensure_single_instance non-fatal error: {e}")

        with open(crowbarfile_path, "w") as crowbarfile:
            crowbarfile.write(str(os.getpid()))
        
        if wait_time > 0:
            time.sleep(wait_time)

    def delete_crowbarfile() -> None:
        if os.path.exists(crowbarfile_path):
            os.remove(crowbarfile_path)

    def get_message() -> dict:
        raw_length = sys.stdin.buffer.read(4)
        if not raw_length:
            return None
        message_length = struct.unpack("@I", raw_length)[0]
        message = sys.stdin.buffer.read(message_length).decode("utf-8")
        return json.loads(message)

    def send_message(message_content: dict) -> None:
        encoded_content = json.dumps(message_content).encode("utf-8")
        encoded_length = struct.pack("@I", len(encoded_content))
        sys.stdout.buffer.write(encoded_length)
        sys.stdout.buffer.write(encoded_content)
        sys.stdout.buffer.flush()

    def send_response(request_handler, status_code: int, content_type: str, data: str) -> None:
        request_handler.send_response(status_code)
        request_handler.send_header("Content-type", content_type)
        request_handler.send_header("Access-Control-Allow-Origin", "*")
        request_handler.send_header("Access-Control-Allow-Methods", "*")
        request_handler.send_header("Access-Control-Allow-Headers", "*")
        request_handler.send_header("Cache-Control", "no-store, no-cache, must-revalidate")
        request_handler.end_headers()
        request_handler.wfile.write(bytes(data, "utf-8"))

    def handle_invalid_method(request_handler) -> None:
        request_handler.send_error(405, str(request_handler.command) + " method not allowed, only POST is accepted")
        request_handler.send_header("Allow", "POST")
        request_handler.end_headers()

    class RequestHandler(http.server.BaseHTTPRequestHandler):
        def do_POST(self) -> None:
            try:
                parsed_url = urllib.parse.urlparse(self.path)
                path = parsed_url.path[1:]
                params = urllib.parse.parse_qs(parsed_url.query)
                content_length = int(self.headers["Content-Length"] or 0)
                body = self.rfile.read(content_length).decode("utf-8")

                if path in BLACKLISTED_PATHS:
                    send_response(self, 400, "", "")
                    return

                if path in ["serverVersion", ""]:
                    send_response(self, 200, "application/json", json.dumps({"version": YOMITAN_API_NATIVE_MESSAGING_VERSION}))
                    return

                debug_log(f"Forwarding request to Yomitan: {path}")
                send_message({"action": path, "params": params, "body": body})
                yomitan_response = get_message()

                if yomitan_response is None:
                    debug_log("Error: Received empty response from Yomitan (native messaging closed)")
                    send_response(self, 500, "application/json", json.dumps({"error": "Native messaging host not connected to Yomitan"}))
                    return

                send_response(self, yomitan_response.get("responseStatusCode", 200), "application/json", json.dumps(yomitan_response.get("data", {}), ensure_ascii=False))
            except Exception as e:
                debug_log(f"Error in do_POST: {traceback.format_exc()}")
                send_response(self, 500, "application/json", json.dumps({"error": str(e)}))

        do_GET = handle_invalid_method
        do_HEAD = handle_invalid_method
        do_PUT = handle_invalid_method
        do_DELETE = handle_invalid_method
        do_CONNECT = handle_invalid_method
        do_OPTIONS = handle_invalid_method
        do_TRACE = handle_invalid_method
        do_PATCH = handle_invalid_method

    debug_log("Ensuring single instance...")
    ensure_single_instance()
    
    debug_log(f"Starting HTTP server on {ADDR}:{PORT}...")
    httpd = http.server.HTTPServer((ADDR, PORT), RequestHandler)
    debug_log("Server started. Entering serve_forever loop.")
    httpd.serve_forever()
    
except Exception:
    debug_log(f"CRITICAL ERROR: {traceback.format_exc()}")
finally:
    delete_crowbarfile()
