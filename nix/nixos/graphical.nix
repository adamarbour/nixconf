{ inputs, self, ... }:
{
    flake.modules.nixos.graphical = { pkgs, lib, ... }: {
        # locale
        services.xserver.xkb = {
            layout = "us";
            variant = "";
        };

        # graphical
        environment.systemPackages = with pkgs; [
            kitty
            neovide
            # development
            github-cli
        ];

        # hardware assumption
        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };
    };
}
