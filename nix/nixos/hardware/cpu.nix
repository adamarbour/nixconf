{
  flake.modules.nixos.cpu-intel = {
    hardware.cpu.intel.updateMicrocode = true;

    boot.kernelModules = [ "kvm-intel" ];
  };

  flake.modules.nixos.cpu-amd = {
    hardware.cpu.amd.updateMicrocode = true;

    boot.kernelModules = [ "kvm-amd" "amd-pstate" ];
  };
}
