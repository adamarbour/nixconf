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

    # network
    systemd.network.networks."10-wan" = {
      matchConfig.MACAddress = "00:16:3c:ed:3b:50";
      networkConfig = {
        Address = "172.245.210.47/24";
        Gateway = "172.245.210.1";
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  flake.nixosConfigurations = mkNixos "x86_64-linux" "atlas";
}
