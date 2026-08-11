{
  flake.modules.nixos.hyphasis = { lib, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

    services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
    hardware.cpu.intel.npu.enable = true;
    hardware.nvidia = {
      open = false;
      nvidiaSettings = false;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        sync.enable = lib.mkForce false;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
}
