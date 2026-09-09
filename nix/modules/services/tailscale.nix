{
  flake.modules.nixos.my-services =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.my.services;
      inherit (config.services) tailscale;
    in
    {
      options.my.services.tailscale = {
        enable = lib.mkEnableOption "enable tailscale";

        exitNode = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "advertise this host as a tailnet exit node.";
        };
        advertiseRoutes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "subnets this host advertises as a subnet router.";
        };
      };

      config = lib.mkIf cfg.tailscale.enable {
        services.tailscale = {
          enable = true;
          openFirewall = true;
          useRoutingFeatures =
            if cfg.tailscale.exitNode || cfg.tailscale.advertiseRoutes != [ ] then "both" else "none";

          extraSetFlags = [
            "--accept-dns=false"
            "--ssh"
          ];
        };

        networking.firewall.trustedInterfaces = [ "${tailscale.interfaceName}" ];
        networking.firewall.checkReversePath = lib.mkIf (
          cfg.tailscale.exitNode || cfg.tailscale.advertiseRoutes != [ ]
        ) (lib.mkDefault "loose");

        boot.kernel.sysctl = lib.mkIf cfg.tailscale.exitNode {
          "net.ipv4.ip_forward" = lib.mkDefault 1;
          "net.ipv6.conf.all.forwarding" = lib.mkDefault 1;
        };
      };
    };
}
