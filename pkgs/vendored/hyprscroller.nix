{
  lib,
  hyprland,
  pkg-config,
  cmake,
  src,
  version,
}:
let
  mkHyprlandPlugin =
    hyprland:
    args@{ pluginName, ... }:
    hyprland.stdenv.mkDerivation (
      args
      // {
        pname = "${pluginName}";
        nativeBuildInputs = [ pkg-config ] ++ args.nativeBuildInputs or [ ];
        buildInputs = [ hyprland ] ++ hyprland.buildInputs ++ (args.buildInputs or [ ]);
        meta = args.meta // {
          description = args.meta.description or "";
          longDescription =
            (args.meta.longDescription or "")
            + "\n\nPlugins can be installed via a plugin entry in the Hyprland NixOS or Home Manager options.";
        };
      }
    );
in
mkHyprlandPlugin hyprland {
  inherit src version;
  pluginName = "hyprscroller";

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprscroller.so $out/lib/libhyprscroller.so

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/cpiber/hyprscroller";
    description = "Hyprland layout plugin providing a scrolling layout like PaperWM";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youwen5 ];
    platforms = lib.platforms.linux;
  };
}
