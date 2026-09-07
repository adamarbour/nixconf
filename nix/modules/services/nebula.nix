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
          };
          "nebula-crt" = {
            sopsFile = config.nixSecrets.hostFile;
            key = "nebula/host-crt";
          };
        };

        services.nebula.networks.backplane = {
          enable = true;

          ca = config.sops.secrets."nebula-ca-crt".path;
          cert = config.sops.secrets."nebula-crt".path;
          key = config.sops.secrets."nebula-key".path;

          isLighthouse = false;
          isRelay = false;

          lighthouses = [ ];
          relays = [ ];

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
