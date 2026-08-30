{ inputs, self, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      selfpkgs = self.packages."${system}";
    in
    {
      devshells.default = {
        commands = [
          {
            name = "format";
            package = config.treefmt.build.wrapper;
            category = "quality";
            help = "Format the repository";
          }
          {
            name = "check";
            category = "quality";
            help = "Run flake checks";
            command = "nix flake check";
          }
          {
            name = "hooks";
            category = "quality";
            help = "Run all git hooks";
            command = ''
              ${pkgs.lib.getExe config.pre-commit.settings.package} \
                run --all-files \
                --config ${config.pre-commit.settings.configFile}
            '';
          }
        ];

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
          packages =
            config.pre-commit.settings.enabledPackages
            ++ (with pkgs; [
              inputs.disko.packages.${system}.disko
              inputs.llm-agents.packages.${system}.pi
              selfpkgs.my-git

              age
              age-plugin-yubikey
              yubikey-manager
              yubikey-personalization
              pcsc-tools
              ssh-to-age
              sops
              nixos-rebuild
              cachix
              dix
              just
              libfido2
              usbutils
              openssh
              nixos-anywhere
              nebula
            ]);

          startup.git-hooks.text = config.pre-commit.installationScript;
        };
      };
    };
}
