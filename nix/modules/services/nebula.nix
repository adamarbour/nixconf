{
  flake.modules.nixos.my-services =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.my.services;
    in
    {
      options.my.services.nebula = {
        enable = lib.mkEnableOption "enable nebula service";
      };

      config = lib.mkIf cfg.nebula.enable {
        sops.secrets = lib.mkIf config.nixSecrets.enable {
          "nebula-ca-crt" = {
            key = "nebula/ca-crt";
          };
        };
      };
    };
}
