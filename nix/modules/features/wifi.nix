{
  flake.modules.nixos.has-wifi = { lib, config, ... }: {
    networking = {
      wireless.iwd = {
        enable = true;

        settings = lib.mkMerge [
          {
            General.AddressRandomization = "network";
            Settings.AutoConnect = true;
          }

          (lib.mkIf (!config.networking.networkmanager.enable) {
            General.EnableNetworkConfiguration = true;

            Network = {
              EnableIPv6 = true;
              NameResolvingService = "systemd";
            };
          })
        ];
      };

      networkmanager.wifi.backend = lib.mkIf config.networking.networkmanager.enable "iwd";
    };
  };
}
