{ inputs, self, ... }:
{
  flake.modules.nixos.laptop = { lib, config, ... }: {

    boot = {
      kernel.sysctl = {
        "vm.dirty_writeback_centisecs" = 6000;
        "vm.laptop_mode" = 5;
      };
      kernelModules = [ "acpi_call" ];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

    services.acpid.enable = true;

    services.power-profiles-daemon.enable = lib.mkForce true; # prefer ppd
    services.tlp.enable = lib.mkForce false;
    services.auto-cpufreq.enable = lib.mkForce false;
    services.tuned.enable = lib.mkForce false;

    services.upower = {
      enable = lib.mkDefault true;
      percentageLow = 15;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
      powertop.enable = true;
    };

    systemd.tmpfiles.rules = [
      "f /sys/class/rtc/rtc0/wakealarm 0664 root root -"
    ];

  };
}
