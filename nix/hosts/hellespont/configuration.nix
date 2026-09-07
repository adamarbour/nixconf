{ self, ... }:
let
  inherit (self.lib) mkNixos;
in
{
  flake.modules.nixos.atlas = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      # profiles / roles
      server
      # hardware
      # disk
      disko
      self.diskoConfigurations.atlas
      # features
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
  };

  flake.nixosConfigurations = mkNixos "x86_64-linux" "atlas";
}
