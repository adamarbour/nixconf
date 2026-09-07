{
  flake.modules.nixos.networkd = { lib, ... }: {

    networking = {
      networkmanager.enable = lib.mkForce false;
      useNetworkd = true;
    };

    systemd = {
      network.enable = true;
      network.wait-online.enable = lib.mkDefault true;
      services = {
        # prevent failures from services that are restarted instead of stopped
        systemd-networkd.stopIfChanged = false;
        systemd-resolved.stopIfChanged = false;
      };
    };
  };
}
