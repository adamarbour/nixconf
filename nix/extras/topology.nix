{ inputs, ... }:
{
  flake.modules.nixos.topology = {
    imports = with inputs; [
      nix-topology.nixosModules.default
    ];
  };
}
