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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen browser, beta edition
    # After much consideration, the beta edition was deemed to be the best
    # choice for the system browser on QuasarOS.
    # Old twilight release binaries are not hosted by an official source,
    # and these are necessary to ensure short-term rollbacks.
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # GitButler
    gitbutler = {
      url = "github:youwen5/gitbutler-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Betterbird
    # betterbird = {
    #   url = "git+https://code.youwen.dev/youwen5/betterbird-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Stylix is an auto-ricing utility that applies a consistent theme to
    # a variety of apps installed on QuasarOS.
    # This is the primary tool used for specifying rices.
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lanzaboote is needed for NixOS to work when secure boot is enabled.
    # Incorrect Lanzaboote configurations could lead to an unbootable OS.
    # Lanzaboote is a critical system package
    # and is pinned to a specific release.
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Enable pre-commit hooks on this repository
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    # Use latest Hyprland version, but not unstable upstream
    hyprland = {
      url = "github:hyprwm/hyprland/v0.50.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Use latest Hyprscroller plugin
    hyprscroller = {
      url = "github:cpiber/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      gitbutler,
      # betterbird,
      lanzaboote,
      stylix,
      hyprland,
      hyprscroller,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            check-merge-conflicts.enable = true;
            commitizen.enable = true;
            convco.enable = true;
            forbid-new-submodules.enable = true;
            gitlint.enable = true;
            markdownlint.enable = true;
            mdformat.enable = true;
            mdsh.enable = true;
            deadnix.enable = true;
            flake-checker.enable = true;
            nil.enable = true;
            statix.enable = true;
            nixfmt-rfc-style.enable = true;
            ripsecrets.enable = true;
            trufflehog.enable = false;
            shellcheck.enable = false;
            shfmt.enable = true;
            typos.enable = true;
            check-yaml.enable = true;
            yamlfmt.enable = true;
            yamllint.enable = true;
            yamllint.settings.preset = "relaxed";
            actionlint.enable = true;
            check-added-large-files.enable = true;
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            check-shebang-scripts-are-executable.enable = true;
            check-symlinks.enable = true;
            detect-private-keys.enable = true;
            end-of-file-fixer.enable = true;
            mixed-line-endings.enable = true;
            tagref.enable = true;
            trim-trailing-whitespace.enable = true;
            check-toml.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });

      make =
        config:
        let
          # Default values
          defaults = {
            system = "x86_64-linux";
            kernel = "zen";
            secureboot = {
              enabled = true;
            };
            stateVersion = "24.05";
            autoLogin = true;
            ssh = {
              enabled = true;
            };
            locale = "en_US.UTF-8";
            hyprland = {
              mod = "SUPER";
            };
            graphics = {
              opengl = true;
              nvidia = {
                enabled = true;
              };
            };
            audio = {
              jack = false;
            };
            overrides = [ ];
            homeOverrides = [ ];
          };

          # Fill in defaults
          quasar = defaults // config;

          # Secure boot configuration
          secureBoot = [
            lanzaboote.nixosModules.lanzaboote
            (import ./modules/lanzaboote.nix)
          ];

          # Modules without conditional add-ons
          baseModules = [
            # Primary system configuration module
            ./configuration.nix

            # Stylix autoricer
            stylix.nixosModules.stylix

            # Home Manager setup
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                # Install from preconfigured nixpkgs channel
                useGlobalPkgs = true;

                # Enable user packages for `nixos-rebuild build-vm`
                useUserPackages = true;

                # Home Manager backup files will end in .backup
                backupFileExtension = "backup";

                # Primary user Home Manager configuration module
                users.${quasar.user} = {
                  imports =
                    let
                      # Patching
                      utils = import ./utils.nix;

                      # Packages from upstream
                      upstream = { };

                      # Custom packages to inject
                      pack = [
                        zen-browser.packages.${quasar.system}.default
                        # betterbird.packages.${quasar.system}.default
                        (utils.patch quasar.graphics.nvidia.enabled "gitbutler-tauri"
                          gitbutler.packages.${quasar.system}.default
                        )
                      ];
                    in
                    [
                      (import ./home.nix quasar utils upstream hyprland hyprscroller pack)
                    ]
                    ++ quasar.homeOverrides;
                };
              };
            }
          ];

          # Modules with conditional add-ons
          modules = if quasar.secureboot.enabled then baseModules ++ secureBoot else baseModules;
        in
        {
          system = nixpkgs.lib.nixosSystem {
            # Forward external configurations to declared modules
            specialArgs = {
              inherit inputs;
              inherit quasar;
            };

            # Official support is currently for x86_64-linux only
            inherit (quasar) system;

            # This does the heavy lifting of configuring the system
            inherit modules;
          };
        };

      # Configure formatter for all supported systems
      formatter = forAllSystems (_: nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style);
    };
}
