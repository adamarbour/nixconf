{
    flake.modules.nixos.hellespont = { lib, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "amdgpu" ];

        services.xserver.videoDrivers = [ "amdgpu" ];

    };
}
