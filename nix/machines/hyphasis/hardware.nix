{
  flake.modules.nixos.hyphasis = { lib, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

    hardware.cpu.intel.npu.enable = true;
    hardware.nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    boot.plymouth.enable = lib.mkForce false;
    boot.kernelParams = lib.mkForce [
       "loglevel=7" "ignore_loglevel"
      "nowatchdog"
      "nmi_watchdog=0"
      "boot.shell_on_fail"
      "systemd.log_level=debug"
      "rd.systemd.show_status=yes"
      "rd.udev.log_level=debug"
    ];
  };
}
