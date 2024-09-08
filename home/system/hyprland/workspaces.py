import argparse
import socket
import os
import subprocess
import json

def get_workspaces(monitor=None):
    result = subprocess.run(['hyprctl', '-j', 'workspaces'], capture_output=True, text=True)
    workspaces = json.loads(result.stdout)

    if monitor is not None:
        workspaces = [w for w in workspaces if w['monitorID'] == monitor]

    return workspaces

def get_new_workspace():
    workspaces = get_workspaces(0)
    last_workspace = workspaces[-1]
    return last_workspace['id'] + 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("OPTION")
    OPTION = parser.parse_args().OPTION

    if OPTION == "focus_new":
        subprocess.run(['hyprctl', 'dispatch', 'workspace', str(get_new_workspace())])

    elif OPTION == "move_to_new":
        subprocess.run(['hyprctl', 'dispatch', 'movetoworkspace', str(get_new_workspace())])

    elif OPTION == "browser":
        subprocess.run(['hyprctl', 'dispatch', 'workspace', '98'])
        windows = json.loads(subprocess.run(['hyprctl', '-j', 'clients'], capture_output=True, text=True).stdout)
        if not any(window["class"] == "firefox" for window in windows):
            subprocess.run(['firefox'])

    elif OPTION == "toggle_second_monitor":
        cursorpos = json.loads(subprocess.run(['hyprctl', '-j', 'cursorpos'], capture_output=True, text=True).stdout)
        window = json.loads(subprocess.run(['hyprctl', '-j', 'activewindow'], capture_output=True, text=True).stdout)
        subprocess.run(['hyprctl', 'dispatch', 'focusmonitor', '1'])
        subprocess.run(['hyprctl', 'dispatch', 'workspace', 'm+1'])
        if window['monitor'] != 1:
            subprocess.run(['hyprctl', 'dispatch', 'focuswindow', f'address:{window['address']}'])
            subprocess.run(['hyprctl', 'dispatch', 'movecursor', str(cursorpos['x']), str(cursorpos['y'])])

    elif OPTION == "close_empty":
        socket_path = f"{os.getenv('XDG_RUNTIME_DIR')}/hypr/{os.getenv('HYPRLAND_INSTANCE_SIGNATURE')}/.socket2.sock"
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client_socket:
            client_socket.connect(socket_path)
            while True:
                line = client_socket.recv(1024).decode('utf-8')
                if not line:
                    break
                w = json.loads(subprocess.run(['hyprctl', '-j', 'activeworkspace'], capture_output=True, text=True).stdout)
                if line[:11] == "closewindow" and w['windows'] == 0 and w['id'] != 99:
                    subprocess.run(['hyprctl', 'dispatch', 'workspace', 'm-1'])
