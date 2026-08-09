{
  flake.modules.nixos.wifi = {

    hardware.wirelessRegulatoryDatabase = true;

    networking.wireless = {
      userControlled.enable = true;
      allowAuxiliaryImperativeNetworks = true;
      extraConfig = ''
        update_config=1
      '';

      iwd.settings = {
      Settings.AutoConnect = true;

      General = {
        EnableNetworkConfiguration = true;
        RoamRetryInterval = 15;
      };
    };

    networking.networkmanager.wifi = {
      backend = "iwd";
      scanRandMacAddress = true;
    };

  };
}
