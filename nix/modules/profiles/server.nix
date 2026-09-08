{ self, ... }:
{
<<<<<<< HEAD
  flake.modules.nixos.server = { lib, ... }: {
||||||| parent of ca25adc (Fix server kernel)
  flake.modules.nixos.server = {
=======
  flake.modules.nixos.server = { pkgs, ... }: {
>>>>>>> ca25adc (Fix server kernel)
    imports = with self.modules.nixos; [
      grub-boot
      networkd
      user-deploy
    ];

    boot.kernelPackages = pkgs.linuxPackages;

    powerManagement = {
      cpuFreqGovernor = "schedutil";
      powertop.enable = true;
    };

    my.services = {
      sshguard.enable = true;
      tailscale.exitNode = lib.mkDefault true;
    };
  };
}
