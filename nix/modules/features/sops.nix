{ self, ... }:
{
  flake.modules.nixos.has-sops = { lib, config, ... }: {
    imports = with self.modules.nixos; [
      sops
    ];

    options.nixSecrets = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable SOPS-based secrets management.";
      };
    };

    config = lib.mkIf config.nixSecrets.enable {
      sops = {
        defaultSopsFile = config.nixSecrets.root + "/default.yaml";
        age = {
          generateKey = lib.mkDefault false;
          sshKeyPaths = [
            "/etc/ssh/ssh_host_ed25519_key"
          ];
        };

        secrets.passwd.neededForUsers = true;
      };
    };
  };
}
