{ inputs, self, ... }:
{
  flake.modules.nixos.base = { pkgs, lib, config, ... }: {
    imports = [
      # inputs
      inputs.hjem.nixosModules.default
      # self
      self.modules.nixos.user-adam
    ];

    # packages
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
