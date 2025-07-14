quasar: utils:
let
  inherit (quasar) hyprland;
  hypr = attr: fallback: utils.default hyprland attr fallback;
  inherit (quasar) config lib;
in
{

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

  exec-once = [
    "swww-daemon; swww restore;"
    "clipse -listen"
  ];
  "$mod" = hypr "mod" "SUPER";
  "$Left" = hypr "left" "H";
  "$Right" = hypr "right" "L";
  "$Up" = hypr "up" "K";
  "$Down" = hypr "down" "J";
  env = [
    "HYPRCURSOR_THEME,Bibata-Modern-Classic"
    "HYPRCURSOR_SIZE,26"
    "XCURSOR_THEME,Bibata-Modern-Classic"
    "XCURSOR_SIZE,26"
  ];
  bind = [
    # Application keybinds
    "$mod, ${hypr "browserKey" "B"}, exec, ${hypr "browser" "zen"}"
    "$mod, ${hypr "commKey" "M"}, exec, ${hypr "comms" "fractal"}"
    "$mod, ${hypr "termKey" "Q"}, exec, ${hypr "term" "kitty"}"
    "$mod, ${hypr "fileKey" "E"}, exec, ${hypr "file" "nemo"}"
    # "$mod, ${hypr "mailKey" "U"}, exec, ${hypr "mail" "betterbird"}"
    "$mod, ${hypr "mailKey" "U"}, exec, ${hypr "mail" "thunderbird"}"
    "$mod, ${hypr "docKey" "Z"}, exec, ${hypr "doc" "zettlr"}"
    "$mod, ${hypr "todoKey" "T"}, exec, ${hypr "todo" "sleek-todo"}"
    "$mod, ${hypr "gitKey" "G"}, exec, ${hypr "git" "gitbutler-tauri"}"

    # Window actions
    "$mod, ${hypr "kill" "C"}, killactive"
    "$mod, ${hypr "exit" "X"}, exit"
    "$mod, ${hypr "float" "V"}, togglefloating"
    "$mod, ${hypr "full" "F"}, fullscreen, 0"
    "$mod+Alt, ${hypr "full" "F"}, fullscreen, 1"
    "$mod, ${hypr "last" "R"}, focusurgentorlast"
    # recommended opacity toggle; see https://github.com/hyprwm/Hyprland/pull/7024
    "$mod, ${hypr "opaque" "O"}, exec, hyprctl setprop active opaque toggle"

    # Hyprscroller
    "$mod, ${hypr "view" "A"}, scroller:toggleoverview"
    "$mod+Shift, K, scroller:cyclesize, +1"
    "$mod+Shift, J, scroller:cyclesize, -1"

    # Hyprshot
    "$mod+Shift, ${hypr "window" "W"}, exec, hyprshot -m window --clipboard-only"
    "$mod+Alt, ${hypr "window" "W"}, exec, hyprshot -m window"
    "$mod+Shift, ${hypr "monitor" "M"}, exec, hyprshot -m output --clipboard-only"
    "$mod+Alt, ${hypr "monitor" "M"}, exec, hyprshot -m output"
    "$mod+Shift, ${hypr "region" "R"}, exec, hyprshot -m region --clipboard-only"
    "$mod+Alt, ${hypr "region" "R"}, exec, hyprshot -m region"

    # Utilities
    "Ctrl+Alt, H, exec, kitty --class clipse -e 'clipse'"
    "Ctrl+Alt, C, exec, hyprpicker | wl-copy"

    # Resizing
    "$mod+Alt, 1, exec, hyprctl dispatch resizeactive exact 50% 89% && hyprctl dispatch scroller:admitwindow && hyprctl dispatch scroller:expelwindow"
    "$mod+Alt, 2, resizeactive, exact 50% 47%"
    "$mod+Alt, 3, resizeactive, exact 50% 31%"
    "$mod+Alt, 4, resizeactive, exact 50% 23%"
    "$mod+Alt, 5, resizeactive, exact 50% 63%"
    "$mod+Alt, 7, resizeactive, exact 50% 71%"

    # Move around
    "$mod, H, scroller:movefocus, l"
    "$mod, L, scroller:movefocus, r"
    "$mod, K, scroller:movefocus, u"
    "$mod, J, scroller:movefocus, d"

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
    "$mod+Shift, H, scroller:movewindow, l"
    "$mod+Shift, H, scroller:alignwindow, l"
    "$mod+Shift, L, scroller:movewindow, r"
    "$mod+Shift, L, scroller:alignwindow, r"
    "$mod, comma, scroller:admitwindow"
    "$mod, period, scroller:expelwindow"

    # Workspace shortcuts
    "$mod+Ctrl+Shift, J, movetoworkspace, r+1"
    "$mod+Ctrl+Shift, K, movetoworkspace, r-1"
    "$mod+Ctrl, J, workspace, r+1"
    "$mod+Ctrl, K, workspace, r-1"
    "$mod, ${hypr "min" "S"}, togglespecialworkspace"
    "$mod+Shift, ${hypr "min" "S"}, movetoworkspacesilent, special"

    # Run rofi (open new window)
    "$mod, ${hypr "omni" "Space"}, exec, pkill -x rofi || rofi -show drun -show-icons -theme paper-float"
    # Run rofi (run application on path)
    "$mod+Shift, ${hypr "omniRun" "Space"}, exec, pkill -x rofi || rofi -show run -show-icons -theme paper-float"
    # Run rofi (open existing window)
    "$mod, ${hypr "omniWindow" "W"}, exec, pkill -x rofi || rofi -show window -show-icons -theme paper-float"
    # Run rofi (ssh)
    "$mod+Alt, ${hypr "omniSSH" "8"}, exec, pkill -x rofi || rofi -show ssh -show-icons -theme paper-float"
    # Run rofi (browse files)
    "$mod+Shift, ${hypr "omniFile" "F"}, exec, pkill -x rofi || rofi -show filebrowser -show-icons -theme paper-float"
    # Run rofi (list keybinds)
    "$mod+Shift, ${hypr "omniKeys" "/"}, exec, pkill -x rofi || rofi -show keys -show-icons -theme paper-float"

    # Utilities
    ''$mod, ${hypr "screen" "P"}, exec, grim -g "$(slurp)" - | swappy -f -'' # Screenshot
    "$mod, ${hypr "menu" "Backspace"}, exec, wlogout" # Show power menu
  ];

  # Special keybinds
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
    "$mod, Y, movewindow"
    "$mod, X, resizewindow"
  ];

  # Window rules
  layerrule = [ ];
  windowrulev2 = [
    "float,class:(clipse)"
    "size 622 652,class:(clipse)"
  ];

  # Display outputs
  monitor = hyprland.monitors;

  # Window animations
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

  # Hyprland config
  general =
    let
      inherit (config.lib.stylix) colors;
    in
    {
      gaps_in = "5";
      gaps_out = "20";
      border_size = "4";

      # the dot is a hyprland name, not nix syntax, so we escape it
      "col.active_border" = lib.mkForce "rgba(${colors.base0A}ff) rgba(${colors.base09}ff) 45deg";
      "col.inactive_border" = lib.mkForce "rgba(${colors.base01}cc) rgba(${colors.base02}cc) 45deg";

      layout = "scroller";
      resize_on_border = "true";
      allow_tearing = "false";
    };

  # Input devices
  input.touchpad = {
    natural_scroll = true;
    disable_while_typing = true;
    tap-to-click = true;
  };

  # More eyecandy
  decoration = {
    rounding = "14";
    active_opacity = "0.9";
    inactive_opacity = "0.8";
    fullscreen_opacity = "0.95";
    shadow = {
      enabled = false;
    };
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

  # Cursor configuration
  cursor = {
    no_hardware_cursors = if quasar.graphics.nvidia.enabled then 1 else 2;
  };

  # Meta keybinds
  binds = {
    movefocus_cycles_fullscreen = "false";
  };

  # Hidden config options
  misc = {
    force_default_wallpaper = 0;
  };
}
