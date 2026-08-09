{
  flake.modules.nixos.server = { lib, ... }: {

    networking = {
      wireless.enable = lib.mkDefault false;
      useNetworkd = lib.mkForce true;
    };

    services.tailscale = {
      extraSetFlags = [
        "--advertise-exit-node"
      ];
    };

  };
}
