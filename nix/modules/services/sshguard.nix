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
      options.my.services.sshguard = {
        enable = lib.mkEnableOption "enable sshguard";
      };

      config = lib.mkIf cfg.sshguard.enable {
        services.sshguard = {
          enable = lib.mkDefault true;
          attack_threshold = lib.mkDefault 30;
          blocktime = lib.mkDefault 120;
          detection_time = lib.mkDefault 1800;
          whitelist = [
            "10.254.0.0/24" # nebula
          ];
        };
      };
    };
}
