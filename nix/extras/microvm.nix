{ inputs, ... }:
{
  flake.modules.nixos.microvm = { lib, ... }: {
    imports = with inputs; [
      microvm.nixosModules.microvm
    ];

    microvm.hypervisor = lib.mkDefault "cloud-hypervisor";
  };
}
