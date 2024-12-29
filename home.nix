quasar: hyprPlugins: pack:
{
  pkgs,
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

  # Link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

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
    let
      zedGPU = pkgs.stdenv.mkDerivation rec {
        name = "zed-gpu";
        src = pkgs.zed-editor;
        buildInputs = [ pkgs.makeWrapper ];
        installPhase = ''
          mkdir -p $out/bin
          makeWrapper ${src}/bin/zeditor $out/bin/zeditor \
            --set __NV_PRIME_RENDER_OFFLOAD 1 \
            --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER "NVIDIA-G0" \
            --set __GLX_VENDOR_LIBRARY_NAME "nvidia" \
            --set __VK_LAYER_NV_optimus "NVIDIA_only"
        '';
        meta = with pkgs.lib; {
          description = "NVIDIA GPU offloading for Zed";
          license = licenses.bsd3;
        };
      };
    in
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
      fzf
      bat
      nodePackages.live-server

      # system monitoring
      nix-output-monitor
      btop

      # wayland desktop utils
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
      gitbutler
      micro
      (if quasar.graphics.nvidia.enabled then zedGPU else zed-editor)
      nixd
      nil
    ]
    ++ (quasar.homePackages pkgs)
    ++ pack;

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ hyprPlugins.hyprscroller ];
    settings = import ./modules/hyprland.nix quasar;
  };

  # Setup GNOME keyring
  services.gnome-keyring.enable = true;

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
  programs.bash.enable = true;

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
    systemd.enable = true;
    package = pkgs.waybar;
    style = builtins.readFile modules/waybar.css;
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
        "temperature" = {
          "critical-threshold" = 120;
          "format" = "{temperatureF}°F ";
          "format-icons" = [
            ""
            ""
            ""
            ""
          ];
          "show-icons" = true;
        };
        "backlight" = {
          "format" = "{percent}% ";
          "format-icons" = [
            ""
            ""
          ];
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
          "temperature"
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

  programs.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  home.stateVersion = quasar.stateVersion;
  programs.home-manager.enable = true;
}
