{
  flake.modules.nixos.has-yubikey = { pkgs, ... }: {
    programs.yubikey-manager.enable = true;

    environment.systemPackages = with pkgs; [
      libfido2
      usbutils
    ];
  };
}
