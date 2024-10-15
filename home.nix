quasar: hyprPlugins:
{
  config,
  pkgs,
  inputs,
  ...
}:

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

  # Do not edit this configuration file to define what should be installed
  # on your system.
  # Help is available in the Home Manager manual
  # (see https://nix-community.github.io/home-manager/).
  # This is the default user configuration that ships with QuasarOS.
  # Most of it can be modified from the Quasar configuration.
  # You can also override it by including other custom configuration files,
  # which is how you should install packages.

  home.username = quasar.user;
  home.homeDirectory = "/home/${quasar.user}";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages =
    with pkgs;
    [
      # essential
      brave
      firefox
      thunderbird
      zettlr
      fastfetch
      nemo

      # archives
      zip
      unzip

      # utils
      fzf
      bat

      # system monitoring
      nix-output-monitor
      btop

      # wayland desktop utils
      wl-clipboard
      rofi-wayland

      # messaging apps
      signal-desktop

      # ricing
      swww
      waypaper
      bibata-cursors
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      papirus-icon-theme
      libsForQt5.qt5ct

      # editing
      delta
      lazygit
      micro
      zed-editor
    ]
    ++ (quasar.homePackages pkgs);

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ hyprPlugins.hyprscroller ];
    settings = import ./modules/hyprland.nix quasar;
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "32x32";
    };
  };
  services.easyeffects = {
    enable = true;
  };

  programs.gh.enable = true;
  programs.fzf.enable = true;
  programs.wlogout.enable = true;
  programs.lazygit.enable = true;
  programs.nushell.enable = true;
  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
    useTheme = "bubblesline";
  };

  programs.git = {
    enable = true;
    userName = if builtins.hasAttr "name" quasar.git then quasar.git.name else quasar.name;
    userEmail = quasar.git.email;
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    font.name = "CaskaydiaCove Nerd Font";
    settings = {
      font_size = 11;
      window_padding_width = "8 8 0";
      confirm_os_window_close = -1;
      shell = "nu";
      shell_integration = "enabled";
      enable_audio_bell = true;
      background_opacity = "1.0";
    };
  };

  programs.waybar = {
    enable = true;
    style = "min";
    package = pkgs.waybar;
    settings = {
      mainbar = {
        "layer" = "top";
        "modules-left" = [
          "sway/workspaces"
          "sway/mode"
          "sway/window"
        ];
        "modules-center" = [
          "sway/layout"
          "sway/clock"
        ];
        "modules-right" = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "memory"
          "cpu"
          "temperature"
          "backlight"
          "battery"
          "tray"
        ];
        "sway/workspaces" = {
          "all-outputs" = true;
          "format" = "{name}:{icon}";
          "format-icons" = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
          "format-foreground" = {
            "1" = "#002c71";
            "2" = "#002c71";
            "3" = "#002c71";
            "4" = "#002c71";
            "5" = "#002c71";
            "urgent" = "#2f343a";
            "focused" = "#2f343a";
            "default" = "#2f343a";
          };
          "format-background" = {
            "1" = "#002c71";
            "2" = "#002c71";
            "3" = "#002c71";
            "4" = "#002c  71";
            "5" = "#002c71";
            "urgent" = "#2f343a";
            "focused" = "#2f343a";
            "default" = "#2f343a";
          };
        };
      };
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      size = 26;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteNordDark
    '';

    "Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };

  programs.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  home.stateVersion = quasar.stateVersion;
  programs.home-manager.enable = true;
}
