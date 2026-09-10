{ self, ... }:
{
  flake.modules.nixos.adam =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
    in
    {
      users.users.adam = lib.mkMerge [
        {
          isNormalUser = true;
          description = "Adam";
          extraGroups = [
            "networkmanager"
            "wheel"
            "deploy"
            "ssh-login"
            "incus-admin"
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

      sops.secrets = lib.mkIf config.nixSecrets.enable {
        "my-ssh/key" = {
          owner = "adam";
          group = "users";
          mode = "0400";
          path = "/home/adam/.ssh/id_ed25519";
        };
        "my-ssh/pub" = {
          owner = "adam";
          group = "users";
          mode = "0444";
          path = "/home/adam/.ssh/id_ed25519.pub";
        };
      };

      environment.sessionVariables = {
        GIT_AUTHOR_NAME = "Adam Arbour";
        GIT_AUTHOR_EMAIL = "845679+adamarbour@users.noreply.github.com";
        GIT_COMMITTER_NAME = "Adam Arbour";
        GIT_COMMITTER_EMAIL = "845679+adamarbour@users.noreply.github.com";
      };

      hjem.users.adam = {
        enable = true;
        user = "adam";
        directory = "/home/adam";
        clobberFiles = true;

        packages = with pkgs; [
          selfpkgs.my-git
          age
          sops
          ssh-to-age
        ];

        files = {
          ".ssh/config" = {
            text = ''
              Host *
                IdentitiesOnly yes
                IdentityFile ~/.ssh/id_ed25519
                IdentityFile ~/.ssh/id_ed25519_yk1
                IdentityFile ~/.ssh/id_ed25519_yk2
            '';
          };
        };
      };

    };
}
