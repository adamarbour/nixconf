{ self, ... }:
{
  flake.modules.nixos.laptop = {
    imports = with self.modules.nixos; [
      systemd-boot
      networkmanager
      graphical
      has-wifi
    ];
  };
}
