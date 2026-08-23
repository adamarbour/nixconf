{
  flake.modules.nixos.adam = { lib, config, ... }: {

    users.users.adam = lib.mkMerge [
      {
        isNormalUser = true;
        description = "Adam";
        extraGroups = [
          "networkmanager"
          "wheel"
          "deploy"
          "ssh-login"
        ];
      }
      (lib.mkIf (!config.nixSecrets.enable) {
        # Initial throwaway password: "nixos"
        initialHashedPassword = lib.mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
      })
      (lib.mkIf config.nixSecrets.enable {
        hashedPasswordFile = config.sops.secrets.passwd.path;
      })
    ];

    hjem.users.adam = {
      enable = true;
      user = "adam";
      directory = "/home/adam";
      clobberFiles = true;

      files = {
        ".ssh" = {
          type = "directory";
          permissions = "0700";
        };
        ".ssh/config" = {
          type = "copy";
          permissions = "0600";

          text = ''
            Host github.com
              HostName github.com
              User git
              IdentitiesOnly yes
              IdentityFile ~/.ssh/id_ed25519_yk1
              IdentityFile ~/.ssh/id_ed25519_yk2
          '';
        };
      };
    };

  };
}
