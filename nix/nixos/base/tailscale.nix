{
  flake.modules.nixos.base = { pkgs, lib, config, ... }: let
    inherit (config.services) tailscale;
  in {

    networking.firewall = {
      trustedInterfaces = [ "${tailscale.interfaceName}" ];
      checkReversePath = "loose";
      allowedUDPPorts = [ tailscale.port ];
    };

    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      disableUpstreamLogging = lib.mkDefault true;
      useRoutingFeatures = "client";
      extraSetFlags = [
        "--accept-dns=false"
        "--accept-routes"
        "--ssh"
      ];
    };

  };
}
