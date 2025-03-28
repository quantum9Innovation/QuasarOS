quasar: utils: upstream: plugins: pack:
{
  pkgs,
  config,
  lib,
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

  # Link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # Encode the file content in the Nix configuration file directly
  # home.file.".foo".text = ''
  #     bar
  # '';

  # Packages that should be installed to the user profile
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
      muffon

      # archives
      zip
      unzip

      # utils
      gh
      fzf
      bat
      nodePackages.live-server

      # system monitoring
      nix-output-monitor
      btop

      # wayland desktop utils
      wlogout
      hyprland-qtutils
      wl-clipboard
      rofi-wayland
      hyprshot
      clipse
      hyprpicker

      # messaging apps
      signal-desktop
      vesktop

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
      (utils.patchPkg pkgs quasar.graphics.nvidia.enabled "zeditor" pkgs.zed-editor "gpl3Only")
      nixd
      nil

      # shell
      bash
    ]
    ++ (quasar.homePackages pkgs)
    ++ pack;

  # Hyprland user config
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ plugins.hyprscroller ];
    settings = import ./modules/hyprland.nix (
      quasar
      // {
        inherit config lib;
      }
    ) utils;
  };

  # Enable GNOME keyring
  services.gnome-keyring.enable = true;

  # Icon theming
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "32x32";
    };
  };

  # Audio effects service
  services.easyeffects = {
    enable = true;
  };

  # Primary shell
  programs.nushell = {
    enable = true;
    configFile = {
      text = ''
        $env.config = {
          show_banner: false
          buffer_editor: 'micro'
        }
      '';
    };
  };

  # Secondary shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  # Auutomatic development environment integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Quick directory navigation
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  # Shell prompt theming
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
    useTheme = "bubblesline";
  };

  # Essential git config
  programs.git = {
    enable = true;
    userName = if builtins.hasAttr "name" quasar.git then quasar.git.name else quasar.name;
    userEmail = quasar.git.email;
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Terminal setup
  programs.kitty = {
    enable = true;
    settings = {
      font_size = 11;
      window_padding_width = "8 8 0";
      confirm_os_window_close = -1;
      shell = "nu";
      shell_integration = "enabled";
      enable_audio_bell = true;
    };
  };

  # Activate Stylix targets
  stylix.targets.waybar.enable = false;
  stylix.targets.hyprlock.enable = false;

  # Custom horizontal status bar on top of screen
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar;

    # inject stylix theming into styles
    style =
      builtins.replaceStrings
        [
          "<CONE>"
          "<CTWO>"
          "<CTHREE>"
          "<CFOUR>"
          "<CFIVE>"
        ]
        (map
          (
            hex:
            let
              r = builtins.substring 0 2 hex;
              g = builtins.substring 2 2 hex;
              b = builtins.substring 4 2 hex;
              R = (builtins.fromTOML "n1 = 0x${r}").n1;
              G = (builtins.fromTOML "m2 = 0x${g}").m2;
              B = (builtins.fromTOML "p3 = 0x${b}").p3;
            in
            "rgba(${toString R}, ${toString G}, ${toString B}, 0.8)"
          )
          (
            with config.lib.stylix.colors;
            [
              base04
              base06
              base08
              base09
              base0A
            ]
          )
        )
        (builtins.readFile modules/waybar.css);

    # general layout
    settings = {
      mainbar = {
        "layer" = "top";
        "modules-left" = [
          "hyprland/workspaces"
        ];
        "modules-center" = [
          "clock"
        ];
        "network" = {
          "format-ethernet" = "{ipaddr}  󰈀";
          "format-wifi" = "{essid}  ";
          "format-connected" = "{essid}  ";
          "format-disconnected" = "Disconnected 󰖪 ";
          "tooltip" = true;
        };
        "clock" = {
          "format" = "{:%I:%M %p}   ";
          "format-alt" = "{:%a, %b %d, %C%y}   ";
          "tooltip" = false;
        };
        "cpu" = {
          "format" = "{usage}% ";
          "tooltip" = true;
        };
        "memory" = {
          "format" = "{percentage}% ";
          "tooltip" = true;
        };
        "backlight" = {
          "format" = "{percent}% ";
          "format-icons" = [
            ""
            ""
          ];
          "tooltip" = false;
        };
        "battery" = {
          "bat" = "BAT0";
          "adapter" = "AC";
          "states" = [
            ""
            ""
            ""
            ""
            ""
          ];
          "format" = "{capacity}% {icon} ";
          "format-charging" = "{capacity}% 󰂄";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon} ";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "modules-right" = [
          "network"
          "pulseaudio"
          "memory"
          "cpu"
          "backlight"
          "battery"
        ];
        "pulseaudio" = {
          "format" = "{volume}%  {icon}";
          "format-bluetooth" = "{volume}%  {icon}  ";
          "format-bluetooth-muted" = "{icon}  ";
          "format-muted" = "Muted 󰝟 ";
          "format-source" = "{volume}%";
          "format-source-muted" = "{volume}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          "scroll-step" = 0.5;
          "on-click" = "pavucontrol";
        };
        "hyprland/workspaces" = {
          "all-outputs" = true;
          "format" = "{name}";
        };
      };
    };
  };

  # GTK theming
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
    };
  };

  # Qt theming
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  # Activate XDG Kvantum theme
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteNordDark
    '';

    "Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };

  # Add desktop entries for missing programs
  xdg.desktopEntries = {
    zeditor = {
      name = "Zed";
      genericName = "Text Editor";
      exec = "zeditor %F";
      terminal = false;
      categories = [
        "Utility"
        "Development"
        "TextEditor"
      ];
    };
  };

  # Set default handlers
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/about" = [ "zen.desktop" ];
      "x-scheme-handler/unknown" = [ "zen.desktop" ];
    };
  };

  # Tell Chrome to play nice with Wayland
  programs.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  # Wallpaper management
  services.hyprpaper.enable = true;

  # Aesthetic lockscreen blur
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 1;
      };
      background = {
        monitor = "eDP-1";
        path = "/tmp/__hyprlock-monitor-screenshot.png";
        blur_passes = 3;
        blur_size = 7;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
      input-field = {
        monitor = "eDP-1";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = false;
        dots_rounding = -1;
        outer_color = "rgb(151515)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = true;
        fade_timeout = 1000;
        placeholder_text = "<i>Input Password...</i>";
        hide_input = false;
        rounding = -1;
        check_color = "rgb(204, 136, 34)";
        fail_color = "rgb(204, 34, 34)";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        fail_timeout = 2000;
        fail_transition = 300;
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1;
        invert_numlock = false;
        swap_font_color = false;

        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
  };

  # Power management
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # avoid starting multiple hyprlock instances.
        lock_cmd = "pidof hyprlock || ${pkgs.grim}/bin/grim -o ${config.programs.hyprlock.settings.background.monitor} /tmp/__hyprlock-monitor-screenshot.png && ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display
      };
      listener = [
        {
          timeout = 1500;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # Essential home-manager config
  home.stateVersion = quasar.stateVersion;
  programs.home-manager.enable = true;
}
