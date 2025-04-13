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

  # This is a collection of common utilities which are necessary
  # for the modularization of the QuasarOS configuration.
  # At this point it resembles a random smattering of Nix expressions,
  # since quite a lot of hacking has gone into its development.

  # Select attribute or fallback from attrset
  default =
    mod: attr: fallback:
    if builtins.hasAttr attr mod then mod.${attr} else fallback;

  # GPU patching
  patch =
    nvidia: name: app:
    if nvidia then
      app.overrideAttrs (
        _final: _prev: {
          postFixup = ''
            wrapProgram $out/bin/${name} \
              --set __NV_PRIME_RENDER_OFFLOAD 1 \
              --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER "NVIDIA-G0" \
              --set __GLX_VENDOR_LIBRARY_NAME "nvidia" \
              --set __VK_LAYER_NV_optimus "NVIDIA_only"
          '';
        }
      )
    else
      app;

  patchPkg =
    pkgs: nvidia: name: app: license:
    let
      appGPU = pkgs.stdenv.mkDerivation rec {
        inherit name;
        src = app;
        buildInputs = [ pkgs.makeWrapper ];
        installPhase = ''
          mkdir -p $out/bin
          makeWrapper ${src}/bin/${name} $out/bin/${name} \
            --set __NV_PRIME_RENDER_OFFLOAD 1 \
            --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER "NVIDIA-G0" \
            --set __GLX_VENDOR_LIBRARY_NAME "nvidia" \
            --set __VK_LAYER_NV_optimus "NVIDIA_only"
        '';
        meta = with pkgs.lib; {
          description = "NVIDIA GPU offloading for ${name}";
          license = licenses.${license};
        };
      };
    in
    if nvidia then appGPU else app;
}
