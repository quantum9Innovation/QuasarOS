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

  # This is the default QuasarOS system configuration flake.
  # It is the entry point for all QuasarOS-based systems.
  # You should include a specific version of this flake as an input
  # in your system configuration flake and then use the provided `make`
  # function to build your system using your own Quasar configuration.
  description = "QuasarOS system configuration flake";

  inputs = {
    # QuasarOS uses the nixpkgs unstable channel,
    # so new package updates are always immediately available.
    # Many user packages are also built directly
    # from the latest stable git source,
    # usually the last commit on the `main` branch.
    # This is the recommended way to install user packages
    # which are not critical for system functionality on QuasarOS.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # For incorporating hotfixes
    nixpkgs-upstream.url = "github:nixos/nixpkgs/nixos-unstable-small";

    # Home Manager manages user dotfiles in the Nix configuration language,
    # enhancing interoperability and consolidation of system configurations.
    # You should use Home Manager integrations
    # to configure all installed applications
    # in order to ensure complete reproducibility.
    # Home Manager is a critical system package
    # and is pinned to a specific release.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen browser, twilight edition
    zen-browser = {
      url = "https://github.com/zen-browser/desktop/releases/download/twilight/zen.linux-x86_64.tar.bz2";
      flake = false;
    };
    zen-browser-flake = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zen-browser-x86_64.follows = "zen-browser";
    };

    # Recommended Hyprland utilities
    hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";

    # Lanzaboote is needed for NixOS to work when secure boot is enabled.
    # Incorrect Lanzaboote configurations could lead to an unbootable OS.
    # Lanzaboote is a critical system package
    # and is pinned to a release.
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-upstream,
      home-manager,
      zen-browser-flake,
      hyprland-qtutils,
      lanzaboote,
      ...
    }@inputs:
    {
      make =
        {
          hostname,
          user,
          name,
          git,
          hardware,
          system ? "x86_64-linux",
          kernel ? "zen",
          secureboot ? {
            enabled = true;
          },
          stateVersion ? "24.05",
          systemPackages,
          homePackages,
          autoLogin ? true,
          ssh ? {
            enabled = false;
          },
          locale ? "en_US.UTF-8",
          hyprland ? {
            mod = "SUPER";
          },
          graphics ? {
            opengl = true;
            nvidia = {
              enabled = true;
              intelBusId = null;
              nvidiaBusId = null;
            };
          },
          audio ? {
            jack = false;
          },
          overrides ? [ ],
          homeOverrides ? [ ],
          ...
        }@quasar:
        let
          # Secure boot configuration
          secureBoot = [
            lanzaboote.nixosModules.lanzaboote

            (
              { pkgs, lib, ... }:
              {
                environment.systemPackages = [
                  # For debugging and troubleshooting secure boot
                  pkgs.sbctl
                ];

                # Lanzaboote currently replaces the systemd-boot module.
                # This setting is usually set to true in configuration.nix,
                # generated at installation time.
                # So we force it to false for now.
                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/etc/secureboot";
                };
              }
            )
          ];

          # Modules without conditional add-ons
          baseModules = [
            # Primary system configuration module
            ./configuration.nix

            # Home Manager setup
            home-manager.nixosModules.home-manager
            {
              # Install from preconfigured nixpkgs channel
              home-manager.useGlobalPkgs = true;

              # Enable user packages for `nixos-rebuild build-vm`
              home-manager.useUserPackages = true;

              # Home Manager backup files will end in .backup
              home-manager.backupFileExtension = "backup";

              home-manager.users.${user} = {
                # Primary user Home Manager configuration module
                imports =
                  let
                    nixpkgs-upstream-unlocked = import nixpkgs-upstream {
                      system = system;
                      config.allowUnfree = true;
                    };

                    pack = [
                      zen-browser-flake.packages.${system}.default
                      hyprland-qtutils.packages.${system}.default
                      nixpkgs-upstream-unlocked.gitbutler
                    ];
                  in
                  [
                    (import ./home.nix quasar nixpkgs.legacyPackages.${system}.hyprlandPlugins pack)
                  ]
                  ++ homeOverrides;
              };
            }
          ];

          # Modules with conditional add-ons
          modules = if secureboot.enabled then baseModules ++ secureBoot else baseModules;
        in
        {
          system = nixpkgs.lib.nixosSystem {
            # Forward external configurations to declared modules
            specialArgs = {
              inherit inputs;
              inherit quasar;
            };

            # Official support is currently for x86_64-linux only
            system = system;

            # This does the heavy lifting of configuring the system
            modules = modules;
          };
        };

      # Configure formatter for all supported systems
      formatter =
        let
          systems = [
            "x86_64-linux"
          ];
          forAll = value: nixpkgs.lib.genAttrs systems (key: value);
        in
        forAll nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
