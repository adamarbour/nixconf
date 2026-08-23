 {
  flake.modules.nixos.grub-boot = { lib, ... }: {
    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      grub = {
        enable = true;
        useOSProber = lib.mkDefault false;
        efiSupport = lib.mkDefault false;
        enableCryptodisk = lib.mkDefault false;
        theme = null;
        backgroundColor = null;
        splashImage = null;
      };
    };
  };
}
