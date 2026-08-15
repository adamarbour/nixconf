{
  flake.modules.nixos.hellespont = { lib, modulesPath, ... }: {

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];

    programs.gamemade.settings.gpu = {
      gpu_device = lib.mkForce 0;
      amd_performance_level = lib.mkForce "high";
    };

  };
}
