{ self, ... }:
{
  flake.modules.nixos.server = {
    imports = with self.modules.nixos; [
      grub-boot
      user-deploy
    ];

    powerManagement = {
      cpuFreqGovernor = "schedutil";
      powertop.enable = true;
    };

    my.services = {
      sshguard.enable = true;
    };
  };
}
