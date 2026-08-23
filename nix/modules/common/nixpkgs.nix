{ inputs, ... }:
{
  flake.modules.nixos.common = { pkgs, ... }: {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        allowVariants = true;
        allowBroken = false;
        permittedInsecurePackages = [ ];
        allowUnsupportedSystem = false;
        allowAliases = false;
      };

      overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
        inputs.nix-topology.overlays.default
        inputs.llm-agents.overlays.shared-nixpkgs

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
  };
}
