quasar:
let
  hyprland = quasar.hyprland;
  default = mod: attr: fallback:
    if builtins.hasAttr attr mod then mod.${attr} else fallback;
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
  "$mod" = default hyprland "mod" "SUPER";
  "$Left" = "Left";
  "$Right" = "Right";
  "$Up" = "Up";
  "$Down" = "Down";
  env = [
    "HYPRCURSOR_THEME,Bibata-Modern-Ice"
    "HYPRCURSOR_SIZE,26"
    "XCURSOR_THEME,Bibata-Modern-Ice"
    "XCURSOR_SIZE,26"
  ];
  bind = [
    # Application Keybinds
    "$mod, F, exec, librewolf"
    "$mod, T, exec, kitty"
    "$mod, E, exec, dolphin"
    "$mod, R, exec, pavucontrol"

    # Window actions
    "$mod, Q, killactive"
    "$mod, W, togglefloating"
    "$mod, J, togglesplit"
    "$mod, Return, fullscreen"

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

    "$mod, S, togglespecialworkspace"

    # Move windows around
    "$mod+Shift+Ctrl, $Left, movewindow, l"
    "$mod+Shift+Ctrl, $Right, movewindow, r"
    "$mod+Shift+Ctrl, $Up, movewindow, u"
    "$mod+Shift+Ctrl, $Down, movewindow, d"

    "$mod+Ctrl+Alt, $Right, movetoworkspace, r+1"
    "$mod+Ctrl+Alt, $Left, movetoworkspace, r-1"

    "$mod+Ctrl, $Right, workspace, r+1"
    "$mod+Ctrl, $Left, workspace, r-1"

    "$mod+Alt, S, movetoworkspacesilent, special"

    # Utilities
    "$mod, Space, exec, pkill -x rofi || rofi -show drun" # Run rofi

    ''$mod, P, exec, grim -g "$(slurp)" - | swappy -f -'' # Screenshot

    "$mod, Backspace, exec, wlogout" # Screenshot
  ];
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
    "$mod, Z, movewindow"
    "$mod, X, resizewindow"
  ];
  windowrulev2 = [
    "opacity 0.90 0.90,class:^(firefox)$"
    "opacity 0.90 0.90,class:^(librewolf)$"
    "opacity 0.90 0.90,class:^(Brave-browser)$"
    "opacity 0.80 0.80,class:^(Steam)$"
    "opacity 0.80 0.80,class:^(steam)$"
    "opacity 0.80 0.80,class:^(steamwebhelper)$"
    "opacity 0.80 0.80,class:^(Spotify)$"
    "opacity 0.80 0.80,initialTitle:^(Spotify Free)$"
    "opacity 0.80 0.80,class:^(code-oss)$"
    "opacity 0.80 0.80,class:^(Code)$"
    "opacity 0.80 0.80,class:^(code-url-handler)$"
    "opacity 0.80 0.80,class:^(code-insiders-url-handler)$"
    "opacity 0.80 0.80,class:^(kitty)$"
    "opacity 0.80 0.80,class:^(org.kde.dolphin)$"
    "opacity 0.80 0.80,class:^(org.kde.ark)$"
    "opacity 0.80 0.80,class:^(nwg-look)$"
    "opacity 0.80 0.80,class:^(qt5ct)$"
    "opacity 0.80 0.80,class:^(qt6ct)$"
    "opacity 0.80 0.80,class:^(kvantummanager)$"

    "opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk"
    "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk"
    "opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$ # Cartridges-Gtk"
    "opacity 0.80 0.80,class:^(com.obsproject.Studio)$ # Obs-Qt"
    "opacity 0.80 0.80,class:^(gnome-boxes)$ # Boxes-Gtk"
    "opacity 0.80 0.80,class:^(discord)$ # Discord-Electron"
    "opacity 0.80 0.80,class:^(vesktop)$ # Vesktop-Electron"
    "opacity 0.80 0.80,class:^(ArmCord)$ # ArmCord-Electron"
    "opacity 0.80 0.80,class:^(app.drey.Warp)$ # Warp-Gtk"
    "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
    "opacity 0.80 0.80,class:^(yad)$ # Protontricks-Gtk"
    "opacity 0.80 0.80,class:^(Signal)$ # Signal-Gtk"
    "opacity 0.80 0.80,class:^(io.github.alainm23.planify)$ # planify-Gtk"
    "opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk"
    "opacity 0.80 0.80,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk"

    "opacity 0.80 0.70,class:^(pavucontrol)$"
    "opacity 0.80 0.70,class:^(blueman-manager)$"
    "opacity 0.80 0.70,class:^(nm-applet)$"
    "opacity 0.80 0.70,class:^(nm-connection-editor)$"
    "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"

    "float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$"
    "float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$"
    "float,title:^(Picture-in-Picture)$"
    "float,class:^(firefox)$,title:^(Library)$"
    "float,class:^(librewolf)$,title:^(Library)$"
    "float,class:^(vlc)$"
    "float,class:^(kvantummanager)$"
    "float,class:^(qt5ct)$"
    "float,class:^(qt6ct)$"
    "float,class:^(nwg-look)$"
    "float,class:^(org.kde.ark)$"
    "float,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk"
    "float,class:^(app.drey.Warp)$ # Warp-Gtk"
    "float,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
    "float,class:^(yad)$ # Protontricks-Gtk"
    "float,class:^(eog)$ # Imageviewer-Gtk"
    "float,class:^(io.github.alainm23.planify)$ # planify-Gtk"
    "float,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk"
    "float,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk"
    "float,class:^(pavucontrol)$"
    "float,class:^(blueman-manager)$"
    "float,class:^(nm-applet)$"
    "float,class:^(nm-connection-editor)$"
    "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
    "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.gtk)$"
    "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.hyprland)$"
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
  monitor = [ "DP-1,2560x1440@165,1920x0,auto" "HDMI-A-1,1920x1080@60,0x0,1" ];
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
    #
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
}
