# Module from the awesome Reality.md <3
# Source: <https://git.uninetwork.net/reality-exe/nixos-config/src/commit/18fbcb74c220aec75507d2257b1412e31453953d/modules/nixos/software/vr/wivrn.nix>
{
  config,
  lib,
  pkgs,
  nixpkgs-xr,
  ...
}:
{
  options = {
    wivrn = {
      enable = lib.mkEnableOption "enable wivrn";
      useCuda = lib.mkEnableOption "enable cuda support for wivrn";
    };
  };

  config = lib.mkIf config.wivrn.enable {
    # nixpkgs.overlays = [ nixpkgs-xr.overlays.default ];
    environment.systemPackages = with pkgs; [
      motoc

      # inputs.edrakon.packages.${pkgs.stdenv.hostPlatform.system}.default
      # inputs.space-cal.packages.${pkgs.stdenv.hostPlatform.system}.default

      # (writeShellScriptBin "wivrn-startup" ''
      #   (echo Edrakon; echo wayvr) | ${lib.getExe parallel}
      # '')

      # resolute
      # bs-manager
      # android-tools
      xrizer

      # inputs.lemonake.packages.x86_64-linux.wayvr
      vrcx
      # xrbinder

      # (callPackage ../../../../packages/ogb.nix { })
      # (callPackage ../../../../packages/vrcft.nix { })
    ];
    services.wivrn = {
      enable = true;
      openFirewall = true;
      package = (pkgs.wivrn.override { cudaSupport = config.wivrn.useCuda; }).overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs.SDL2
          pkgs.systemd
        ];
        cmakeFlags = old.cmakeFlags ++ [
          (lib.cmakeBool "WIVRN_FEATURE_STEAMVR_LIGHTHOUSE" true)
        ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/wivrn-server \
            --prefix LD_LIBRARY_PATH : ${pkgs.SDL2}/lib:${pkgs.systemd}/lib
        '';
      });
    };
  };
}
