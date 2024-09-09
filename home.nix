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
    theme = "Tokyo Night";
    font.name = "CaskaydiaCove Nerd Font";
    settings = {
      font_size = 11;
      window_padding_width = "8 8 0";
      confirm_os_window_close = -1;
      shell_integration = "enabled";
      enable_audio_bell = "no";
      background_opacity = "0.8";
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
