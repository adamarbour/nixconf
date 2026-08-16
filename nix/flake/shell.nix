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
                inputs.colmena.packages.${system}.colmena
                inputs.llm-agents.packages.${system}.claude-code
                # pkgs
                pkgs.dix
                pkgs.just
                pkgs.pciutils
                pkgs.usbutils
                pkgs.nixos-rebuild
                pkgs.openssh
                pkgs.sops
                pkgs.age
                pkgs.age-plugin-yubikey
                pkgs.ssh-to-age
                pkgs.wireguard-tools
                pkgs.qrencode
                pkgs.dig
                pkgs.nixos-anywhere
                # selfpkgs
                selfpkgs.git
                selfpkgs.nh
            ];
        };
    };
}
