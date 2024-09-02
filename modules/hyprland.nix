quasar:
let
  hyprland = quasar.hyprland;
  default = mod: attr: fallback:
    if builtins.hasAttr attr mod then mod.${attr} else fallback;
  hypr = attr: fallback: default hyprland attr fallback;
in {

  #  /*****                                                 /******   /****
  #  |*    |  |*   |    **     ****     **    *****        |*    |  /*    * 
  #  |*    |  |*   |   /* *   /*       /* *   |*   |      |*    |  |*       
  #  |*    |  |*   |  /*   *   ****   /*   *  |*   /     |*    |   ****** 
  #  |*  * |  |*   |  ******       |  ******  *****     |*    |         | 
  #  |*   *   |*   |  |*   |   *   |  |*   |  |*  *    |*    |   *     | 
  #   **** *   ****   |*   |    ****  |*   |  |*   *   ******    *****
  #
  #  ==========================================================================

  # This is the default Hyrpland configuration that ships with QuasarOS.
  # It should be modified from the Quasar configuration, not here.

  exec-once = [ "waybar" "waypaper --restore" ];
  "$mod" = hypr "mod" "SUPER";
  "$Left" = hypr "left" "Left";
  "$Right" = hypr "right" "Right";
  "$Up" = hypr "up" "Up";
  "$Down" = hypr "down" "Down";
  env = [
    "HYPRCURSOR_THEME,Bibata-Modern-Classic"
    "HYPRCURSOR_SIZE,26"
    "XCURSOR_THEME,Bibata-Modern-Classic"
    "XCURSOR_SIZE,26"
  ];
  bind = [
    # Application Keybinds
    "$mod, ${hypr "browserKey" "B"}, exec, ${hypr "browser" "brave"}"
    "$mod, ${hypr "termKey" "Q"}, exec, ${hypr "term" "kitty"}"
    "$mod, ${hypr "fileKey" "E"}, exec, ${hypr "file" "nemo"}"
    "$mod, ${hypr "mailKey" "U"}, exec, ${hypr "mail" "thunderbird"}"

    # Window actions
    "$mod, ${hypr "kill" "C"}, killactive"
    "$mod, ${hypr "exit" "M"}, exit"
    "$mod, ${hypr "float" "V"}, togglefloating"
    "$mod, ${hypr "full" "F"}, fullscreen"

    # Move around
    "$mod, $Left, movefocus, l"
    "$mod, $Right, movefocus, r"
    "$mod, $Up, movefocus, u"
    "$mod, $Down, movefocus, d"

    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod, 0, workspace, 10"

    "$mod, ${hypr "min" "S"}, togglespecialworkspace"

    # Move windows around
    "$mod+Shift, $Left, movewindow, l"
    "$mod+Shift, $Right, movewindow, r"
    "$mod+Shift, $Up, movewindow, u"
    "$mod+Shift, $Down, movewindow, d"

    "$mod+Ctrl+Shift, $Right, movetoworkspace, r+1"
    "$mod+Ctrl+Shift, $Left, movetoworkspace, r-1"

    "$mod+Ctrl, $Right, workspace, r+1"
    "$mod+Ctrl, $Left, workspace, r-1"

    "$mod+Ctrl+Shift, ${hypr "min" "S"}, movetoworkspacesilent, special"

    # Utilities
    "$mod, ${hypr "omni" "Space"}, exec, pkill -x rofi || rofi -show drun" # Run rofi
    ''$mod, ${hypr "screen" "P"}, exec, grim -g "$(slurp)" - | swappy -f -'' # Screenshot
    "$mod, ${hypr "menu" "Backspace"}, exec, wlogout" # Show power menu
  ];
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
    "$mod, Z, movewindow"
    "$mod, X, resizewindow"
  ];
  layerrule = [
    "blur,rofi"
    "ignorezero,rofi"
    "blur,notifications"
    "ignorezero,notifications"
    "blur,swaync-notification-window"
    "ignorezero,swaync-notification-window"
    "blur,swaync-control-center"
    "ignorezero,swaync-control-center"
    "blur,logout_dialog"
  ];
  monitor = hyprland.monitors;
  dwindle = {
    pseudotile = "yes";
    preserve_split = "yes";
  };
  animations = {
    enabled = "yes";
    bezier = [
      "wind, 0.05, 0.9, 0.1, 1.05"
      "winIn, 0.1, 1.1, 0.1, 1.1"
      "winOut, 0.3, -0.3, 0, 1"
      "liner, 1, 1, 1, 1"
    ];
    animation = [
      "windows, 1, 6, wind, slide"
      "windowsIn, 1, 6, winIn, slide"
      "windowsOut, 1, 5, winOut, slide"
      "windowsMove, 1, 5, wind, slide"
      "border, 1, 1, liner"
      "borderangle, 1, 30, liner, loop"
      "fade, 1, 10, default"
      "workspaces, 1, 5, wind"
    ];
  };
  general = {
    gaps_in = "3";
    gaps_out = "8";
    border_size = "2";
    # the dot is a hyprland name, not nix syntax, so we escape it
    "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
    "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
    layout = "dwindle";
    resize_on_border = "true";
    sensitivity = "0.5";
  };
  input.touchpad = {
    natural_scroll = true;
    disable_while_typing = true;
    tap-to-click = true;
  };
  decoration = {
    rounding = "10";
    drop_shadow = "false";
    dim_special = "0.3";
    blur = {
      enabled = "yes";
      size = "6";
      passes = "3";
      new_optimizations = "on";
      ignore_opacity = "on";
      xray = "false";
      special = true;
    };
  };
  misc = { force_default_wallpaper = 0; };
}
