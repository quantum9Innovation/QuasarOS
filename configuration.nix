{
  config,
  pkgs,
  lib,
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
  ]
  ++ quasar.overrides;

  # Bootup
  boot = {
    # Bootloader
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 15;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };

    # Select kernel
    kernelPackages =
      {
        "zen" = pkgs.linuxPackages_zen;
        "latest" = pkgs.linuxPackages_latest;
        "hardened" = pkgs.linuxPackages_latest_hardened;
        "libre" = pkgs.linuxPackages_latest-libre;
      }
      .${quasar.kernel};

    # Intel S2Idle[deep] sleeping, stolen from KaitoTLex in #26
    consoleLogLevel = 3;
    initrd.systemd.enable = true;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "mem_sleep_default=deep"
    ];
  };

  # Define your hostname
  networking.hostName = quasar.hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # All hardware settings
  hardware = {
    # Enable bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # Logitech peripheral support
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;

    # Use NVIDIA GPU in virtualized environments
    nvidia-container-toolkit.enable = quasar.graphics.nvidia.enabled;

    # Enable OpenGL for optimal graphics performance
    graphics.enable = quasar.graphics.opengl;

    # NVIDIA settings
    nvidia =
      if quasar.graphics.nvidia.enabled then
        {
          package = config.boot.kernelPackages.nvidiaPackages.beta;
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
            inherit (quasar.graphics.nvidia) intelBusId;
            inherit (quasar.graphics.nvidia) nvidiaBusId;
          };
        }
      else
        null;
  };

  # All services
  services = {
    # Enable bluetooth client
    blueman.enable = true;

    # Set time zone automatically and sync with network time
    timesyncd.enable = true;

    # Disable the X11 windowing system,
    # since Hyprland uses the more modern Wayland
    xserver.enable = false;

    # Enable dbus for talking to GNOME keyring
    dbus.enable = true;

    # CPU power consumption
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "performance";
      };
    };

    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "esc";
              esc = "capslock";
            };
          };
        };
      };
    };

    # Enable SDDM for login and lock management
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
      autoLogin.enable = quasar.autoLogin;
      autoLogin.user = if quasar.autoLogin then quasar.user else null;
    };

    # Always ignore lid switch because logind cannot detect if docked
    # Instead, we use a custom utility for power management (see `modules/hyprland.nix`)
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    # Enable CUPS to print documents
    printing.enable = false;

    # Enable sound with pipewire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # If you want to use JACK applications, set this to true
      jack.enable = quasar.audio.jack;
    };

    # Setup GNOME keyring
    gnome.gnome-keyring.enable = true;

    # Enable `at` for job scheduling
    atd.enable = true;

    # Enable the OpenSSH daemon
    openssh.enable = quasar.ssh.enabled;

    # Ollama
    ollama.enable = true;
    ollama.acceleration = if quasar.graphics.nvidia.enabled then "cuda" else null;

    # Install and configure appropriate NVIDIA drivers
    # Do not attempt to disable unfree software packages if you enable this
    xserver.videoDrivers = [ "nvidia" ];
  };

  # Time zone will be set automatically
  time.timeZone = lib.mkForce null;

  # Select internationalization properties
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

  systemd = {
    # Custom system services
    services = {
      # Ensure network uplink on boot
      NetworkManager-wait-online.enable = true;

      # Automatic time zone switching
      updateTimezone = {
        description = "Automatically update timezone using `timedatectl` and `tzupdate`";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        script = ''
          timedatectl set-timezone $("${pkgs.tzupdate}/bin/tzupdate" -p)
        '';
      };

      # Automatically update QuasarOS
      refresh = {
        description = "Automatically update QuasarOS";
        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        script = ''
          cd ${quasar.flake}
          ${pkgs.git}/bin/git config --global --add safe.directory ${quasar.flake}
          ${pkgs.git}/bin/git pull
        '';
        serviceConfig = {
          Environment = "HOME=/root";
        };
        # Triggered by timer service (separately configured)
        wantedBy = [ ];
      };
    };

    timers = {
      refreshTimer = {
        description = "Timer for system updates";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Unit = "refresh.service";
          Persistent = true; # run on wake up if missed
        };
      };
    };

    # Extra deep sleep config, also stolen from KaitoTLex in #26
    sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };

  # All environment settings
  environment = {
    # Enable Wayland support for Electron apps
    sessionVariables.NIXOS_OZONE_WL = "1";

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages =
      with pkgs;
      [
        micro
        curl
        bat
        git
        gnumake
        clang
        gcc
        cachix
        gnupg
        pavucontrol
        inxi
        brightnessctl
        treefmt
        at
        tzupdate
        dconf
      ]
      ++ (quasar.systemPackages pkgs);

    # Set default editor, among other things
    variables = {
      EDITOR = "micro";
      NIX_AUTO_RUN = 1;
    };

    # Prevent atrocious directories from polluting user home
    etc = {
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
  };

  # All program config
  programs = {
    # Compatibility for running binaries not packaged for QuasarOS
    nix-ld = {
      enable = true;
      libraries = [
        pkgs.icu
        pkgs.glibc
      ];
    };

    # Yet another Nix CLI helper
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 12";
      inherit (quasar) flake;
    };

    # Setup GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = quasar.ssh.enabled;
    };

    # Explicitly enable fish (necessary for use as login shell)
    fish.enable = true;

    # Explicitly enable Hyprland,
    # necessary for detection by system services, for auto login, e.g.
    hyprland.enable = true;

    # Enable for communicating with GNOME keyring
    nm-applet.enable = true;
  };

  # All security rules
  security = {
    # Enable rtkit scheduler
    rtkit.enable = true;

    # Auto unlock login keyring
    pam.services.sddm.enableGnomeKeyring = true;
    pam.services.sddm-autologin.enableGnomeKeyring = true;

    # Polkit rules
    # Allow automatic timezone updates
    polkit.enable = true;
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.timedate1.set-timezone") {
              return polkit.Result.YES;
          }
      });
    '';
  };

  # Define a user account and login shell
  # Don't forget to set a password with `passwd`
  users.users.${quasar.user} = {
    isNormalUser = true;
    description = quasar.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
  };

  # More user configuration
  nix.optimise.automatic = true;
  nix.settings = {
    trusted-users = [
      "root"
      quasar.user
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  nixpkgs.config = {
    # Enable CUDA
    cudaSupport = true;

    # Allow proprietary NVIDIA and CUDA drivers, if necessary
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) (
        if quasar.graphics.nvidia.enabled then
          [
            "nvidia-x11"
            "cuda_cudart"
            "libcublas"
            "cuda_cccl"
            "cuda_nvcc"
            "nvidia-settings"
            "libnpp"
            "libcufft"
            "cuda-merged"
            "cuda_cuobjdump"
            "cuda_gdb"
            "cuda_nvdisasm"
            "cuda_nvprune"
            "cuda_cupti"
            "cuda_cuxxfilt"
            "cuda_nvml_dev"
            "cuda_nvrtc"
            "cuda_nvtx"
            "cuda_profiler_api"
            "cuda_sanitizer_api"
            "libcurand"
            "libcusolver"
            "libnvjitlink"
            "libcusparse"
            "cudnn"
          ]
        else
          [ ]
      );
  };

  # Enable Docker for hardware virtualization
  virtualisation.docker.enable = true;

  # Core system settings
  system = {
    # This value determines the NixOS release from which the default settings
    # for stateful data, like file locations and database versions
    # on your system were taken.
    # It‘s perfectly fine and recommended to leave this value at the release
    # version of the first install of this system.
    # Before changing this value, read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    inherit (quasar) stateVersion; # Did you read the comment?

    # Automatically rebuild system daily
    autoUpgrade = {
      enable = true;
      inherit (quasar) flake;
      flags = [
        "-L" # print build logs
      ];
      dates = "daily";
    };
  };

  # Stylix autoricer
  stylix = {
    enable = true;

    # Set a wallpaper (mandatory)
    # Run `systemctl restart --user -u hyprpaper.service` to refresh wallpaper
    # After editing and rebuilding
    image = ./walls/default.jpg;

    # Forces light or dark mode.
    # polarity :: "light" || "dark"
    polarity = "light";

    # Set a base16 scheme to override the wallpaper generated color scheme. You
    # can use any theme in tinted-theming.
    # <https://github.com/tinted-theming/schemes/tree/spec-0.11/base16>
    # An example is below:
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    # Font config, preferred over NixOS built-in font configuration
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.caskaydia-cove;
        name = "CaskaydiaCove Nerd Font";
      };
    };

    # Set cursor; takes effect for Hyprland, GTK, etc.
    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 26;
    };
  };

  # Additional system fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };
}
