{
  flake.modules.nixos.base = { pkgs, lib, ... }: {

    boot = {
      loader.timeout = lib.mkDefault 3;
      consoleLogLevel = 3;

      loader.grub.configurationLimit = lib.mkDefault 5;
      loader.systemd-boot.configurationLimit = lib.mkDefault 5;

      loader.efi.canTouchEfiVariables = true;

      kernelParams = [
        "nowatchdog"
        "nmi_watchdog=0"
      ];

      kernel.sysfs = {
        kernel.mm.transparent_hugepage = {
          enabled = "always";
          defrag = "defer";
          shmem_enabled = "within_size";
        };
      };
      initrd = {
        verbose = false;
      };
    };

  };
}
