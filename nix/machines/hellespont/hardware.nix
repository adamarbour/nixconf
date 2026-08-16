{
  flake.modules.nixos.hellespont = { lib, modulesPath, ... }: {

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];

    # not working for some reason so we force to Wi-Fi 5
    boot.extraModprobeConfig = ''
      options iwlwifi disable_11ax=1
    '';

    programs.gamemode.settings.gpu = {
      gpu_device = lib.mkForce 0;
      amd_performance_level = lib.mkForce "high";
    };

  };
}
