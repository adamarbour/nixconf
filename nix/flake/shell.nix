{ inputs, self, ... }:
{
    perSystem = { pkgs, ... }: let
        system = pkgs.stdenv.hostPlatform.system;
        selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
    in {
        devshells.default = {
            # definition
            devshell.name = "bootstrap";
            devshell.meta.description = "devshell used to bootstrap the configuration";
            # packages
            devshell.packages = [
                # inputs
                inputs.disko.packages.${system}.disko
                # pkgs
                pkgs.dix
                # selfpkgs
                selfpkgs.git
            ];
        };
    };
}
