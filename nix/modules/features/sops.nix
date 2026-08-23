{ self, ... }:
{
  flake.modules.nixos.has-sops = { lib, config, ... }: {
    imports = with self.modules.nixos; [
      sops
    ];

    sops = {
      defaultSopsFile = config.nixSecrets.root + "/secrets/default.yaml";
      age = {
        generateKey = lib.mkDefault false;
        sshKeyPaths = [
          "/etc/ssh/ssh_host_ed25519_key"
        ];
      };
    };
  };
}
