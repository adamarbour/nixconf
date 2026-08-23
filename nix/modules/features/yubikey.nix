{
  flake.modules.nixos.has-yubikey = { pkgs, ... }: {
    programs.yubikey-manager.enable = true;
    services.pcscd.enable = true;

    environment.systemPackages = with pkgs; [
      age
      age-plugin-yubikey
      yubikey-manager
      pcsc-tools
      libfido2
      usbutils
    ];
  };
}
