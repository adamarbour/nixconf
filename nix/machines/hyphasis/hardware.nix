{
  flake.modules.nixos.hyphasis = { lib, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

    hardware.cpu.intel.npu.enable = true;
  };
}
