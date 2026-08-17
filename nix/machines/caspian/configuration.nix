{ inputs, self, ... }:
{
  flake.modules.nixos.caspian = { pkgs, modulesPath, ... }: {
    imports = [
      # profiles
      self.modules.nixos.server

      # hardware
      (modulesPath + "/profiles/qemu-guest.nix")
      ## disko
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.caspian

      # software
      self.modules.nixos.boot-grub
    ];

    boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
    boot.loader.grub.devices = [ "/dev/vda" ];

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "caspian";
}
