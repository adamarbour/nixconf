{ inputs, self, ... }:
{
    flake.modules.nixos.graphical = { pkgs, lib, ... }: let
        selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
    in {
        # locale
        services.xserver.xkb = {
            layout = "us";
            variant = "";
        };

        # graphical
        environment.systemPackages = with pkgs; [
            kitty
            neovide
            # development
            github-cli
            # selfpkgs
            selfpkgs.nh
        ];

        # hardware assumption
        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };

        # boot
        boot = {
            # increase the map count, this is important for applications that require a lot of memory mappings
            # such as games and emulators
            kernel.sysctl."vm.max_map_count" = 2147483642;

            # assume silent boot
            plymouth = {
                enable = true;
                theme = "bgrt";
            };
            kernelParams = [
                # silent
                "quiet"
                "loglevel=3"
                "udev.log_level=3"
                "rd.udev.log_level=3"
                "systemd.show_status=auto"
                "rd.systemd.show_status=auto"

                # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
                # auto means kernel will automatically decide the pti state
                "pti=auto" # on || off

                # enable IOMMU for devices used in passthrough and provide better host performance
                "iommu=pt"

                # allow systemd to set and save the backlight state
                "acpi_backlight=native"

                # prevent the kernel from blanking plymouth out of the fb
                "fbcon=nodefer"

                # disable the cursor in vt to get a black screen during intermissions
                "vt.global_cursor_default=0"
            ];
        };
    };
}
