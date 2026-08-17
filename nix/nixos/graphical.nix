{ inputs, self, ... }:
{
  flake.modules.nixos.graphical = { pkgs, lib, ... }: {
    imports = [
      self.modules.nixos.base
    ];

    # boot
    boot = {
      # increase the map count, this is important for applications that require a lot of memory mappings
      # such as games and emulators
      kernel.sysctl."vm.max_map_count" = 2147483642;

      kernelParams = [
        # enable IOMMU for devices used in passthrough and provide better host performance
        "iommu=pt"

        # allow systemd to set and save the backlight state
        "acpi_backlight=native"
      ];
    };
  };
}
