{ self, ... }:
let
  inherit (self.lib) mkNixos;
in
{
  flake.modules.nixos.atlas = {
    imports = with self.modules.nixos; [
      # profiles / roles
      server
      # disk
      disko
      self.diskoConfigurations.atlas
    ];
  };

  flake.nixosConfigurations = mkNixos "x86_64-linux" "atlas";
}
