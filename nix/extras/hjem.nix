{ inputs, ... }:
{
  flake.modules.nixos.hjem = {
    imports = with inputs; [
      hjem.nixosModules.default
    ];
  };
}
