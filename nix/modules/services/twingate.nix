{
  flake.modules.nixos.my-services =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.my.services;
    in
    {
      options.my.services.twingate = {
        enable = lib.mkEnableOption "enable twingate";
      };

      config = lib.mkIf cfg.twingate.enable {
        services.twingate = {
          enable = true;
          package = pkgs.unstable.twingate;
        };
      };
    };
}
