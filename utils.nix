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

  # GPU patching
  patch =
    nvidia: name: app:
    if nvidia then
      app.overrideAttrs (
        final: prev: {
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
}
