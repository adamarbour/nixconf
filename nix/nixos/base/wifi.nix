{
  flake.modules.nixos.wifi = {

    hardware.wirelessRegulatoryDatabase = true;

    networking.wireless = {
      userControlled.enable = true;
      allowAuxiliaryImperativeNetworks = true;
      extraConfig = ''
        update_config=1
      '';

      iwd = {
        enable = true;
        settings = {
          Settings.AutoConnect = false;
          General = {
            AddressRandomization = "network";
            EnableNetworkConfiguration = true;
            RoamRetryInterval = 15;
          };
        };
      };
    };

    networking.networkmanager.wifi = {
      backend = "iwd";
      scanRandMacAddress = true;
    };

  };
}
