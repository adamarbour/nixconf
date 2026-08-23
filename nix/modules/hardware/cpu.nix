{
  flake.modules.nixos = {
    hw-cpu-amd = { lib, config, ... }: {
      boot.kernelModules = [
        "kvm-amd"
        "amd-pstate"
      ];
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    hw-cpu-intel = { lib, config, ... }: {
      boot.kernelModules = [ "kvm-intel" ];
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
