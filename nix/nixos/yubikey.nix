{
    flake.modules.nixos.yubikey = { pkgs, ... }: {
        services.pcsdc.enable = true;
        services.udev.packages = [ pkgs.yubikey-personalization ];
        environment.systemPackages = with pkgs; [
            yubikey-manager
            yubikey-personalization
            yubico-piv-tool
        ];
        security.pam.u2f.enable = true;
    };
}
