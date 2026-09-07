{ self, ... }:
{
  flake.modules.nixos.my-services =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.my.services;
      fleet = import (self + /nix/hosts/_fleet.nix) { inherit lib; };

      hostName = config.networking.hostName;
      self' =
        fleet.hosts.${hostName}
          or (throw "my.services.nebula: '${hostName}' has no entry in modules/nebula/_fleet.nix");

      lighthouseHosts = lib.filterAttrs (_: h: h.lighthouse or false) fleet.hosts;
      relayHosts = lib.filterAttrs (_: h: h.relay or false) fleet.hosts;

      lighthouseAddrs = lib.mapAttrsToList (_: h: h.overlayIP) lighthouseHosts;
      relayAddrs = lib.mapAttrsToList (_: h: h.overlayIP) relayHosts;

      staticHostMap = lib.mapAttrs' (_: h: lib.nameValuePair h.overlayIP [ h.publicEndpoint ]) (
        lib.filterAttrs (_: h: h ? publicEndpoint) fleet.hosts
      );
    in
    {
      options.my.services.nebula = {
        enable = lib.mkEnableOption "enable nebula service";
        canSign = lib.mkEnableOption "enable nebula CA sign";
        port = lib.mkOption {
          type = lib.types.port;
          default = 4242;
          description = "UDP port this nebula node listens on.";
        };
      };

      config = lib.mkIf cfg.nebula.enable {
        assertions = [
          {
            assertion = fleet.hosts ? ${hostName};
            message = "my.services.nebula: '${hostName}' missing from modules/nebula/_fleet.nix";
          }
          {
            assertion = (self'.lighthouse or false || self'.relay or false) -> (self' ? publicEndpoint);
            message = "my.services.nebula: '${hostName}' is a lighthouse/relay but has no publicEndpoint";
          }
        ];

        sops.secrets = lib.mkIf config.nixSecrets.enable {
          "nebula-ca-crt" = {
            key = "nebula/ca-crt";
            mode = "0444";
          };
          "nebula-ca-key" = lib.mkIf cfg.nebula.canSign {
            key = "nebula/ca-key";
            owner = "adam";
            mode = "0400";
          };
          "nebula-key" = {
            sopsFile = config.nixSecrets.hostFile;
            key = "nebula/host-key";
            owner = "nebula-backplane";
            mode = "0444";
          };
          "nebula-crt" = {
            sopsFile = config.nixSecrets.hostFile;
            key = "nebula/host-crt";
            owner = "nebula-backplane";
            mode = "0444";
          };
        };

        services.nebula.networks.backplane = {
          enable = true;

          ca = config.sops.secrets."nebula-ca-crt".path;
          cert = config.sops.secrets."nebula-crt".path;
          key = config.sops.secrets."nebula-key".path;

          isLighthouse = lib.mkDefault (self'.lighthouse or false);
          isRelay = lib.mkDefault (self'.relay or false);

          lighthouses = lib.mkIf (!(self'.lighthouse or false)) lighthouseAddrs;
          relays = relayAddrs;
          inherit staticHostMap;

          listen.port = cfg.nebula.port;

          firewall.inbound = lib.mkDefault [
            {
              port = "any";
              proto = "any";
              host = "any";
            }
          ];
          firewall.outbound = lib.mkDefault [
            {
              port = "any";
              proto = "any";
              host = "any";
            }
          ];
        };

        networking.firewall.allowedUDPPorts = [ cfg.nebula.port ];

        environment.systemPackages = lib.mkIf cfg.nebula.canSign [
          (pkgs.writeShellScriptBin "nebula-sign-host" ''
            nebula-cert sign \
              -ca-crt ${config.sops.secrets."nebula-ca-crt".path} \
              -ca-key ${config.sops.secrets."nebula-ca-key".path} \
              "$@"
          '')
        ];
      };
    };
}
