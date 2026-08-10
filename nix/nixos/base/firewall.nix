{
  flake.modules.nixos.base = { lib, ... }: {

    networking = {
      nftables.enable = true;

      firewall = {
        enable = true;

        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];

        allowedTCPPortRanges = [ ];
        allowedUDPPortRanges = [ ];

        # assume we cannot be pinged by default
        allowPing = lib.mkDefault false;

        # make a much smaller and easier to read log
        logReversePathDrops = true;
        logRefusedConnections = false;

        # Don't filter DHCP packets, according to nixops-libvirtd
        checkReversePath = lib.mkForce false;
      };
    };

  };
}
