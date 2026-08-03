{
    flake.modules.nixos.cirilla = { lib, modulesPath, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" "amdgpu" ];
        boot.extraModulePackages = [ ];

        services.xserver.videoDrivers = [ "amdgpu" ];

        hardware.graphics = {
            enable = true;
            enable32Bit = true; # Steam/Proton
        };

        hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
    };
}
