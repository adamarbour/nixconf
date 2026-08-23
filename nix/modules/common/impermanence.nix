{ self, ... }:
{
  flake.modules.nixos.common = { lib, config, ... }: let
    cfg = config.persistence;
  in {
    imports = with self.modules.nixos; [
      impermanence
    ];

    options.persistence = {
      enable = lib.mkEnableOption "enable impermanence";

      directories = lib.mkOption {
        default = [];
        description = ''
          directories to persist
        '';
      };

      files = lib.mkOption {
        default = [];
        description = ''
          files to persist
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      fileSystems."/persist".neededForBoot = true;
      programs.fuse.userAllowOther = true;

      environment.persistence = {
        "/persist/system" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
          ] ++ cfg.directories;
          files = [
            "/etc/machine-id"
          ] ++ cfg.files;
        };
      };
    };
  };
}
