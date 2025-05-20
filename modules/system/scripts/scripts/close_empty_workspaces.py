import socket
import os
import subprocess
import json

if __name__ == "__main__":
    socket_path = f"{os.getenv('XDG_RUNTIME_DIR')}/hypr/{os.getenv('HYPRLAND_INSTANCE_SIGNATURE')}/.socket2.sock"
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client_socket:
        client_socket.connect(socket_path)
        while True:
            line = client_socket.recv(1024).decode("utf-8")
            if not line:
                break
            w = json.loads(
                subprocess.run(
                    ["hyprctl", "-j", "activeworkspace"],
                    capture_output=True,
                    text=True,
                ).stdout
            )
            if line[:11] == "closewindow" and w["windows"] == 0 and w["id"] != 99:
                subprocess.run(["hyprctl", "dispatch", "workspace", "m-1"])
