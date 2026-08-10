 { inputs, ... }:
 {
  flake.modules.nixos.base = { pkgs, lib, config, ... }: {

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowVariants = true;
      allowBroken = false;
      permittedInsecurePackages = [];
      allowUnsupportedSystem = false;
      allowAliases = false;
    };

    nixpkgs.overlays = [
      (final: _prev: {
        stable = import inputs.nixpkgs-stable {
          inherit (final) config;
          system = pkgs.stdenv.hostPlatform.system;
        };
        unstable = import inputs.nixpkgs-unstable {
          inherit (final) config;
          system = pkgs.stdenv.hostPlatform.system;
        };
      })
    ];

  };
}
