import argparse
import subprocess
import json


def get_workspaces(monitor=None):
    result = subprocess.run(
        ["hyprctl", "-j", "workspaces"], capture_output=True, text=True
    )
    workspaces = json.loads(result.stdout)

    if monitor is not None:
        workspaces = [w for w in workspaces if w["monitorID"] == monitor]

    workspaces = [w for w in workspaces if not w["name"].startswith("special:")]

    return workspaces


def get_active_workspace():
    result = subprocess.run(
        ["hyprctl", "-j", "activeworkspace"], capture_output=True, text=True
    )
    return json.loads(result.stdout)


def get_new_workspace():
    workspaces = get_workspaces(0)
    last_workspace = workspaces[-1]
    return last_workspace["id"] + 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "action",
        choices=["move", "switch"],
        help="Specify the option: 'move' or 'switch'",
    )
    parser.add_argument(
        "option",
        choices=["new"],
        help="Specify the action",
    )
    args = parser.parse_args()
    ACTION = "movetoworkspace" if args.action == "move" else "workspace"
    OPTION = args.option

    if OPTION == "new":
        subprocess.run(["hyprctl", "dispatch", "focusmonitor", "0"])
        subprocess.run(["hyprctl", "dispatch", ACTION, str(get_new_workspace())])
