{
  flake.modules.nixos.systemd-boot = { lib, ... }: {
    boot.loader = {
      grub.enable = lib.mkForce false;
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = lib.mkDefault "max"; # the default is "keep"

        # Fix a security hole. See desc in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
        editor = false;
      };
    };
  };
}
