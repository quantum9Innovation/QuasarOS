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
    # Application keybinds
    "$mod, ${hypr "browserKey" "B"}, exec, ${hypr "browser" "brave"}"
    "$mod, ${hypr "termKey" "Q"}, exec, ${hypr "term" "kitty"}"
    "$mod, ${hypr "fileKey" "E"}, exec, ${hypr "file" "nemo"}"
    "$mod, ${hypr "mailKey" "U"}, exec, ${hypr "mail" "thunderbird"}"

    # Window actions
    "$mod, ${hypr "kill" "C"}, killactive"
    "$mod, ${hypr "exit" "M"}, exit"
    "$mod, ${hypr "float" "V"}, togglefloating"
    "$mod, ${hypr "full" "F"}, fullscreen, 1"
    "$mod+Alt, ${hypr "full" "F"}, fullscreen, 0"
    "$mod, ${hypr "last" "L"}, focusurgentorlast"

	# Hyprscroller
    "$mod, ${hypr "view" "A"}, scroller:toggleoverview"
    "$mod, ${hypr "fit" "J"}, scroller:fitsize"
    "$mod+Shift, $Up, scroller:cyclesize, +1"
    "$mod+Shift, $Down, scroller:cyclesize, -1"

    # Resizing
    "$mod+Alt, 1, resizeactive, exact 50% 95%"
    "$mod+Alt, 2, resizeactive, exact 50% 47%"
    "$mod+Alt, 3, resizeactive, exact 50% 31%"
    "$mod+Alt, 4, resizeactive, exact 50% 23%"
    "$mod+Alt, 5, resizeactive, exact 50% 63%"
    "$mod+Alt, 7, resizeactive, exact 50% 71%"

    # Move around
    "$mod, $Left, scroller:movefocus, l"
    "$mod, $Right, scroller:movefocus, r"
    "$mod, $Up, scroller:movefocus, u"
    "$mod, $Down, scroller:movefocus, d"

	# Change workspaces
    "$mod, 0, workspace, 10"
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod+Shift, 0, movetoworkspace, 10"
    "$mod+Shift, 1, movetoworkspace, 1"
    "$mod+Shift, 2, movetoworkspace, 2"
    "$mod+Shift, 3, movetoworkspace, 3"
    "$mod+Shift, 4, movetoworkspace, 4"
    "$mod+Shift, 5, movetoworkspace, 5"
    "$mod+Shift, 6, movetoworkspace, 6"
    "$mod+Shift, 7, movetoworkspace, 7"
    "$mod+Shift, 8, movetoworkspace, 8"
    "$mod+Shift, 9, movetoworkspace, 9"
    "$mod+Shift, 0, movetoworkspace, 10"

    # Move windows around
    "$mod+Shift, $Left, scroller:movewindow, l"
    "$mod+Shift, $Left, scroller:alignwindow, l"
    "$mod+Shift, $Right, scroller:movewindow, r"
    "$mod+Shift, $Right, scroller:alignwindow, r"
    "$mod+Shift, $Up, scroller:movewindow, u"
    "$mod+Shift, $Up, scroller:alignwindow, u"
    "$mod+Shift, $Down, scroller:movewindow, d"
    "$mod+Shift, $Down, scroller:alignwindow, d"
    "$mod, comma, scroller:admitwindow"
    "$mod, period, scroller:expelwindow"

	# Workspace shortcuts
    "$mod+Ctrl+Shift, $Down, movetoworkspace, r+1"
    "$mod+Ctrl+Shift, $Up, movetoworkspace, r-1"
    "$mod+Ctrl, $Down, workspace, r+1"
    "$mod+Ctrl, $Up, workspace, r-1"
    "$mod, ${hypr "min" "S"}, togglespecialworkspace"
    "$mod+Ctrl+Shift, ${hypr "min" "S"}, movetoworkspacesilent, special"

    # Utilities
    "$mod, ${
      hypr "omni" "Space"
    }, exec, pkill -x rofi || rofi -show drun" # Run rofi
    ''
      $mod, ${
        hypr "screen" "P"
      }, exec, grim -g "$(slurp)" - | swappy -f -'' # Screenshot
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
  animations = {
    enabled = "yes";
    bezier = [
      "smooth, 0.05, 0.9, 0.1, 1.05"
      "jump, 0.4, 0.0, 0.2, 1"
      "bounce, 0.4, -0.25, 0.2, 1.33"
    ];
    animation = [
      "windows, 1, 8, bounce"
      "windowsOut, 1, 8, bounce, popin 80%"
      "border, 1, 4, jump"
      "borderangle, 1, 4, jump"
      "fade, 1, 4, jump"
      "workspaces, 1, 8, bounce, slidefadevert"
    ];
  };
  general = {
    gaps_in = "5";
    gaps_out = "20";
    border_size = "4";
    # the dot is a hyprland name, not nix syntax, so we escape it
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(00000000)";
    layout = "scroller";
    resize_on_border = "true";
    sensitivity = "0.5";
    allow_tearing = "false";
  };
  input.touchpad = {
    natural_scroll = true;
    disable_while_typing = true;
    tap-to-click = true;
  };
  decoration = {
    rounding = "14";
    drop_shadow = "false";
    blur = {
      enabled = "yes";
      size = "6";
      passes = "2";
      brightness = "1.0";
      contrast = "2.0";
      vibrancy = "1.0";
      new_optimizations = "on";
      ignore_opacity = "on";
      noise = "0";
      xray = "false";
      special = true;
    };
  };
  misc = { force_default_wallpaper = 0; };
}
