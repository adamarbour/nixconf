{ inputs, self, ... }:
{
  flake.modules.nixos.graphical = { pkgs, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {

    imports = with inputs; [
      nix-index-database.nixosModules.nix-index
    ];

    programs.nix-index-database.comma.enable = true;
    programs.nix-ld.enable = true;

    programs.direnv = {
      enable = true;
      silent = false;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
      };
    };

    environment.systemPackages = [
      pkgs.nixd
      pkgs.nixfmt
      pkgs.statix
      pkgs.deadnix
      pkgs.manix
      pkgs.nix-inspect
      pkgs.nix-init
      pkgs.nix-output-monitor
      selfpkgs.nh
    ];

  };
}
