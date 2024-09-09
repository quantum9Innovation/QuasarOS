{
  config,
  lib,
  pkgs,
  inputs,
  quasar,
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
  # Help is available in the configuration.nix(5) man page
  # and in the NixOS manual (accessible by running ‘nixos-help’).
  # This is the default system configuration that ships with QuasarOS.
  # Most of it can be modified from the Quasar configuration.
  # You can also override it by including other custom configuration files
  # and a custom package list.

  imports = [
    # Include the results of the hardware scan
    quasar.hardware
  ] ++ quasar.overrides;

  # Incorporate hotfixes
  # nixpkgs.overlays = [
  #   (self: super: {
  #     xdg-desktop-portal-hyprland =
  #       inputs.nixpkgs-upstream.legacyPackages.${pkgs.system}.xdg-desktop-portal-hyprland;
  #   })
  # ];

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 15;
    systemd-boot = {
      enable = true;
      consoleMode = "auto";
    };
  };

  # Define your hostname
  networking.hostName = quasar.hostname;

  # Select kernel
  boot.kernelPackages =
    {
      "zen" = pkgs.linuxPackages_zen;
      "latest" = pkgs.linuxPackages_latest;
      "hardened" = pkgs.linuxPackages_latest_hardened;
      "libre" = pkgs.linuxPackages_latest-libre;
    }
    .${quasar.kernel};

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Set time zone automatically
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties
  i18n.defaultLocale = quasar.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = quasar.locale;
    LC_IDENTIFICATION = quasar.locale;
    LC_MEASUREMENT = quasar.locale;
    LC_MONETARY = quasar.locale;
    LC_NAME = quasar.locale;
    LC_NUMERIC = quasar.locale;
    LC_PAPER = quasar.locale;
    LC_TELEPHONE = quasar.locale;
    LC_TIME = quasar.locale;
  };

  # Faster boot times
  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };

  # Disable the X11 windowing system,
  # since Hyprland uses the more modern Wayland
  services.xserver.enable = false;

  # Enable Wayland support for Electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Compatibility for running binaries not packaged for QuasarOS
  programs.nix-ld = {
    enable = true;
    libraries = [ pkgs.icu ];
  };

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Enable SDDM for login and lock management
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };
    autoLogin.enable = quasar.autoLogin;
    autoLogin.user = if quasar.autoLogin then quasar.user else null;
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # If you want to use JACK applications, set `quasar.audio.jack` to true
    jack.enable = quasar.audio.jack;
  };

  # Define a user account
  # Don't forget to set a password with `passwd`
  programs.fish.enable = true;
  users.users.${quasar.user} = {
    isNormalUser = true;
    description = quasar.name;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # More user configuration
  nix.settings = {
    trusted-users = [
      "root"
      quasar.user
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Allow unfree packages for proprietary driver support
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      micro
      curl
      bat
      gnumake
      clang
      gcc
      cachix
      gnupg
      pavucontrol
    ]
    ++ (quasar.systemPackages pkgs);

  # Git is an essential system package
  programs.git.enable = true;

  # Set default editor, among other things
  environment.variables = {
    EDITOR = "micro";
    NIX_AUTO_RUN = 1;
  };

  # Prevent atrocious directories from polluting user home
  environment.etc = {
    "xdg/user-dirs.defaults".text = ''
      	  XDG_DESKTOP_DIR=desk
      	  XDG_DOWNLOAD_DIR=dl
      	  XDG_TEMPLATES_DIR=tmp
      	  XDG_PUBLICSHARE_DIR=pub
      	  XDG_DOCUMENTS_DIR=doc
      	  XDG_MUSIC_DIR=music
      	  XDG_PICTURES_DIR=img
      	  XDG_VIDEOS_DIR=vid
      	  XDG_WALLPAPERS_DIR=wall
        	'';
  };

  # Setup GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = quasar.ssh.enabled;
  };

  # Enable the OpenSSH daemon
  services.openssh.enable = quasar.ssh.enabled;

  # Setup Dconf for user configuration of low-level settings
  # Also needed as a dependency for critical system packages
  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default settings
  # for stateful data, like file locations and database versions
  # on your system were taken.
  # It‘s perfectly fine and recommended to leave this value at the release
  # version of the first install of this system.
  # Before changing this value, read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = quasar.stateVersion; # Did you read the comment?

  # Enable OpenGL for optimal graphics performance
  hardware.graphics.enable = quasar.graphics.opengl;

  # Install and configure appropriate NVIDIA drivers
  # Do not attempt to disable unfree software packages if you enable this
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia =
    if quasar.graphics.nvidia.enabled then
      {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        open = false;
        nvidiaSettings = true;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = quasar.graphics.nvidia.intelBusId;
          nvidiaBusId = quasar.graphics.nvidia.nvidiaBusId;
        };
      }
    else
      null;

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
      };
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      (google-fonts.override { fonts = [ "Lora" ]; })
    ];
  };
}
