{ inputs, self, ... }:
{
  perSystem.devshells.default = { pkgs, ... }: let
    system = pkgs.stdenv.hostPlatform.system;
    selfpkgs = self.packages."${system}";
  in {
    commands = [];

    env = [
      {
        name = "NIX_CONFIG";
        value = "experimental-features = nix-command flakes";
      }
      {
        name = "GIT_AUTHOR_NAME";
        value = "Adam Arbour";
      }
      {
        name = "GIT_AUTHOR_EMAIL";
        value = "845679+adamarbour@users.noreply.github.com";
      }
      {
        name = "GIT_COMMITTER_NAME";
        value = "Adam Arbour";
      }
      {
        name = "GIT_COMMITTER_EMAIL";
        value = "845679+adamarbour@users.noreply.github.com";
      }
    ];

    devshell = {
      name = "bootstrap";
      meta.description = "devshell used to bootstrap the configuration";

      # packages
      packages = with pkgs; [
        inputs.disko.packages.${system}.disko
        selfpkgs.my-git

        age
        ssh-to-age
        sops
        nixos-rebuild
        cachix
        dix
        just
      ];
    };
  };
}
