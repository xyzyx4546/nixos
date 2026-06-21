{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings.bind = let
    lua = lib.generators.mkLuaInline;

    dsp = {
      float = lua ''hl.dsp.window.float({ action = "toggle" })'';
      close = lua "hl.dsp.window.close()";
      fullscreen = lua "hl.dsp.window.fullscreen()";
      drag = lua "hl.dsp.window.drag()";
      resize = lua "hl.dsp.window.resize()";
      exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
      focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
      move = dir: lua ''hl.dsp.window.move({ direction = "${dir}" })'';
      focusMonitor = ws: lua ''hl.dsp.focus({ monitor = "${toString ws}" })'';
      focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
      moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
      moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
      toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    };

    bind = keys: dispatcher: {_args = [keys dispatcher];};
    bindOpts = keys: dispatcher: opts: {_args = [keys dispatcher opts];};
  in [
    # Window Management
    (bind "SUPER + F" dsp.float)
    (bind "SUPER + Q" dsp.close)
    (bind "F11" dsp.fullscreen)

    # Focus Windows
    (bind "SUPER + H" (dsp.focus "left"))
    (bind "SUPER + J" (dsp.focus "down"))
    (bind "SUPER + K" (dsp.focus "up"))
    (bind "SUPER + L" (dsp.focus "right"))

    # Move Windows
    (bind "SUPER + SHIFT + H" (dsp.move "left"))
    (bind "SUPER + SHIFT + J" (dsp.move "down"))
    (bind "SUPER + SHIFT + K" (dsp.move "up"))
    (bind "SUPER + SHIFT + L" (dsp.move "right"))

    # Programs
    (bind "SUPER + C" (dsp.exec "kitty"))
    (bind "SUPER + D" (dsp.exec "vesktop"))
    (bind "SUPER + N" (dsp.exec "kitty nvim"))
    (bind "SUPER + S" (dsp.exec "kitty --class=left spotify_player"))
    (bind "SUPER + Y" (dsp.exec "kitty yazi"))

    (bind "PRINT" (dsp.exec "${pkgs.grimblast}/bin/grimblast --notify --freeze copysave area"))
    (bind "SUPER + SPACE" (dsp.exec "dms ipc spotlight toggle"))
    (bind "SUPER + V" (dsp.exec "dms ipc clipboard toggle"))
    (bind "SUPER + W" (dsp.exec "dms ipc dankdash wallpaper"))
    (bind "SUPER + X" (dsp.exec "dms ipc powermenu toggle"))
    (bind "SUPER + SHIFT + R" (dsp.exec "hyprctl reload"))

    # Workspaces & Monitors
    (bind "SUPER + CONTROL + H" (dsp.focusMonitor 0))
    (bind "SUPER + CONTROL + H" (dsp.focusWorkspace "m-1"))
    (bind "SUPER + CONTROL + L" (dsp.focusMonitor 0))
    (bind "SUPER + CONTROL + L" (dsp.focusWorkspace "m+1"))

    (bind "SUPER + SHIFT + CONTROL + H" (dsp.moveToWorkspace "m-1"))
    (bind "SUPER + SHIFT + CONTROL + L" (dsp.moveToWorkspace "m+1"))

    (bind "SUPER + Tab" (dsp.focusMonitor "+1"))
    (bind "SUPER + SHIFT + Tab" (dsp.focusMonitor "-1"))

    # Special Workspaces
    (bind "SUPER + B" (dsp.focusMonitor 0))
    (bind "SUPER + B" (dsp.toggleSpecial "browser"))
    (bind "SUPER + G" (dsp.focusMonitor 0))
    (bind "SUPER + G" (dsp.toggleSpecial "games"))
    (bind "SUPER + SUPER_L" (dsp.focusMonitor 1))
    (bind "SUPER + SUPER_L" (dsp.toggleSpecial "browser"))

    # Media & Hardware Controls
    (bindOpts "XF86AudioMute" (dsp.exec "dms ipc audio mute") {locked = true;})
    (bindOpts "XF86AudioNext" (dsp.exec "dms ipc mpris next") {locked = true;})
    (bindOpts "XF86AudioPlay" (dsp.exec "dms ipc mpris playPause") {locked = true;})
    (bindOpts "XF86AudioPrev" (dsp.exec "dms ipc mpris previous") {locked = true;})

    (bindOpts "XF86AudioRaiseVolume" (dsp.exec "dms ipc audio increment 5") {
      locked = true;
      repeating = true;
    })
    (bindOpts "XF86AudioLowerVolume" (dsp.exec "dms ipc audio decrement 5") {
      locked = true;
      repeating = true;
    })
    (bindOpts "XF86MonBrightnessUp" (dsp.exec "dms ipc brightness increment 10 ''") {
      locked = true;
      repeating = true;
    })
    (bindOpts "XF86MonBrightnessDown" (dsp.exec "dms ipc brightness decrement 10 ''") {
      locked = true;
      repeating = true;
    })

    # Mouse Bindings
    (bindOpts "mouse:277" dsp.drag {
      mouse = true;
      drag = true;
    })
    (bindOpts "ALT + mouse:272" dsp.resize {
      mouse = true;
      drag = true;
    })
  ];
}
