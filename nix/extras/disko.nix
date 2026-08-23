{ inputs, ... }:
{
  flake.modules.nixos.disko = {
    imports = with inputs; [
      disko.nixosModules.disko
    ];
  };
}
