import argparse
import socket
import os
import subprocess
import json
from material_color_utilities_python import *
import time

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
    workspace = [w for w in get_workspaces() if w['id'] == 98][0]
    if workspace['windows'] == 0:
      subprocess.run(['firefox'])

  elif OPTION == "close_empty":
    socket_path = f"{os.getenv('XDG_RUNTIME_DIR')}/hypr/{os.getenv('HYPRLAND_INSTANCE_SIGNATURE')}/.socket2.sock"

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client_socket:
      client_socket.connect(socket_path)
      while True:
        line = client_socket.recv(1024).decode('utf-8')
        if not line:
          break
        result = subprocess.run(['hyprctl', '-j', 'activeworkspace'], capture_output=True, text=True)
        if line[:11] == "closewindow" and json.loads(result.stdout)['windows'] == 0 and json.loads(result.stdout)['id'] != 99:
          subprocess.run(['hyprctl', 'dispatch', 'workspace', 'm-1'])
            
