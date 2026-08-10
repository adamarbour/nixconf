{
  flake.modules.nixos.server = { lib, ... }: {

    networking = {
      wireless.enable = lib.mkDefault false;
      useNetworkd = lib.mkForce true;
    };

    services.tailscale = {
      useRoutingFeatures = "server";
      extraSetFlags = [
        "--advertise-exit-node"
      ];
    };

  };
}
