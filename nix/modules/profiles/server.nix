{ self, ... }:
{
  flake.modules.nixos.server = {
    imports = with self.modules.nixos; [
      grub-boot
      deploy-user
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
