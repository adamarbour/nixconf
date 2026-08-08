{
    flake.modules.nixos.hellespont = { lib, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" "amdgpu" ];

        services.xserver.videoDrivers = [ "amdgpu" ];

        hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
    };
}
