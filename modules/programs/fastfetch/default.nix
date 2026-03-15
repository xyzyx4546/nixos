{
  programs.fastfetch = {
    enable = true;
    settings = {
      display.separator = "  ";
      modules = [
        "title"
        "separator"
        {
          type = "os";
          key = " OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = " ├─";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = " ├─";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = " ╰─";
          keyColor = "yellow";
        }
        "break"
        {
          type = "wm";
          key = " WM";
          keyColor = "blue";
        }
        {
          type = "command";
          key = " ├─";
          keyColor = "blue";
          text = "dms version | awk -F '+' '{print $1}'";
        }
        {
          type = "terminal";
          key = " ╰─";
          keyColor = "blue";
        }
        "break"
        {
          type = "host";
          key = "󰌢 PC";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = " ├─";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = " ├─";
          keyColor = "green";
        }
        {
          type = "memory";
          key = " ├─";
          keyColor = "green";
        }
        {
          type = "disk";
          key = " ├─";
          keyColor = "green";
        }
        {
          type = "display";
          key = " ├─󰍹";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = " ╰─";
          keyColor = "green";
        }
      ];
    };
  };
}
