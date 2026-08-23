{ inputs, ... }:
{
  flake.modules.nixos.impermanence = {
    imports = with inputs; [
      impermanence.nixosModules.impermanence
    ];
  };
}
