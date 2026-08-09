{
  flake.modules.nixos.graphical = { lib, ... }: {

    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        unmanaged = [
          "interface-name:tailscale*"
          "interface-name:br-*"
          "interface-name:rndis*"
          "interface-name:docker*"
          "interface-name:virbr*"
          "interface-name:incusbr*"
          "interface-name:vboxnet*"
          "interface-name:waydroid*"
          "type:bridge"
        ];
      };
    };

    systemd = {
      # allow the system to boot without the network interfaces online
      network.wait-online.enable = false;
      services = {
        NetworkManager-wait-online.enable = false;
        # prevent failures from services that are restarted instead of stopped
        systemd-networkd.stopIfChanged = false;
        systemd-resolved.stopIfChanged = false;
      };
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];

  };
}
